const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// @route   POST /api/auth/register
// @desc    Mendaftarkan user baru
// @access  Public
router.post('/register', authController.register);

// @route   POST /api/auth/login
// @desc    Login user dan kembalikan token
// @access  Public
router.post('/login', authController.login);

module.exports = router;
