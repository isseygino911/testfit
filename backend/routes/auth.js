const express = require('express');
const { signup, login, getMe } = require('../controllers/authController');

const router = express.Router();

// Auth routes
router.post('/signup', signup);
router.post('/login', login);
router.get('/me', getMe);

module.exports = router;
