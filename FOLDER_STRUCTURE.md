Dokumentasi Struktur Folder (Arsitektur) - BelajarBarengStruktur ini dirancang untuk skalabilitas, kemudahan kolaborasi (kerja tim), dan pemisahan tanggung jawab (separation of concerns), sejalan dengan proposal proyek Anda yang menggunakan Riverpod dan go_router.Struktur ini menggunakan pendekatan Feature-First (Berdasarkan Fitur) yang dikombinasikan dengan prinsip Clean Architecture.Struktur Utama (di dalam lib/)lib/
|
+-- main.dart               # Titik masuk utama aplikasi
|
+-- src/
|
+-- core/                 # Kode inti yang dipakai bersama
|   |
|   +-- app/              # Konfigurasi App Widget (MaterialApp, providers)
|   +-- config/           # Konfigurasi global
|   |   +-- constants.dart  # String, angka, dll
|   |   +-- router.dart     # Konfigurasi Go_Router
|   |   +-- theme.dart      # Tema (Light & Dark)
|   |
|   +-- services/         # Layanan pihak ketiga (Firebase, AI API, Notifikasi)
|   +-- storage/          # Penyimpanan lokal (Drift, Encrypted Box)
|   +-- utils/            # Fungsi helper (Validator, Formatter)
|   +-- widgets/          # Widget global (CustomButton, LoadingIndicator)
|
+-- data/                 # (Opsional) Repositori & model data global
|   |
|   +-- models/           # Model data global (mis: User)
|   +-- repositories/     # Repositori global
|
+-- features/             # FITUR UTAMA APLIKASI (PENTING!)
|
+-- auth/             # Fitur: Autentikasi (Sesuai Proposal F)
|   |
|   +-- data/         # Sumber data (mis: AuthRepository)
|   +-- domain/       # Logika bisnis (Providers, Model)
|   +-- presentation/ # UI (Screens, Widgets)
|
+-- dashboard/        # Fitur: Halaman Utama
|   |
|   +-- presentation/ # UI (DashboardScreen)
|
+-- qna/              # Fitur: Q&A Forum (Sesuai Proposal F)
|   |
|   +-- data/
|   +-- domain/
|   +-- presentation/
|
+-- quiz/             # Fitur: Quiz Builder & Player (Sesuai Proposal F)
|   |
|   +-- data/
|   +-- domain/
|   +-- presentation/
|
+-- media/            # Fitur: Learning Media (Sesuai Proposal F)
|   |
|   +-- data/
|   +-- domain/
|   +-- presentation/
|
+-- gamification/     # Fitur: Leaderboard, Badges (Sesuai Proposal F)
|   |
|   +-- data/
|   +-- domain/
|   +-- presentation/
|
+-- profile/          # Fitur: Profile & Settings (Sesuai Proposal F)
|
+-- data/
+-- domain/
+-- presentation/
Penjelasan per Direktorilib/main.dartHanya berisi fungsi main().Tugasnya adalah menginisialisasi binding Flutter, menyiapkan ProviderScope (untuk Riverpod), dan menjalankan aplikasi (runApp).lib/src/core/Tujuan: Menyimpan semua kode yang tidak terkait dengan satu fitur spesifik, tetapi digunakan oleh banyak fitur.app/: Widget MaterialApp.router utama, inisialisasi listener Riverpod, dll.config/: Konfigurasi yang jarang berubah. router.dart mendefinisikan semua rute (GoRoute) yang menghubungkan URL ke screen di fitur. theme.dart berisi ThemeData untuk mode terang dan gelap (Sesuai Proposal C).services/: Logika untuk berbicara dengan dunia luar. Misal, satu class untuk API AI, satu class untuk Notifikasi FCM (Sesuai Proposal C & F).storage/: Konfigurasi database Drift (SQLite) dan storage terenkripsi (Sesuai Proposal E).utils/: Fungsi murni (mis: bool isValidEmail(String email)).widgets/: Komponen UI yang dipakai berulang kali, misal PrimaryButton atau AvatarImage.lib/src/features/JANTUNG APLIKASI. Setiap folder di sini adalah satu fitur utama dari proposal Anda (Q&A, Quiz, Media, dll.).Keuntungan: Tim Anda bisa bekerja secara paralel. "Tim A" mengerjakan features/qna dan "Tim B" mengerjakan features/quiz tanpa banyak konflik.Struktur di dalam Setiap Fitur (mis: features/qna/)Setiap fitur dibagi lagi menjadi 3 lapisan (sesuai prinsip Clean Architecture):presentation/ (Layer UI)Berisi Screens (halaman penuh) dan Widgets (komponen kecil).Hanya bertugas menampilkan data dan mengirim event (seperti "tombol ditekan").Bergantung pada domain/.domain/ (Layer Logika Bisnis)Berisi Riverpod Providers (StateNotifiers, FutureProviders) yang menyimpan state fitur.Berisi Models/Entities (misal: Question, Answer).Ini adalah "otak" dari fitur. Tidak tahu-menahu soal UI.Bergantung pada data/.data/ (Layer Data)Berisi Repositories (Kontrak/Abstract Class) dan DataSources (Implementasi).Bertanggung jawab mengambil data (dari Firebase, AI API, atau storage lokal).Ini adalah "tangan" yang mengambil data.