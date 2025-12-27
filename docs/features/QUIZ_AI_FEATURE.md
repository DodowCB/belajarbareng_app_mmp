# Fitur Quiz dengan AI Helper

## Overview
Fitur quiz yang memungkinkan guru membuat, mengelola, dan memvalidasi soal quiz dengan bantuan AI (Google Gemini).

## Struktur File
- **quiz_guru_screen.dart** - Screen utama untuk daftar quiz
- **quiz_detail_screen.dart** - Screen detail quiz dengan AI helper

## Fitur Utama

### 1. Detail Quiz
Menampilkan semua soal yang telah dibuat dengan informasi:
- Nomor soal
- Tipe jawaban (Single/Multiple)
- Pertanyaan
- Opsi jawaban dengan indikasi jawaban benar (highlight hijau)
- Tombol edit dan hapus untuk setiap soal

### 2. Edit Soal
Guru dapat mengedit soal yang sudah dibuat:
- Ubah pertanyaan
- Ubah tipe jawaban (single/multiple)
- Edit opsi jawaban
- Ubah jawaban yang benar

**Cara Edit:**
1. Klik tombol edit (ikon pensil) di card soal
2. Ubah data yang diperlukan
3. Pilih jawaban yang benar dengan radio button (single) atau checkbox (multiple)
4. Klik "Simpan"

### 3. AI Helper - Google Gemini
Menggunakan Google Gemini API untuk memvalidasi jawaban soal.

**Fitur AI:**
- Memeriksa apakah jawaban yang ditandai benar sudah tepat
- Mengidentifikasi kesalahan atau ketidaksesuaian
- Memberikan saran perbaikan

**Cara Penggunaan:**

#### Setup API Key:
1. Dapatkan API key gratis dari: https://aistudio.google.com/app/apikey
2. Di screen detail quiz, klik ikon kunci (key) di toolbar
3. Masukkan API key Gemini
4. Klik "Simpan"
5. API key akan tersimpan di Firestore collection `settings` document `gemini_api`

#### Menggunakan AI Helper:
1. Klik tombol "Periksa dengan AI" di bawah soal
2. AI akan menganalisis pertanyaan dan jawaban
3. Hasil analisis akan ditampilkan dalam dialog
4. AI memberikan feedback apakah jawaban sudah tepat atau perlu perbaikan

### 4. Hapus Soal
Guru dapat menghapus soal:
1. Klik tombol hapus (ikon trash) di card soal
2. Konfirmasi penghapusan
3. Soal dan semua jawabannya akan dihapus secara cascade

## Database Structure

### Collection: settings
```
Document ID: gemini_api
Fields:
- api_key: string (Gemini API key)
```

## API Integration

### Google Gemini API
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent`
- **Method**: POST
- **Authentication**: API key via query parameter
- **Model**: gemini-pro

**Request Format:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "prompt here"
        }
      ]
    }
  ]
}
```

**Response Format:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "AI response here"
          }
        ]
      }
    }
  ]
}
```

## UI Components

### Quiz Detail Screen
- **App Bar**: Menampilkan judul quiz dan status API key
- **Body**: ListView dengan card untuk setiap soal
- **Card Soal**: 
  - Badge nomor soal (ungu)
  - Badge tipe (biru untuk single, hijau untuk multiple)
  - Tombol edit dan hapus
  - Pertanyaan
  - List jawaban dengan visual indikator
  - Tombol AI helper (jika API key sudah setup)

### Edit Dialog
- **Width**: 600px
- **Max Height**: 700px
- **Fields**:
  - TextField untuk pertanyaan (multiline)
  - Dropdown tipe jawaban
  - Dynamic list jawaban dengan radio/checkbox
- **Buttons**: Batal dan Simpan

### API Key Dialog
- Input field untuk API key (obscured)
- Link ke halaman pembuatan API key
- Tombol simpan

### AI Result Dialog
- Menampilkan hasil analisis AI
- Scrollable untuk teks panjang
- Tombol tutup

## Status Indicators

### API Key Status (Toolbar):
- **Orange Key Icon**: API key belum di-setup
- **Green Key Icon**: API key sudah aktif
- **Loading**: Sedang memuat status API key

### Answer Status (Card Soal):
- **Green Background**: Jawaban benar
- **Gray Background**: Jawaban salah
- **Green Border**: Jawaban benar (2px)
- **Gray Border**: Jawaban salah (1px)
- **Check Icon**: Indikator jawaban benar

## Error Handling
- Loading state saat mengambil data
- Error message jika API call gagal
- Validation sebelum save (soal tidak boleh kosong)
- Konfirmasi dialog sebelum delete
- SnackBar untuk feedback user

## Dependencies
```yaml
dependencies:
  cloud_firestore: ^5.4.4  # Database
  http: ^1.2.2             # HTTP client untuk Gemini API
```

## Navigation
```dart
// Dari quiz_guru_screen.dart ke quiz_detail_screen.dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (c) => QuizDetailScreen(
      quizId: quiz['id'],
      judul: quiz['judul'],
    ),
  ),
);
```

## Tips untuk Guru
1. Setup API key Gemini terlebih dahulu untuk mengaktifkan fitur AI
2. Gunakan AI helper untuk memvalidasi soal sebelum dipublikasikan
3. Review saran AI untuk memastikan kualitas soal
4. Edit soal jika AI menemukan ketidaksesuaian
5. API key Gemini gratis dengan quota harian yang cukup untuk penggunaan normal

## Keamanan
- API key disimpan di Firestore (consider encryption untuk production)
- API key di-obscure saat input
- Validasi response dari Gemini API
- Error handling untuk API failures

## Future Improvements
- [ ] Enkripsi API key di Firestore
- [ ] Batch AI check untuk semua soal
- [ ] AI suggestion untuk opsi jawaban tambahan
- [ ] Export/Import soal
- [ ] Quiz analytics
- [ ] Student performance tracking
