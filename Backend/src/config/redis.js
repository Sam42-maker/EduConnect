const redis = require('redis');

// Koneksi ke Redis server lokal
// Di Windows, Redis biasanya berjalan di 127.0.0.1 port 6379 menggunakan WSL atau installer pihak ketiga
const redisClient = redis.createClient({
  url: process.env.REDIS_URL || 'redis://127.0.0.1:6379'
});

redisClient.on('error', (err) => console.log('❌ Redis Client Error', err));
redisClient.on('connect', () => console.log('✅ Terhubung ke Redis (Matchmaking State)'));

// Connect immediately
(async () => {
  try {
    await redisClient.connect();
  } catch (err) {
    console.warn('⚠️ Gagal menyambung ke Redis. Pastikan Redis server menyala.');
  }
})();

module.exports = redisClient;
