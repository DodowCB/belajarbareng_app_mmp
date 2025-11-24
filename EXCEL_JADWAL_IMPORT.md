# Excel Import untuk Jadwal Mengajar

## Format File Excel

File Excel harus dalam format `.xlsx` dengan kolom berikut:

| Kolom | Deskripsi | Contoh |
|-------|-----------|---------|
| Guru | Nama guru (harus sama persis dengan database) | "Budi Santoso" |
| Kelas | Nama kelas (harus sama persis dengan database) | "10 IPA 1" |
| Mapel | Nama mata pelajaran (harus sama persis dengan database) | "Matematika" |
| Jam | Rentang waktu | "08:00-09:00" |
| Hari | Hari dalam seminggu | "Senin" |
| Tanggal | Tanggal | "15/10/2024" |

## Struktur Database

System akan mencari data yang cocok di Firebase berdasarkan field berikut:
- **Guru**: Mencari di collection `guru` dengan field `nama_lengkap`
- **Kelas**: Mencari di collection `kelas` dengan field `namaKelas`
- **Mapel**: Mencari di collection `mapel` dengan field `namaMapel`

## Contoh Data Excel

```
| Guru          | Kelas    | Mapel       | Jam        | Hari  | Tanggal    |
|---------------|----------|-------------|------------|-------|------------|
| Budi Santoso  | 10 IPA 1 | Matematika  | 08:00-09:00| Senin | 15/10/2024 |
| Siti Nurhaliza| 10 IPA 2 | Bahasa Indonesia | 09:00-10:00| Senin | 15/10/2024 |
```

## Catatan Penting

1. Nama harus cocok **persis** dengan yang ada di database (case-sensitive)
2. Format tanggal menggunakan DD/MM/YYYY
3. Format jam menggunakan HH:MM-HH:MM
4. Hari menggunakan nama hari dalam bahasa Indonesia
5. File harus berformat `.xlsx` (bukan `.xls`)

## Error Handling

Jika ada data yang tidak ditemukan di database, sistem akan:
1. Menampilkan error di console
2. Menampilkan pesan error dengan emoji
3. Melanjutkan ke data berikutnya (tidak menghentikan proses)