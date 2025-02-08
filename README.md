# Raskara Boutique - Aplikasi Manajemen Toko Butik 

Aplikasi Flutter untuk manajemen toko butik dengan fitur autentikasi, dashboard penjualan, transaksi, histori, dan integrasi Firebase.

![Logo Aplikasi](assets/images/Logo.png)  

---

## 📋 Daftar Isi
- [Fitur Utama](#-fitur-utama)
- [Teknologi yang Digunakan](#-teknologi-yang-digunakan)
- [Instalasi](#-instalasi)
- [Struktur Proyek](#-struktur-proyek)
- [Screenshot](#-screenshot)
- [Kontribusi](#-kontribusi)
- [Lisensi](#-lisensi)
- [Catatan](#-catatan)

---

## 🚀 Fitur Utama
1. **Splash Screen**  
   Menampilkan logo toko dengan animasi sederhana.
2. **Autentikasi Pengguna**  
   - Registrasi pengguna baru dengan email dan password.
   - Login menggunakan akun yang sudah terdaftar.
3. **Dashboard**  
   - Grafik penjualan mingguan (menggunakan `fl_chart`).
   - Navigasi cepat ke menu Transaksi dan Histori.
4. **Manajemen Transaksi**  
   - Tambah produk ke keranjang belanja.
   - Proses pembayaran dengan metode Bank, QRIS, atau Cash.
5. **Histori Penjualan**  
   - Tampilkan riwayat transaksi dalam bentuk tabel.
   - Ekspor data ke format CSV.
6. **Integrasi Firebase**  
   - Autentikasi pengguna dengan Firebase Auth.
   - Penyimpanan data transaksi di Firestore.

---

## 🛠 Teknologi yang Digunakan
| Kategori               | Teknologi/Paket                                                                 |
|------------------------|---------------------------------------------------------------------------------|
| **Framework**          | Flutter                                                                         |
| **Backend**            | Firebase (Authentication, Firestore)                                            |
| **State Management**   | Provider                                                                        |
| **Visualisasi Data**   | `fl_chart`                                                                      |
| **Lainnya**            | `csv`, `intl`, `path_provider`                                                  |

---

## 📥 Instalasi
### Prasyarat
- Flutter SDK (versi terbaru)
- Android Studio / Xcode
- Akun Firebase

### Langkah-langkah
1. **Clone Repository**
   ```bash
   git clone https://github.com/RafiHana/raskara_boutique.git
   cd raskara_boutique

2. **Instal Dependecies**
    flutter pub get

3. **Setup Firebase**
    ### Download file konfigurasi dari Firebase Console:
    - google-services.json (letakkan di android/app/)
    - GoogleService-Info.plist (letakkan di ios/Runner/)

    ### Jalankan perintah:
    - flutterfire configure

4. **Jalankan Aplikasi**
    - flutter run

---

## 📂 Struktur Proyek

```plaintext
lib/
├── main.dart
├── firebase_options.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── dashboard_screen.dart
│   ├── transaction_screen.dart
│   ├── history_screen.dart
│   ├── cart_screen.dart
│   ├── payment_screen.dart
│   └── history_detail_screen.dart
├── widgets/
│   ├── chart_widget.dart
├── models/
│   ├── product.dart
├── providers/
│   ├── cart_provider.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── image_storage.dart
└── backend/
    ├── config/
    │   ├── db.js
    ├── controllers/
    │   ├── productController.js
    ├── models/
    │   ├── ProductModel.js
    ├── routes/
    │   ├── productRoutes.js
    ├── public/
    │   └── uploads/
    ├── node_modules/
    ├── package.json
    ├── package-lock.json
    └── server.js


## 🤝 Kontributor
- Rafi Hana - Developer

- note Masih dalam pengembangan.