# 📊 Excel Import untuk Jadwal Mengajar

## 📋 Format File Excel (.xlsx)

Sistem ini hanya menerima file dengan ekstensi **.xlsx** (bukan .xls).

### 🏗️ Struktur Excel

File Excel harus memiliki kolom dalam urutan berikut:

| Column A | Column B | Column C | Column D | Column E | Column F |
|----------|----------|----------|----------|----------|-----------|
| Guru     | Kelas    | Mapel    | Hari     | Jam      | Tanggal   |

### 📝 Contoh Data

```
| Guru           | Kelas  | Mapel      | Hari    | Jam        | Tanggal    |
|----------------|--------|------------|---------|------------|------------|
| Columbina      | 11 1A  | Kimia      | Senin   | 08:00-09:00| 25/11/2025 |
| Penny          | 10 1A  | Matematika | Selasa  | 10:00-11:00| 26/11/2025 |
| Castorice      | 12 IPA | Fisika     | Rabu    | 13:00-14:00| 27/11/2025 |
```

### 🔍 **Nama Harus Sesuai Database**

**PENTING**: Nama di Excel harus **PERSIS SAMA** dengan nama di database:
- **Guru**: Gunakan nama sesuai field `nama` atau `nama_lengkap` di collection `guru`
- **Kelas**: Gunakan nama sesuai field `nama` atau `nama_kelas` di collection `kelas`  
- **Mapel**: Gunakan nama sesuai field `nama`, `nama_mapel`, atau `mata_pelajaran` di collection `mapel`

### ⚠️ Penting!

1. **Baris pertama** adalah header dan akan **diabaikan**
2. **Nama Guru, Kelas, dan Mapel** harus **SAMA PERSIS** dengan yang ada di database
3. **Format Tanggal**: `DD/MM/YYYY` (contoh: 25/11/2025)
4. **Format Jam**: `HH:MM-HH:MM` (contoh: 08:00-09:00)
5. **Hari** harus dalam bahasa Indonesia: Senin, Selasa, Rabu, Kamis, Jumat, Sabtu, Minggu

### 🔄 Proses Import

1. Klik tombol **"Import Excel"**
2. Pilih file .xls dari komputer
3. Sistem akan:
   - Memvalidasi format file
   - Mencari ID guru, kelas, dan mapel berdasarkan nama
   - Generate ID integer otomatis (1, 2, 3, ...)
   - Menyimpan ke database dengan timestamp

### 📊 Hasil Import

Setelah import selesai, akan muncul notifikasi:
- **Berhasil**: Jumlah data yang berhasil diimpor
- **Error**: Jumlah data yang gagal (karena nama tidak ditemukan atau format salah)

### ❌ Kemungkinan Error

- **Nama tidak ditemukan**: Guru/Kelas/Mapel tidak ada di database
- **Format tanggal salah**: Gunakan DD/MM/YYYY
- **File kosong**: File tidak memiliki data
5. **Format file salah**: Harus .xlsx, bukan .xls

### 💡 Tips

1. Pastikan semua data Guru, Kelas, dan Mapel sudah ada di sistem sebelum import
2. Gunakan Microsoft Excel atau LibreOffice untuk membuat file .xlsx
3. Periksa format tanggal dan jam sebelum import
4. Backup data sebelum melakukan import besar