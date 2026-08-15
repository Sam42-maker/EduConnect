const express = require('express');
const router = express.Router();
const mentorController = require('../controllers/mentorController');

router.get('/', mentorController.getAllMentors);
router.post('/book', mentorController.bookMentor);
router.post('/promote', mentorController.promoteMentor);

module.exports = router;
