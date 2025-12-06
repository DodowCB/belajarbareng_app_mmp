# Upload Materi Workflow

## Ringkasan Fitur

Fitur Upload Materi memungkinkan guru untuk mengunggah file materi pembelajaran ke Google Drive dan menyimpan informasi materi ke Firestore.

## Alur Proses

### 1. **Upload File ke Google Drive**
Ketika guru klik tombol "Pilih File untuk Upload":

```
┌─────────────────────────────────────────┐
│ Guru Pilih File (PDF, DOC, PPT, dll)   │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ Cek/Buat Folder Structure di Drive:    │
│                                         │
│  BelajarBareng MMP/                     │
│    └─ {email guru}/                     │
│         └─ file1.pdf                    │
│         └─ file2.docx                   │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ Upload File ke Folder Email Guru        │
│ - Dapat upload multiple files           │
│ - File tersimpan di Google Drive        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ Tampilkan List File yang Diupload      │
│ - Nama file                             │
│ - Ukuran file                           │
│ - Icon sesuai tipe file                 │
└─────────────────────────────────────────┘
```

**Struktur Folder di Google Drive:**
```
BelajarBareng MMP/
├── given.l23@mhs.istts.ac.id/
│   ├── materi_matematika.pdf
│   ├── slide_presentasi.pptx
│   └── latihan_soal.docx
└── guru2@mhs.istts.ac.id/
    ├── modul_fisika.pdf
    └── video_pembelajaran.mp4
```

**Keuntungan:**
- ✅ File terorganisir per email guru
- ✅ Mudah tracking siapa yang upload file
- ✅ Folder otomatis dibuat jika belum ada
- ✅ File aman tersimpan di Google Drive
- ✅ Tidak memakan storage Firebase

---

### 2. **Simpan Materi ke Firestore**
Setelah file diupload, guru mengisi form dan klik "Simpan Materi":

```
┌─────────────────────────────────────────┐
│ Guru Isi Form:                          │
│ - Judul Materi                          │
│ - Deskripsi                             │
│ - Pilih Kelas                           │
│ - Pilih Mata Pelajaran                  │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ Simpan ke Firestore Collection:        │
│ "materi"                                │
│                                         │
│ Data yang disimpan:                     │
│ - judul                                 │
│ - deskripsi                             │
│ - id_guru                               │
│ - id_kelas                              │
│ - id_mapel                              │
│ - files: [                              │
│     {                                   │
│       id: "drive_file_id",              │
│       name: "file.pdf",                 │
│       mimeType: "application/pdf",      │
│       size: 1024000,                    │
│       webViewLink: "https://..."        │
│     }                                   │
│   ]                                     │
│ - createdAt                             │
│ - updatedAt                             │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│ Siswa Dapat Akses Materi               │
│ - Lihat judul dan deskripsi             │
│ - Download/View file dari link Drive    │
│ - Filter by kelas dan mapel             │
└─────────────────────────────────────────┘
```

**Fungsi Simpan Materi:**
- 📝 Menyimpan **metadata** materi ke database
- 🔗 Menyimpan **link** file dari Google Drive
- 👨‍🏫 Menghubungkan dengan kelas dan mata pelajaran
- 🔍 Memudahkan pencarian dan filtering materi

**Yang TIDAK disimpan di Firestore:**
- ❌ File fisik (PDF, DOC, dll) → ini di Google Drive
- ❌ Binary data file → terlalu besar untuk Firestore

---

## Perbandingan: Upload File vs Simpan Materi

| Aspek | Upload File | Simpan Materi |
|-------|-------------|---------------|
| **Tujuan** | Menyimpan file fisik | Menyimpan informasi materi |
| **Lokasi** | Google Drive | Firestore Database |
| **Data** | File binary (PDF, DOC, PPT) | Metadata (judul, deskripsi, link) |
| **Struktur** | `BelajarBareng MMP/{email}/file.pdf` | Collection `materi` document |
| **Akses** | Via webViewLink | Query database |

---

## Contoh Use Case

### Skenario: Guru Upload Materi Matematika

1. **Guru login** dengan `given.l23@mhs.istts.ac.id`

2. **Upload File:**
   - Pilih file: `trigonometri.pdf` (2.5 MB)
   - File tersimpan di: `BelajarBareng MMP/given.l23@mhs.istts.ac.id/trigonometri.pdf`
   - Dapat webViewLink: `https://drive.google.com/file/d/abc123.../view`

3. **Isi Form:**
   - Judul: "Materi Trigonometri Dasar"
   - Deskripsi: "Materi pengenalan trigonometri untuk kelas 10"
   - Kelas: "10 10A"
   - Mapel: "Matematika"

4. **Simpan Materi:**
   - Data tersimpan di Firestore `materi/1`:
   ```json
   {
     "judul": "Materi Trigonometri Dasar",
     "deskripsi": "Materi pengenalan trigonometri untuk kelas 10",
     "id_guru": "1",
     "id_kelas": "1",
     "id_mapel": "1",
     "files": [
       {
         "id": "abc123xyz",
         "name": "trigonometri.pdf",
         "mimeType": "application/pdf",
         "size": 2621440,
         "webViewLink": "https://drive.google.com/file/d/abc123.../view"
       }
     ],
     "createdAt": "2025-12-07T10:30:00Z",
     "updatedAt": "2025-12-07T10:30:00Z"
   }
   ```

5. **Siswa Akses:**
   - Siswa kelas 10A membuka menu Materi
   - Melihat "Materi Trigonometri Dasar"
   - Klik untuk view/download file dari Google Drive

---

## Keamanan dan Permission

### Google Drive Permission
- File diupload dengan permission default (private)
- Hanya owner (guru) yang dapat edit/delete
- Siswa akses via `webViewLink` dengan permission viewer

### Firestore Security Rules (Rekomendasi)
```javascript
match /materi/{materiId} {
  // Guru dapat create, read, update materi mereka sendiri
  allow create: if request.auth != null && 
                   request.resource.data.id_guru == request.auth.uid;
  
  allow read: if request.auth != null;
  
  allow update, delete: if request.auth != null && 
                           resource.data.id_guru == request.auth.uid;
}
```

---

## Troubleshooting

### File Tidak Muncul di List
- ✅ Pastikan sudah sign in ke Google Drive
- ✅ Cek koneksi internet
- ✅ Pastikan file format didukung

### Folder Tidak Terbuat
- ✅ Cek permission Google Drive API
- ✅ Pastikan scope `drive.file` aktif
- ✅ Lihat console log untuk error

### Simpan ke Firestore Gagal
- ✅ Pastikan form valid (judul, kelas, mapel terisi)
- ✅ Minimal 1 file sudah diupload
- ✅ Cek Firestore rules permission

---

## Future Enhancement

- [ ] Bulk upload multiple files sekaligus
- [ ] Progress bar saat upload file besar
- [ ] Preview file sebelum upload
- [ ] Edit materi yang sudah disimpan
- [ ] Delete materi dan file dari Drive
- [ ] Share file ke specific students
- [ ] Notifikasi ke siswa saat materi baru
