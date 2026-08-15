const redis = require('redis');

// Koneksi ke Redis server lokal
// Di Windows, Redis biasanya berjalan di 127.0.0.1 port 6379 menggunakan WSL atau installer pihak ketiga
const redisClient = redis.createClient({
  url: process.env.REDIS_URL || 'redis://127.0.0.1:6379',
  socket: {
    reconnectStrategy: (retries) => {
      // Don't retry if we can't connect, to avoid console spam when Redis is offline
      return false;
    }
  }
});

let isConnected = false;

redisClient.on('error', (err) => {
  // Only log once to avoid spam
  if (isConnected) {
    console.log('❌ Redis Client Error', err.message);
  }
});

redisClient.on('connect', () => {
  isConnected = true;
  console.log('✅ Terhubung ke Redis (Matchmaking State)');
});

// Connect immediately
(async () => {
  try {
    await redisClient.connect();
  } catch (err) {
    console.warn('⚠️ Gagal menyambung ke Redis. Aplikasi akan berjalan tanpa fitur caching.');
  }
})();

// Create a safe wrapper that doesn't throw if not connected
const safeRedisClient = {
  get: async (key) => {
    if (!isConnected) return null;
    try { return await redisClient.get(key); } catch (e) { return null; }
  },
  set: async (key, value, options) => {
    if (!isConnected) return;
    try { await redisClient.set(key, value, options); } catch (e) {}
  },
  del: async (key) => {
    if (!isConnected) return;
    try { await redisClient.del(key); } catch (e) {}
  },
  raw: redisClient
};

module.exports = safeRedisClient;
