require("dotenv").config();
const express = require("express");
const cors = require("cors");
const http = require("http");
const socketIo = require("socket.io");
const path = require("path");

// Konfigurasi Database & Infrastruktur (Lumiora & Battleship style)
const pool = require("./config/db");
const redisClient = require("./config/redis");
const rabbitMq = require("./config/rabbitmq");

const authRoutes = require("./routes/authRoutes");
const communityRoutes = require("./routes/communityRoutes");
const chatRoutes = require("./routes/chatRoutes");
// const matchRoutes = require("./routes/matchRoutes"); // To be rewritten in raw SQL later

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: { origin: "*" },
});

// Middleware injeksi pool ke semua request (Lumiora style)
app.use((req, res, next) => {
  req.db = pool;
  next();
});

app.use(express.json());
app.use(cors());

// Serve assets luring untuk avatar / unggahan (Lumiora style)
app.use("/assets", express.static(path.join(__dirname, "../assets")));

app.use("/api/auth", authRoutes);
app.use("/api/communities", communityRoutes);
app.use("/api/chats", chatRoutes);
// app.use("/api/matches", matchRoutes);

io.on("connection", (socket) => {
  console.log("✅ User connected via WebSocket:", socket.id);

  // When user joins, map their socket ID to their user ID di Redis (Battleship style)
  socket.on("user_connect", async (userId) => {
    try {
      await redisClient.set(`user:${userId}:socket`, socket.id);
      console.log(`📍 User ${userId} mapped to socket ${socket.id} in Redis`);
      // Broadcast that user is online
      io.emit("user_status", { userId, status: "online" });
    } catch (e) {
      console.error("Redis Error on user_connect:", e);
    }
  });

  // Real-time messaging
  socket.on("send_message", async (data) => {
    try {
      const { senderId, receiverId, message } = data;
      
      // Save private message to database
      await pool.execute(
        "INSERT INTO chats (sender_id, receiver_id, message) VALUES (?, ?, ?)",
        [senderId || 1, receiverId, message]
      );

      // Lempar beban penyimpanan pesan ke RabbitMQ (Battleship style) - Optional
      // rabbitMq.publishMessage("chat_messages_queue", data);

      const recipientSocketId = await redisClient.get(`user:${receiverId}:socket`);
      if (recipientSocketId) {
        io.to(recipientSocketId).emit("receive_message", {
          senderId: senderId || 1,
          message,
          timestamp: new Date().toISOString()
        });
        console.log(`💬 Message forwarded in real-time from ${senderId} to ${receiverId}`);
      }
    } catch (e) {
      console.error("Error handling private message:", e);
    }
  });

  // Typing indicator
  socket.on("typing", async (data) => {
    try {
      const recipientSocketId = await redisClient.get(`user:${data.receiverId}:socket`);
      if (recipientSocketId) {
        io.to(recipientSocketId).emit("user_typing", { userId: data.senderId });
      }
    } catch (e) {}
  });

  // --- COMMUNITY SOCKET.IO LOGIC ---
  socket.on("join_channel", (channelId) => {
    socket.join(`channel_${channelId}`);
    console.log(`Socket ${socket.id} joined channel_${channelId}`);
  });

  socket.on("send_channel_message", async (data) => {
    try {
      const { channelId, senderId, senderName, text } = data;
      
      // Save to database directly for now (or queue it)
      await pool.execute(
        "INSERT INTO community_messages (channel_id, sender_id, sender_name, text) VALUES (?, ?, ?, ?)",
        [channelId, senderId || 1, senderName || "User", text]
      );

      // Broadcast to room
      const msgObj = {
        sender: senderName || "User",
        text,
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        channelId
      };
      
      io.to(`channel_${channelId}`).emit("receive_channel_message", msgObj);
    } catch (e) {
      console.error("Error sending channel message:", e);
    }
  });
  // ---------------------------------

  // Disconnect handler
  socket.on("disconnect", async () => {
    try {
      // Find and remove the user from the Redis map (Warning: ini butuh scan atau struktur data berbeda di prod, tapi untuk sekarang OK)
      // Di produksi idealnya kita simpan reverse mapping socket:userId
      console.log(`❌ Socket ${socket.id} disconnected`);
    } catch (e) {}
  });
});

const PORT = process.env.PORT || 5000;

// Mengecek ketersediaan database (Self-Healing Check ala Lumiora)
async function waitForDatabase(retries = 20, delayMs = 1000) {
  for (let i = 0; i < retries; i++) {
    try {
      const conn = await pool.getConnection();
      conn.release();
      console.log('✅ Database MySQL Terhubung (Connection Pool)');
      return;
    } catch (err) {
      console.warn(`⏳ DB belum siap (percobaan ${i + 1}/${retries}): ${err.message}`);
      await new Promise(res => setTimeout(res, delayMs));
    }
  }
  throw new Error('Database tidak siap dalam waktu yang ditentukan');
}

(async () => {
  try {
    await waitForDatabase();
    
    server.listen(PORT, () => {
      console.log(`🚀 Server berjalan di http://localhost:${PORT}`);
      console.log(`📡 WebSocket (Real-time), Redis (State), & RabbitMQ (Broker) aktif`);
    });
  } catch (err) {
    console.error("❌ Gagal menyalakan server:", err);
    process.exit(1);
  }
})();
