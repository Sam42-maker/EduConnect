const express = require('express');
const router = express.LexicalRouter ? express.LexicalRouter() : express.Router();
const matchController = require('../controllers/MatchController');
const { protect } = require('../controllers/AuthController'); // Middleware untuk memverifikasi JWT

// Endpoint untuk mendapatkan daftar mahasiswa yang cocok
router.get('/discover', protect, matchController.getDiscoverFeed);

// Endpoint untuk mengirim permintaan koneksi
router.post('/request', protect, matchController.sendConnectionRequest);

module.exports = router;
