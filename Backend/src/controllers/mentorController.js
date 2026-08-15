const db = require('../config/db');

// 1. Dapatkan daftar semua mentor beserta keahliannya
exports.getAllMentors = async (req, res) => {
  try {
    const [mentors] = await db.query(`
      SELECT m.user_id as id, m.is_verified, m.rating, m.reviews, m.price,
             u.full_name as name, u.major as field, u.bio as description
      FROM mentors m
      JOIN user_profiles u ON m.user_id = u.user_id
    `);

    // Ambil tag (badge dan expertise)
    const [tags] = await db.query('SELECT * FROM mentor_expertise');

    const formattedMentors = mentors.map(m => {
      const mentorTags = tags.filter(t => t.mentor_id === m.id);
      return {
        id: m.id.toString(),
        name: m.name,
        isVerified: m.is_verified === 1,
        badges: mentorTags.filter(t => t.tag_type === 'badge').map(t => t.tag_name),
        field: m.field,
        expertise: mentorTags.filter(t => t.tag_type === 'expertise').map(t => t.tag_name),
        description: m.description || '',
        rating: parseFloat(m.rating),
        reviews: m.reviews,
        price: m.price
      };
    });

    res.json(formattedMentors);
  } catch (error) {
    console.error('Error in getAllMentors:', error);
    res.status(500).json({ message: 'Terjadi kesalahan server saat mengambil data mentor' });
  }
};

// 2. Buat sesi pemesanan baru (Booking & Payment)
exports.bookMentor = async (req, res) => {
  try {
    const { studentId, mentorId, topic, scheduleDate, scheduleTime, notes, paymentMethod, amount } = req.body;
    
    const [result] = await db.query(
      `INSERT INTO mentor_bookings 
        (student_id, mentor_id, topic, schedule_date, schedule_time, notes, payment_method, amount) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [studentId, mentorId, topic, scheduleDate, scheduleTime, notes, paymentMethod, amount]
    );

    // Kirim notifikasi real-time via Socket.IO (opsional, untuk mentor)
    const io = req.app.get('io');
    if (io) {
      io.to(`user_${mentorId}`).emit('new_booking', {
        bookingId: result.insertId,
        studentId,
        topic,
        scheduleDate,
        scheduleTime
      });
    }

    res.status(201).json({ 
      success: true, 
      message: 'Booking berhasil disimpan',
      bookingId: result.insertId 
    });
  } catch (error) {
    console.error('Error in bookMentor:', error);
    res.status(500).json({ message: 'Terjadi kesalahan server saat menyimpan data pemesanan' });
  }
};

// 3. Promosikan pengguna sebagai mentor
exports.promoteMentor = async (req, res) => {
  try {
    const { userId, price, description, expertise } = req.body;

    // Cek apakah user sudah jadi mentor
    const [existing] = await db.query('SELECT * FROM mentors WHERE user_id = ?', [userId]);
    
    if (existing.length === 0) {
      // Buat mentor baru (is_verified = 1 otomatis demi prototype ini)
      await db.query(
        'INSERT INTO mentors (user_id, is_verified, rating, reviews, price) VALUES (?, 1, 5.0, 0, ?)',
        [userId, price || 100000]
      );
    } else {
      // Update data mentor
      await db.query(
        'UPDATE mentors SET price = ? WHERE user_id = ?',
        [price || 100000, userId]
      );
    }

    // Jika ada expertise (minat), masukkan ke mentor_expertise
    if (expertise && Array.isArray(expertise)) {
      await db.query('DELETE FROM mentor_expertise WHERE mentor_id = ? AND tag_type = "expertise"', [userId]);
      for (const tag of expertise) {
        await db.query(
          'INSERT INTO mentor_expertise (mentor_id, tag_name, tag_type) VALUES (?, ?, "expertise")',
          [userId, tag]
        );
      }
    }

    // Fetch the updated mentor data to broadcast
    const [mentorData] = await db.query(`
      SELECT m.user_id as id, m.is_verified, m.rating, m.reviews, m.price,
             u.full_name as name, u.major as field, u.bio as description
      FROM mentors m
      JOIN user_profiles u ON m.user_id = u.user_id
      WHERE m.user_id = ?
    `, [userId]);

    const m = mentorData[0];
    const [tags] = await db.query('SELECT * FROM mentor_expertise WHERE mentor_id = ?', [userId]);
    
    const formattedMentor = {
      id: m.id.toString(),
      name: m.name,
      isVerified: m.is_verified === 1,
      badges: tags.filter(t => t.tag_type === 'badge').map(t => t.tag_name),
      field: m.field,
      expertise: tags.filter(t => t.tag_type === 'expertise').map(t => t.tag_name),
      description: description || m.description || '',
      rating: parseFloat(m.rating),
      reviews: m.reviews,
      price: m.price
    };

    // Broadcast ke semua client
    const io = req.app.get('io');
    if (io) {
      io.emit('new_mentor_added', formattedMentor);
    }

    res.status(200).json({
      success: true,
      message: 'Berhasil dipromosikan sebagai mentor',
      mentor: formattedMentor
    });
  } catch (error) {
    console.error('Error in promoteMentor:', error);
    res.status(500).json({ message: 'Terjadi kesalahan server saat promosi mentor' });
  }
};
