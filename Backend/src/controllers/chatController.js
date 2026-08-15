const pool = require("../config/db");

// Get recent chats for a user (Inbox view)
exports.getRecentChats = async (req, res) => {
  // Using userId 1 as a mock for now
  const userId = parseInt(req.query.userId || 1);

  try {
    // We want the latest message for each chat partner
    const query = `
      SELECT 
        u.user_id as partner_id,
        u.full_name as partner_name,
        c.message as last_message,
        c.timestamp as last_timestamp,
        c.sender_id,
        (SELECT COUNT(*) FROM chats c2 WHERE c2.sender_id = u.user_id AND c2.receiver_id = ? AND c2.is_read = 0) as unread_count
      FROM (
        SELECT 
          CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END as partner_id,
          MAX(timestamp) as max_timestamp
        FROM chats
        WHERE (sender_id = ? OR receiver_id = ?) AND channel_id IS NULL
        GROUP BY partner_id
      ) latest
      JOIN chats c ON (
        (c.sender_id = ? AND c.receiver_id = latest.partner_id) OR 
        (c.receiver_id = ? AND c.sender_id = latest.partner_id)
      ) AND c.timestamp = latest.max_timestamp AND c.channel_id IS NULL
      JOIN user_profiles u ON u.user_id = latest.partner_id
      ORDER BY c.timestamp DESC
    `;

    // Wait, the chats table doesn't have `is_read`. Let's mock unread_count to 0 for now.
    // I will adjust the query to not use is_read.
    const safeQuery = `
      SELECT 
        u.user_id as partner_id,
        u.full_name as partner_name,
        c.message as last_message,
        c.timestamp as last_timestamp,
        c.sender_id,
        0 as unread_count
      FROM (
        SELECT 
          CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END as partner_id,
          MAX(timestamp) as max_timestamp
        FROM chats
        WHERE (sender_id = ? OR receiver_id = ?) AND channel_id IS NULL
        GROUP BY CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END
      ) latest
      JOIN chats c ON (
        (c.sender_id = ? AND c.receiver_id = latest.partner_id) OR 
        (c.receiver_id = ? AND c.sender_id = latest.partner_id)
      ) AND c.timestamp = latest.max_timestamp AND c.channel_id IS NULL
      JOIN user_profiles u ON u.user_id = latest.partner_id
      ORDER BY c.timestamp DESC
    `;

    const [rows] = await pool.execute(safeQuery, [
      userId, userId, userId, userId, userId, userId
    ]);

    res.json({ success: true, data: rows });
  } catch (error) {
    console.error("Error fetching recent chats:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

// Get chat history with a specific partner
exports.getChatHistory = async (req, res) => {
  const userId = parseInt(req.query.userId || 1);
  const partnerId = parseInt(req.params.partnerId);

  try {
    const [rows] = await pool.execute(
      `SELECT * FROM chats 
       WHERE ((sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?))
       AND channel_id IS NULL
       ORDER BY timestamp ASC`,
      [userId, partnerId, partnerId, userId]
    );

    res.json({ success: true, data: rows });
  } catch (error) {
    console.error("Error fetching chat history:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};
