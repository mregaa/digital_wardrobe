# Digital Wardrobe

Aplikasi mobile Flutter untuk mengelola koleksi pakaian pribadi dan membuat kombinasi outfit melalui canvas visual interaktif.

## Developer

Nama    : Muhamad Rega Pramudya
NIM     : 1202223378
Kelas   : SI-46-EISD2 (Pengembangan Aplikasi Bergerak)

## Ringkasan Proyek

Digital Wardrobe adalah aplikasi pengelolaan lemari pakaian yang membantu pengguna mengorganisir koleksi pakaian mereka dan bereksperimen dengan berbagai kombinasi outfit. Aplikasi ini mengatasi masalah umum dalam mengelola lemari pakaian yang terus bertambah dan memvisualisasikan bagaimana berbagai item pakaian dapat dipadukan sebelum benar-benar mengenakannya.

Pengguna dapat memfoto item pakaian mereka, mengkategorikannya, dan menggunakan canvas interaktif berbasis avatar untuk mencampur dan mencocokkan item secara visual. Ini membuat perencanaan outfit lebih intuitif dan membantu memaksimalkan penggunaan pakaian yang sudah dimiliki.

## Fitur Utama

### Autentikasi
- Sistem registrasi dan login pengguna
- Manajemen sesi yang aman
- Manajemen profil dengan statistik pengguna

### Manajemen Lemari Pakaian
- **Tambah Item Pakaian**:
  - Pilih gambar dari galeri perangkat
  - Ambil foto langsung menggunakan kamera perangkat
  - Preview gambar real-time sebelum submit
  - Opsi untuk menggunakan tools penghapus latar belakang untuk gambar lebih bersih
  - Kategorisasi item (atasan, bawahan, outerwear, sepatu, aksesoris)
  - Tambahkan metadata: nama, warna, dan catatan opsional
  - Dukungan untuk gambar PNG transparan

- **Jelajahi Outfit**:
  - Tampilan grid untuk semua item pakaian
  - Filter berbasis kategori
  - Fungsi pencarian berdasarkan nama
  - Filter favorit untuk melihat item tersimpan
  - Akses cepat ke detail outfit

- **Detail Outfit**:
  - Tampilan outfit layar penuh
  - Edit outfit yang ada
  - Hapus item yang tidak diinginkan
  - Tandai item sebagai favorit

- **Sistem Favorit**:
  - Toggle status favorit pada outfit apa pun
  - Layar favorit khusus
  - Status favorit persisten di seluruh sesi

### Avatar Outfit Builder (Mix & Match)
Fitur utama yang memungkinkan komposisi outfit visual:

- **Canvas Interaktif**:
  - Canvas 2D bersih dengan latar belakang grid
  - Siluet avatar sebagai referensi ukuran
  - Workspace layar penuh untuk membangun outfit

- **Drag and Drop**:
  - Tekan lama item pakaian dari library
  - Seret item ke canvas
  - Feedback visual selama menyeret

- **Gesture Multi-Touch**:
  - Gerakkan item dengan drag
  - Pinch untuk memperbesar atau memperkecil item
  - Rotasi dua jari untuk penyesuaian sudut
  - Penanganan gesture yang halus dan responsif

- **Kontrol Canvas**:
  - Tap item untuk membawa ke depan (manajemen z-order)
  - Hapus item individual
  - Bersihkan seluruh canvas
  - Simpan kombinasi dengan nama kustom

- **Library yang Dapat Diperluas**:
  - Library outfit yang dapat dilipat di bagian bawah
  - Filter kategori (Semua, atasan, bawahan, outerwear, sepatu, aksesoris)
  - Animasi expand/collapse yang halus
  - Tata letak grid untuk browsing mudah

### Antarmuka Pengguna
- Tema Material Design 3
- Tata letak responsif untuk berbagai ukuran layar
- Navigasi bawah untuk bagian utama
- Ikon intuitif dan feedback visual
- State error dengan pesan membantu
- Indikator loading selama operasi

## Highlight Teknis

### State Management
- **Pola Provider** untuk state aplikasi-wide
- Provider terpisah untuk berbagai keperluan:
  - State autentikasi
  - Manajemen daftar outfit
  - Manajemen favorit
  - State canvas Mix & Match
  - Penanganan form outfit
- Update UI efisien menggunakan ChangeNotifier

### Integrasi API
- Komunikasi RESTful API menggunakan Dio HTTP client
- Multipart form data untuk upload gambar
- Penanganan error aman dengan respons yang di-type-check
- Normalisasi URL gambar untuk path relatif
- Manajemen token otomatis untuk request terautentikasi

### Penanganan Media
- Integrasi dengan kamera perangkat via image_picker
- Pemilihan gambar galeri
- Preview file sebelum upload
- Dukungan untuk transparansi PNG
- Optimasi rendering gambar (anti-aliasing, quality filtering)

### Sistem Gesture
- Penanganan gesture multi-touch kustom
- Kalkulasi transformasi stabil (posisi, skala, rotasi)
- Clamping skala untuk usability (0.2x hingga 4.0x)
- Manajemen state gesture untuk interaksi halus

### Keamanan Data
- Parsing enum aman dengan nilai fallback
- Implementasi null-safe menyeluruh
- Penanganan error komprehensif
- Validasi tipe untuk respons API

### Pertimbangan Cross-Platform
- Penanganan permission spesifik Android (kamera)
- Intent queries untuk URL launching
- Komponen UI platform-aware
- Tata letak responsif

## Teknologi yang Digunakan

### Frontend
- **Flutter SDK** - Framework mobile cross-platform
- **Dart** - Bahasa pemrograman
- **Provider** (^6.0.0) - State management
- **Material Design 3** - Sistem desain UI

### Networking
- **Dio** - HTTP client untuk komunikasi API
- **Multipart uploads** - Transmisi file gambar

### Media & Utilities
- **image_picker** (^1.1.2) - Akses kamera dan galeri
- **url_launcher** (^6.3.1) - Penanganan URL eksternal

### Backend
- REST API (arsitektur FastAPI-style)
- Format data JSON
- Autentikasi berbasis token
- Penyimpanan file untuk gambar yang diupload

## Struktur Aplikasi

### Layar Utama

1. **Layar Login**
   - Autentikasi email dan password
   - Navigasi ke registrasi
   - Redirect otomatis pada login berhasil

2. **Layar Home**
   - Ringkasan outfit terbaru
   - Akses cepat ke fitur utama
   - Bottom navigation bar

3. **Layar Daftar Outfit**
   - Tampilan grid semua outfit
   - Chip filter kategori
   - Search bar untuk pencarian cepat
   - Tombol toggle favorit
   - Navigasi ke detail outfit

4. **Layar Tambah Outfit**
   - Pemilihan gambar (galeri/kamera)
   - Form field untuk detail outfit
   - Dropdown pemilihan kategori
   - Dialog tip penghapus latar belakang
   - Preview gambar dengan latar belakang putih untuk transparansi

5. **Layar Edit Outfit**
   - Mirip dengan layar tambah
   - Sudah terisi dengan data yang ada
   - Menampilkan gambar outfit saat ini
   - Opsi untuk mengganti gambar

6. **Layar Detail Outfit**
   - Tampilan gambar layar penuh
   - Informasi outfit lengkap
   - Opsi edit dan hapus
   - Tombol toggle favorit

7. **Layar Favorit**
   - Tampilan grid item favorit
   - Opsi hapus dari favorit
   - Navigasi langsung ke detail outfit

8. **Layar Mix & Match**
   - Canvas workspace dengan grid
   - Panduan siluet avatar
   - Library yang dapat diperluas di bawah
   - Filter kategori
   - Tombol simpan kombinasi
   - Opsi bersihkan canvas

9. **Layar Profil**
   - Tampilan informasi pengguna
   - Statistik (jumlah outfit, jumlah favorit, jumlah combo)
   - Statistik yang dapat di-tap untuk navigasi ke layar terkait
   - Opsi pengaturan dan logout

## Cara Menjalankan Aplikasi

### Prasyarat
- Flutter SDK (3.0.0 atau lebih tinggi)
- Android Studio / VS Code dengan ekstensi Flutter
- Perangkat atau emulator Android (untuk testing Android)
- Web browser (untuk testing web)

### Langkah Setup

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd digital_wardrobe
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Konfigurasi URL backend**
   - Buka `lib/core/constants/app_constants.dart`
   - Update `baseUrl` dan `imageBaseUrl` dengan alamat server backend Anda
   - Contoh: `http://YOUR_IP:8000`

4. **Jalankan aplikasi**
   
   Untuk Android:
   ```bash
   flutter run
   ```
   
   Untuk Web:
   ```bash
   flutter run -d chrome
   ```

### Catatan Setup Backend
- Pastikan backend REST API berjalan dan dapat diakses
- Backend harus mendukung endpoint untuk:
  - Autentikasi pengguna (`/auth/login`, `/auth/register`)
  - Operasi CRUD outfit (`/outfits/`, `/outfits/{id}`)
  - Manajemen favorit (`/outfits/{id}/favorite`)
  - Upload file gambar
- Konfigurasi CORS jika menjalankan versi web

## Hasil Pembelajaran

Proyek ini mendemonstrasikan implementasi praktis dari:

1. **Fundamental Pengembangan Mobile**
   - Pengembangan cross-platform dengan Flutter
   - Prinsip Material Design
   - Fitur spesifik platform (kamera, akses file)

2. **State Management**
   - Implementasi pola Provider
   - Separation of concerns
   - Update state yang efisien

3. **Integrasi API**
   - Konsumsi RESTful API
   - Alur autentikasi
   - Multipart file uploads
   - Strategi penanganan error

4. **UI/UX Lanjutan**
   - Interaksi berbasis gesture
   - Antarmuka drag and drop
   - Transformasi multi-touch
   - Komponen expandable/collapsible
   - Penanganan gambar dengan transparansi

5. **Arsitektur Software**
   - Prinsip clean architecture
   - Pola repository
   - Dependency injection berbasis Provider
   - Struktur proyek berbasis fitur

## Struktur Proyek

```
lib/
├── core/                       # Utilitas dan konstanta inti
│   ├── constants/             # Konstanta aplikasi-wide
│   ├── utils/                 # Fungsi helper dan routing
│   └── widgets/               # Widget bersama
├── features/                  # Modul fitur
│   ├── auth/                  # Autentikasi
│   │   ├── data/             # Auth data layer
│   │   ├── domain/           # Auth domain layer
│   │   └── presentation/     # Auth UI
│   ├── wardrobe/             # Manajemen outfit
│   │   ├── data/            # Data sources, repositories
│   │   ├── domain/          # Entities, repository interfaces
│   │   └── presentation/    # Layar UI dan providers
│   └── mix_match/           # Avatar outfit builder
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart                 # Entry point aplikasi
```

## Keterbatasan yang Diketahui

- Kombinasi yang disimpan saat ini menyimpan metadata dasar (implementasi dapat diperluas)
- Versi web memiliki dukungan gesture terbatas dibanding mobile
- Pemrosesan gambar di sisi client (tidak ada optimasi gambar backend)
- Penghapusan latar belakang memerlukan integrasi tool eksternal

## Peningkatan di Masa Depan

Potensi peningkatan untuk pengembangan lanjutan:
- Integrasi cloud storage untuk gambar
- Sharing sosial untuk kombinasi outfit
- Rekomendasi outfit berbasis AI
- Saran outfit berbasis cuaca
- Integrasi kalender untuk perencanaan outfit
- Export kombinasi sebagai gambar

## Catatan Tugas

**Mata Kuliah**: Pengembangan Aplikasi Bergerak  
**Tujuan**: Tugas Akhir  
**Area Fokus**:
- Pengembangan aplikasi mobile dengan Flutter
- Integrasi dengan REST APIs
- State management dalam aplikasi mobile
- Antarmuka pengguna berbasis gesture
- Penanganan media (kamera dan galeri)
- Pertimbangan cross-platform

Proyek ini menampilkan integrasi berbagai konsep pengembangan mobile ke dalam aplikasi yang kohesif dan user-friendly yang menyelesaikan masalah nyata dalam organisasi lemari pakaian dan perencanaan outfit.

## Lisensi

Proyek ini dikembangkan untuk tujuan edukasi sebagai bagian dari tugas mata kuliah universitas.
