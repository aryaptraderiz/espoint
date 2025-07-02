# 🧊 esPoint - Manajemen Penjualan Minuman Dingin

## 📌 Overview

**esPoint** adalah aplikasi manajemen penjualan dan stok minuman dingin berbasis Flutter. Aplikasi ini dirancang untuk memudahkan pemilik usaha dalam mengelola produk, bahan baku, transaksi penjualan, serta menyajikan laporan berbasis grafik. Sistem mendukung fitur notifikasi lokal maupun WhatsApp, serta sinkronisasi data secara real-time menggunakan Firebase Firestore.

Aplikasi ini cocok digunakan oleh UMKM, kios minuman, hingga bisnis waralaba yang membutuhkan sistem POS (Point of Sale) sederhana namun powerful.

---

## ✨ Fitur Utama

- 🔐 **Autentikasi Pengguna** (Login/Register via Firebase Auth)
- 🥤 **Manajemen Produk (Minuman)**: Tambah, edit, dan hapus minuman
- 🧂 **Manajemen Bahan Baku**: Kelola stok bahan baku secara terstruktur
- 💳 **Transaksi Penjualan**: Tambah dan riwayat transaksi, otomatis kurangi stok bahan
- 📊 **Laporan Penjualan**: Visualisasi total penjualan dalam grafik
- 🔔 **Notifikasi**: Mendukung notifikasi lokal dan integrasi WhatsApp
- ☁️ **Sinkronisasi Cloud**: Real-time update menggunakan Firebase Firestore
- 📱 **UI Modern**: Dibuat dengan Flutter, responsif untuk Android

---

## 🚀 Getting Started

### ✅ Prasyarat (Prerequisites)

Sebelum menjalankan proyek ini, pastikan Anda telah menginstal:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) / VS Code + Flutter Extension
- Akun Firebase + setup Firestore dan Authentication

### 🔧 Langkah Instalasi

1. **Clone Repository:**

```bash
git clone https://github.com/aryaptraderiz/espoint.git
cd espoint
```
2.Install Dependencies:
flutter pub get

3.Setup Firebase:
Buat project di Firebase Console

Tambahkan aplikasi Android (com.example.espoint_flutter)

Unduh file google-services.json dan letakkan di:
/android/app/google-services.json

Aktifkan Firestore dan Authentication (Email/Password)

Tambahkan file firebase_options.dart (gunakan Firebase CLI atau manual)

4.Jalankan Project:
flutter run

🗂️ Struktur Proyek
bash
Salin
Edit
lib/
│
├── models/           # Data model: product, ingredient, transaction, etc.
├── providers/        # State management menggunakan Provider
├── screens/          # Tampilan UI: login, dashboard, produk, transaksi
├── services/         # Integrasi Firebase, notifikasi
├── widgets/          # Widget kustom untuk tampilan
└── firebase_options.dart

🔐 Autentikasi
Menggunakan Firebase Authentication dengan metode email & password

Data pengguna disimpan pada Firestore collection users

🔁 Sinkronisasi Data
Semua data (produk, stok, transaksi) disimpan dan disinkronkan secara real-time menggunakan Cloud Firestore.

📈 Laporan dan Grafik
Menggunakan fl_chart untuk visualisasi total penjualan dalam bentuk grafik batang.

Data laporan diambil dari total transaksi harian/mingguan/bulanan.

📤 Notifikasi
Menggunakan notifikasi lokal via flutter_local_notifications

Dukungan pengiriman notifikasi ke WhatsApp via API eksternal (opsional, bisa ditambahkan melalui webhook)

💡 Teknologi yang Digunakan
Flutter & Dart

Firebase Auth

Cloud Firestore

Provider

fl_chart

flutter_local_notifications

🧑‍💻 Kontribusi
Kontribusi sangat terbuka! Jika kamu ingin menyempurnakan UI, menambah fitur, atau memperbaiki bug, silakan buat pull request.

📄 Lisensi
MIT License © 2025 esPoint
member:
1.Arya Putra Aderiz
2.Killy Octama Kristiano
3.Muhammad Andyfa Fakhrizal
4.Pajar Apriliyanto


