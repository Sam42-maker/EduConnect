const pool = require("../config/db");

// Ambil daftar komunitas
exports.getCommunities = async (req, res) => {
  try {
    const [rows] = await pool.execute("SELECT * FROM communities ORDER BY created_at DESC");
    
    // Parse tags (karena disimpen sebagai string JSON array)
    const communities = rows.map(c => {
      let parsedTags = [];
      try {
        parsedTags = JSON.parse(c.tags);
      } catch (e) {}
      
      return {
        ...c,
        tags: parsedTags
      };
    });

    res.json({ success: true, data: communities });
  } catch (error) {
    console.error("Error fetching communities:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

// Bikin komunitas baru
exports.createCommunity = async (req, res) => {
  const { name, description, privacy, icon_initial, objective, tags, creator_id, textChannels, voiceChannels } = req.body;
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // 1. Insert Community
    const tagsStr = JSON.stringify(tags || []);
    const [result] = await connection.execute(
      "INSERT INTO communities (name, description, privacy, icon_initial, objective, tags, creator_id) VALUES (?, ?, ?, ?, ?, ?, ?)",
      [name, description, privacy || "Public", icon_initial || "C", objective || "Umum", tagsStr, creator_id || 1]
    );
    const communityId = result.insertId;

    // 2. Insert Text Channels
    if (textChannels && Array.isArray(textChannels)) {
      for (const t of textChannels) {
        await connection.execute(
          "INSERT INTO channels (community_id, name, type) VALUES (?, ?, 'text')",
          [communityId, t]
        );
      }
    } else {
      // Default channel
      await connection.execute(
        "INSERT INTO channels (community_id, name, type) VALUES (?, ?, 'text')",
        [communityId, "#general"]
      );
    }

    // 3. Insert Voice Channels
    if (voiceChannels && Array.isArray(voiceChannels)) {
      for (const v of voiceChannels) {
        await connection.execute(
          "INSERT INTO channels (community_id, name, type) VALUES (?, ?, 'voice')",
          [communityId, v]
        );
      }
    }

    await connection.commit();
    res.status(201).json({ success: true, message: "Komunitas berhasil dibuat", communityId });
  } catch (error) {
    await connection.rollback();
    console.error("Error creating community:", error);
    res.status(500).json({ success: false, message: "Gagal membuat komunitas" });
  } finally {
    connection.release();
  }
};

// Ambil channel dari suatu komunitas
exports.getChannels = async (req, res) => {
  const { communityId } = req.params;
  try {
    const [rows] = await pool.execute("SELECT * FROM channels WHERE community_id = ?", [communityId]);
    res.json({ success: true, data: rows });
  } catch (error) {
    console.error("Error fetching channels:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

// Ambil pesan dari suatu channel
exports.getMessages = async (req, res) => {
  const { channelId } = req.params;
  try {
    const [rows] = await pool.execute("SELECT * FROM community_messages WHERE channel_id = ? ORDER BY created_at ASC", [channelId]);
    res.json({ success: true, data: rows });
  } catch (error) {
    console.error("Error fetching messages:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};
