const pool = require("../config/db");

exports.getProfile = async (req, res) => {
  const userId = parseInt(req.params.userId);

  try {
    // Ambil data profile dasar
    const [profileRows] = await pool.execute(
      `SELECT p.*, u.email, u.role
       FROM user_profiles p
       JOIN users u ON p.user_id = u.id
       WHERE p.user_id = ?`,
      [userId]
    );

    if (profileRows.length === 0) {
      return res.status(404).json({ success: false, message: "Profile not found" });
    }

    const profile = profileRows[0];

    // Ambil data interest tags
    const [interestRows] = await pool.execute(
      `SELECT subject_name FROM user_interests WHERE user_id = ?`,
      [userId]
    );

    const tags = interestRows.map(row => row.subject_name);

    // Format availability string to JSON if needed
    let parsedAvailability = [];
    try {
      parsedAvailability = JSON.parse(profile.availability || '[]');
    } catch (e) {
      parsedAvailability = [];
    }

    res.json({
      success: true,
      data: {
        ...profile,
        tags,
        availability: parsedAvailability
      }
    });
  } catch (error) {
    console.error("Error fetching profile:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

exports.updateProfile = async (req, res) => {
  const userId = parseInt(req.params.userId);
  const {
    full_name,
    institution,
    major,
    current_semester,
    study_phase,
    objective,
    availability,
    tags
  } = req.body;

  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // 1. Update user_profiles
    const availabilityStr = JSON.stringify(availability || []);
    await connection.execute(
      `UPDATE user_profiles 
       SET full_name = ?, institution = ?, major = ?, current_semester = ?, study_phase = ?, objective = ?, availability = ?
       WHERE user_id = ?`,
      [
        full_name || '',
        institution || '',
        major || '',
        current_semester || '',
        study_phase || '',
        objective || '',
        availabilityStr,
        userId
      ]
    );

    // 2. Update user_interests (delete old, insert new)
    if (tags && Array.isArray(tags)) {
      await connection.execute(`DELETE FROM user_interests WHERE user_id = ?`, [userId]);
      
      for (const tag of tags) {
        await connection.execute(
          `INSERT INTO user_interests (user_id, subject_name) VALUES (?, ?)`,
          [userId, tag]
        );
      }
    }

    await connection.commit();
    res.json({ success: true, message: "Profile updated successfully" });
  } catch (error) {
    await connection.rollback();
    console.error("Error updating profile:", error);
    res.status(500).json({ success: false, message: "Failed to update profile" });
  } finally {
    connection.release();
  }
};
