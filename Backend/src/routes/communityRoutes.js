const express = require("express");
const router = express.Router();
const communityController = require("../controllers/communityController");

router.get("/", communityController.getCommunities);
router.post("/", communityController.createCommunity);
router.get("/:communityId/channels", communityController.getChannels);
router.get("/channels/:channelId/messages", communityController.getMessages);

module.exports = router;
