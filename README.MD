# EduConnect

EduConnect adalah platform kolaboratif *Full-Stack* yang dirancang untuk menghubungkan mahasiswa dengan mentor profesional, komunitas belajar, dan fasilitas pengembangan karir. Aplikasi ini terdiri dari dua bagian utama: **Backend** (Node.js/Express) dan **Frontend** (Flutter).

## Prasyarat (Prerequisites)

Sebelum menjalankan EduConnect di perangkat lokal Anda, pastikan Anda telah memasang perangkat lunak berikut:
1. **Node.js** (v18 atau lebih baru) - Untuk menjalankan *backend* peladen (*server*).
2. **Flutter SDK** - Untuk mengompilasi dan menjalankan aplikasi *frontend*.
3. **XAMPP** atau **MySQL Server** - Untuk *database* lokal (MySQL).
4. *(Opsional)* **Docker Desktop** - Jika Anda ingin menjalankan *backend* beserta RabbitMQ dan Redis secara serentak menggunakan kontainer.

---

## 🚀 Cara Menjalankan EduConnect (Langkah-demi-Langkah)

### Langkah 1: Menyiapkan Database (MySQL)
EduConnect menggunakan skrip inisialisasi yang akan secara otomatis membangun struktur tabel dan memasukkan (*seed*) data bawaan.

1. Buka aplikasi **XAMPP Control Panel** dan klik **Start** pada modul **MySQL**.
2. Buka terminal (Command Prompt / PowerShell / VS Code Terminal) dan arahkan ke direktori backend:
   ```bash
   cd D:\EduConnect\Backend
   ```
3. Jalankan perintah instalasi dependensi:
   ```bash
   npm install
   ```
4. Jalankan *script* inisialisasi *database*:
   ```bash
   node init-db.js
   ```
   *Anda akan melihat pesan sukses "Skema tabel berhasil dibangun dan seed data dimasukkan!"*.

### Langkah 2: Menjalankan Backend API (Node.js)
Setelah *database* siap, langkah selanjutnya adalah menyalakan API peladen agar aplikasi seluler dapat mengakses data.

1. Di terminal yang sama (`D:\EduConnect\Backend`), jalankan:
   ```bash
   npm run dev
   ```
2. Pastikan Anda melihat teks berikut di layar terminal Anda:
   - `✅ Database MySQL Terhubung`
   - `🚀 Server berjalan di http://localhost:5000`

*(Catatan: Anda mungkin melihat peringatan "Gagal menyambung ke Redis" atau RabbitMQ. Ini normal dan aplikasi akan mengaktifkan fitur `graceful degradation` sehingga fitur dasar seperti Mentor Booking dan sinkronisasi profil tetap berfungsi murni melalui MySQL).*

### Langkah 3: Menjalankan Frontend (Flutter)
Setelah *backend* menyala, biarkan terminal tersebut tetap terbuka. Buka jendela terminal yang **baru** untuk menyalakan aplikasi seluler.

1. Arahkan terminal baru ke folder frontend:
   ```bash
   cd D:\EduConnect\frontend
   ```
2. Jalankan perintah untuk mengunduh modul/dependensi Flutter:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi (misalnya di peramban Chrome untuk pengujian cepat, atau di *emulator* Android):
   ```bash
   flutter run -d chrome
   ```
4. Aplikasi akan otomatis terbuka.

---

## 🛠 Panduan Arsitektur Singkat
* **Fitur Mentor**: Saat Anda mengklik "Mentor", aplikasi Flutter akan menembakkan permintaan HTTP `GET` ke `http://localhost:5000/api/mentors`. Saat Anda berhasil membayar, aplikasi akan melakukan HTTP `POST` ke `http://localhost:5000/api/mentors/book` dan mencatatnya ke dalam MySQL.
* **Fitur Docker**: Jika di masa depan Anda perlu mempublikasikannya ke *Google Cloud Platform (GCP)* lengkap dengan Redis (untuk performa/ *cache*) dan RabbitMQ (untuk notifikasi/pesan massal), Anda dapat langsung menggunakan konfigurasi yang sudah disiapkan di folder `Backend` dengan perintah `docker-compose up -d`.

Selamat berkolaborasi menggunakan EduConnect!
