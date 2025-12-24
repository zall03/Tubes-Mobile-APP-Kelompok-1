# Wiskuyy - Aplikasi Wisata & Penjadwalan Liburan Wiskuyy 

**Wiskuyy** adalah aplikasi mobile berbasis Flutter yang membantu pengguna menemukan destinasi wisata menarik, menyimpannya ke dalam wishlist, dan mengatur jadwal kunjungan. Aplikasi ini terintegrasi dengan Supabase untuk backend dan dilengkapi fitur notifikasi lokal untuk pengingat jadwal.

---

## 📱 Fitur Utama
* **Autentikasi User:** Login & Register via Email (dengan OTP) dan Google Sign-In.
* **Explore Destinasi:** Menampilkan daftar wisata populer dan terbaru.
* **Detail Wisata:** Informasi lengkap lokasi, deskripsi, harga, dan rating.
* **Wishlist & Penjadwalan:** Simpan rencana liburan dengan tanggal spesifik.
* **Smart Notifications:** Notifikasi instan saat menambah jadwal dan alarm pengingat H-1 keberangkatan.
* **Riwayat Notifikasi:** Mencatat aktivitas penambahan, penghapusan, dan kadaluwarsa jadwal.

---

## 🛠️ Dependencies (Pustaka yang Digunakan)

Berikut adalah daftar paket utama yang digunakan dalam `pubspec.yaml`:

| Package | Fungsi |
| :--- | :--- |
| **flutter** | SDK Utama |
| `provider` | Manajemen State aplikasi (State Management). |
| `supabase_flutter` | Koneksi ke Backend (Auth & Database). |
| `google_sign_in` | Autentikasi menggunakan akun Google. |
| `flutter_local_notifications` | Menampilkan notifikasi lokal & terjadwal. |
| `shared_preferences` | Menyimpan sesi login lokal. |
| `google_fonts` | Kustomisasi font aplikasi (Poppins). |
| `http` | Protokol komunikasi jaringan (dependency pendukung). |
| `timezone` | Pendukung notifikasi terjadwal berdasarkan zona waktu. |
| `flutter_launcher_icons` | (Dev) Mengubah icon aplikasi. |

---
## ⚙️ Setup & Instalasi

Ikuti langkah ini untuk menyiapkan proyek di komputer lokal:

### 1. Prasyarat
Pastikan komputer Anda sudah terinstal:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Versi terbaru)
* VS Code atau Android Studio
* Akun [Supabase](https://supabase.com)

### 2. Clone Repository
```bash
git clone [https://github.com/zall03/Tubes-Mobile-APP-Kelompok-1.git](https://github.com/zall03/Tubes-Mobile-APP-Kelompok-1/.git)
cd Tubes-Mobile-APP-Kelompok-1

👥 Contact Person
Jika ada pertanyaan mengenai proyek ini, silakan hubungi tim pengembang:
### 
Nama: [Ares Indra Jati]

UserNAme: [aresindrajati60-svg]

Kampus: [Politeknik negeri indramayu]
### 
Nama: [Ares anesty ahmad fauziah]

UserNAme: [anestyahmadfauziah]

Kampus: [Politeknik negeri indramayu]
### 
Nama: [Muhammad rizal jamali ]

UserNAme: [zall03/Rizaljamali15@gmail.com]

Kampus: [Politeknik negeri indramayu]
