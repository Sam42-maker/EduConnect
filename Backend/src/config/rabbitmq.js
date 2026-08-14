const amqp = require('amqplib');

let channel = null;

async function connectRabbitMQ() {
  try {
    // Koneksi ke RabbitMQ server lokal
    const connection = await amqp.connect(process.env.RABBITMQ_URL || 'amqp://localhost');
    channel = await connection.createChannel();
    
    // Deklarasi queue untuk menyimpan pesan secara asynchronous
    await channel.assertQueue('chat_messages_queue', { durable: true });
    
    console.log('✅ Terhubung ke RabbitMQ (Message Broker)');
  } catch (error) {
    console.warn('⚠️ Gagal menyambung ke RabbitMQ. Pastikan RabbitMQ server menyala.', error.message);
  }
}

connectRabbitMQ();

// Fungsi untuk melempar pekerjaan (seperti menyimpan chat) ke background
function publishMessage(queueName, data) {
  if (channel) {
    channel.sendToQueue(queueName, Buffer.from(JSON.stringify(data)), { persistent: true });
  } else {
    console.error('RabbitMQ Channel belum siap.');
  }
}

module.exports = {
  publishMessage,
  getChannel: () => channel
};
