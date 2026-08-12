require('dotenv').config();
const express = require('express');
const cors = require('cors');
const http = require('http');
const socketIo = require('socket.io');

const sequelize = require('./config/database');
const authRoutes = require('./routes/authRoutes');
const matchRoutes = require('./routes/matchRoutes');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: { origin: '*' }
});

app.use(express.json());
app.use(cors());
app.use('/api/auth', authRoutes);
app.use('/api/matches', matchRoutes);

io.on('connection', (socket) => {
  console.log('User connected via Socket.io:', socket.id);
  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

const PORT = process.env.PORT || 5000;

// Sinkronisasi model ke database PostgreSQL
sequelize.sync({ alter: true }) // gunakan alter: true saat development agar skema update otomatis
  .then(() => {
    console.log('✅ Database PostgreSQL Tersinkronisasi');
    server.listen(PORT, () => {
      console.log(`🚀 Server berjalan di http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error('❌ Gagal sinkronisasi database:', err);
  });
