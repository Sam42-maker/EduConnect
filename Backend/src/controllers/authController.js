const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.register = async (req, res) => {
  try {
    const { email, password, role, fullName } = req.body; 

    // Cek apakah email sudah terdaftar
    const [existingUser] = await req.db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (existingUser.length > 0) {
      return res.status(400).json({ message: 'Email sudah terdaftar' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Insert user
    const [result] = await req.db.query(
      'INSERT INTO users (email, password_hash, role) VALUES (?, ?, ?)',
      [email, hashedPassword, role || 'Student']
    );

    // Insert user profile if fullName is provided
    if (fullName) {
      await req.db.query(
        'INSERT INTO user_profiles (user_id, full_name) VALUES (?, ?)',
        [result.insertId, fullName]
      );
    }

    const payload = { user: { id: result.insertId, role: role || 'Student' } };
    const token = jwt.sign(payload, process.env.JWT_SECRET || 'secret_key', { expiresIn: '7d' });

    res.status(201).json({ 
      message: 'Registrasi berhasil.',
      token,
      user: { id: result.insertId, email, role, name: fullName }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const [users] = await req.db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (users.length === 0) {
      return res.status(400).json({ message: 'Email atau password salah' });
    }

    const user = users[0];
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(400).json({ message: 'Email atau password salah' });
    }

    // Fetch full name from user_profiles
    let fullName = user.email; // fallback
    try {
      const [profiles] = await req.db.query('SELECT full_name FROM user_profiles WHERE user_id = ?', [user.id]);
      if (profiles.length > 0 && profiles[0].full_name) {
        fullName = profiles[0].full_name;
      }
    } catch (e) {
      console.error('Error fetching profile:', e);
    }

    const payload = { user: { id: user.id, role: user.role } };
    const token = jwt.sign(payload, process.env.JWT_SECRET || 'secret_key', { expiresIn: '7d' });

    res.status(200).json({ 
      message: 'Login berhasil!', 
      token,
      user: { id: user.id, email: user.email, role: user.role, name: fullName }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    const [users] = await req.db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (users.length === 0) {
      return res.status(400).json({ message: 'Kami tidak menemukan akun dengan email tersebut.' });
    }

    const user = users[0];
    
    // Generate 8-character random password (like the PHP script)
    const chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    let newPassword = '';
    for (let i = 0; i < 8; i++) {
      newPassword += chars.charAt(Math.floor(Math.random() * chars.length));
    }

    // Hash it
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(newPassword, salt);

    // Update DB
    await req.db.query('UPDATE users SET password_hash = ? WHERE id = ?', [hashedPassword, user.id]);

    res.status(200).json({
      message: 'Password berhasil direset.',
      newPassword: newPassword
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

// Simplified protection middleware
exports.protect = async (req, res, next) => {
  let token;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
  }
  
  if (!token) {
    return res.status(401).json({ message: 'Not authorized to access this route' });
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret_key');
    req.user = decoded.user;
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Not authorized to access this route' });
  }
};
