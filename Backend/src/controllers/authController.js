const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

exports.register = async (req, res) => {
  try {
    const { fullName, email, password, phone, role } = req.body;

    // Sequelize syntax: findOne({ where: { email } })
    let user = await User.findOne({ where: { email } });
    if (user) {
      return res.status(400).json({ message: 'Email sudah terdaftar' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const otp = generateOTP();
    const otpExpires = new Date(Date.now() + 10 * 60 * 1000);

    // Sequelize syntax: create
    user = await User.create({
      fullName,
      email,
      password: hashedPassword,
      phone,
      role,
      otp,
      otpExpires,
    });

    const mailOptions = {
      from: '"EduConnect" <no-reply@educonnect.com>',
      to: user.email,
      subject: 'Kode Verifikasi EduConnect (OTP)',
      text: `Halo ${user.fullName}, kode verifikasi Anda adalah: ${otp}. Kode ini berlaku selama 10 menit.`,
    };

    try {
      await transporter.sendMail(mailOptions);
    } catch (error) {
      console.log('Gagal kirim email:', error.message);
    }

    res.status(201).json({ 
      message: 'Registrasi berhasil. Silakan cek email Anda untuk kode OTP.',
      email: user.email
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

exports.verifyOTP = async (req, res) => {
  try {
    const { email, otp } = req.body;

    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(400).json({ message: 'User tidak ditemukan' });
    }

    if (user.otp !== otp || user.otpExpires < new Date()) {
      return res.status(400).json({ message: 'OTP tidak valid atau sudah kadaluarsa' });
    }

    user.isVerified = true;
    user.otp = null;
    user.otpExpires = null;
    await user.save(); // Sequelize save

    const payload = { user: { id: user.id, role: user.role } };
    const token = jwt.sign(payload, process.env.JWT_SECRET || 'secret_key', { expiresIn: '7d' });

    res.status(200).json({ 
      message: 'Verifikasi berhasil!', 
      token,
      user: { id: user.id, fullName: user.fullName, role: user.role }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(400).json({ message: 'Email atau password salah' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Email atau password salah' });
    }

    if (!user.isVerified) {
      const otp = generateOTP();
      user.otp = otp;
      user.otpExpires = new Date(Date.now() + 10 * 60 * 1000);
      await user.save();

      console.log(`Resending OTP to ${email}: ${otp}`);

      return res.status(403).json({ 
        message: 'Akun belum diverifikasi. Kode OTP baru telah dikirim ke email.',
        requiresOTP: true 
      });
    }

    const payload = { user: { id: user.id, role: user.role } };
    const token = jwt.sign(payload, process.env.JWT_SECRET || 'secret_key', { expiresIn: '7d' });

    res.status(200).json({ 
      message: 'Login berhasil!', 
      token,
      user: { id: user.id, fullName: user.fullName, role: user.role }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};
