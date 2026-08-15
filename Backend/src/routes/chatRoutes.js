const express = require("express");
const router = express.Router();
const chatController = require("../controllers/chatController");

router.get("/", chatController.getRecentChats);
router.get("/:partnerId", chatController.getChatHistory);

module.exports = router;
