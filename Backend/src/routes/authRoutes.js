const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// @route   POST /api/auth/register
// @desc    Mendaftarkan user baru & kirim OTP
// @access  Public
router.post('/register', authController.register);

// @route   POST /api/auth/login
// @desc    Login user dan kembalikan token (atau minta OTP)
// @access  Public
router.post('/login', authController.login);

// @route   POST /api/auth/verify-otp
// @desc    Verifikasi kode OTP
// @access  Public
router.post('/verify-otp', authController.verifyOTP);

module.exports = router;
