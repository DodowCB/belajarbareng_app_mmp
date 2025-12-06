# Database Structure - Many-to-Many Relationship

## 🗂️ Collection Structure

### 1. **Collection: `files`**
Menyimpan metadata file yang diupload ke Google Drive.

**Document ID**: Integer (1, 2, 3, ...)

```json
{
  "drive_file_id": "abc123xyz",
  "name": "trigonometri.pdf",
  "mimeType": "application/pdf",
  "size": 2621440,
  "webViewLink": "https://drive.google.com/file/d/abc123/view",
  "uploadedBy": "1",
  "uploadedAt": "2025-12-07T10:30:00Z"
}
```

---

### 2. **Collection: `materi`**
Menyimpan informasi materi pembelajaran (tanpa array id_files).

**Document ID**: Integer (1, 2, 3, ...)

```json
{
  "judul": "Materi Trigonometri Dasar",
  "deskripsi": "Materi pengenalan trigonometri untuk kelas 10",
  "id_guru": "1",
  "id_kelas": "1",
  "id_mapel": "1",
  "createdAt": "2025-12-07T10:30:00Z",
  "updatedAt": "2025-12-07T10:30:00Z"
}
```

**Catatan**: Tidak ada field `id_files` lagi!

---

### 3. **Collection: `materi_files`** (Junction Table) ⭐
Many-to-many relationship antara materi dan files.

**Document ID**: Integer (1, 2, 3, ...)

```json
{
  "id_materi": 1,     // Integer reference ke materi collection
  "id_files": 2,      // Integer reference ke files collection
  "createdAt": "2025-12-07T10:30:00Z"
}
```

**Index yang direkomendasikan:**
- `id_materi` (untuk query files by materi)
- `id_files` (untuk query materi by file)
- Composite: `id_materi` + `id_files` (unique constraint)

---

## 📊 Relationship Diagram

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│   materi    │         │  materi_files    │         │    files    │
│             │         │  (junction)      │         │             │
│ id: 1       │◄────────│ id: 1            │────────►│ id: 1       │
│ judul       │         │ id_materi: 1     │         │ name        │
│ deskripsi   │         │ id_files: 1      │         │ mimeType    │
│ id_guru     │         │                  │         │ size        │
│ id_kelas    │         │ id: 2            │         │ webViewLink │
│ id_mapel    │         │ id_materi: 1     │         │             │
└─────────────┘         │ id_files: 2      │         │ id: 2       │
                        │                  │────────►│ name        │
                        │ id: 3            │         │ ...         │
                        │ id_materi: 2     │         │             │
                        │ id_files: 1      │         │ id: 3       │
                        │                  │────────►│ ...         │
                        └──────────────────┘         └─────────────┘
```

**Contoh Relationship:**
- Materi #1 punya File #1 dan File #2 (2 entries di materi_files)
- Materi #2 punya File #1 (1 entry di materi_files)
- File #1 digunakan di Materi #1 dan #2 (reusable!)

---

## ✅ Keuntungan Many-to-Many

### 1. **File Reusability**
```
Materi A: "Trigonometri Dasar" → uses File #1 (rumus.pdf)
Materi B: "Trigonometri Lanjut" → uses File #1 (rumus.pdf)
```
File yang sama bisa digunakan di multiple materi tanpa duplikasi!

### 2. **Flexible Updates**
- Update file metadata di 1 tempat
- Otomatis ter-update di semua materi yang menggunakan file tersebut

### 3. **Easy Queries**
- Cari semua file untuk 1 materi
- Cari semua materi yang menggunakan 1 file

### 4. **No Array Limitations**
- Tidak ada limit jumlah files per materi
- Tidak ada nested array issues

---

## 🔍 Query Examples

### 1. Get All Files for a Materi

```dart
Future<List<Map<String, dynamic>>> getFilesForMateri(int materiId) async {
  final firestore = FirebaseFirestore.instance;
  
  // Step 1: Get all materi_files entries for this materi
  final materiFilesSnapshot = await firestore
      .collection('materi_files')
      .where('id_materi', isEqualTo: materiId)
      .get();
  
  // Step 2: Extract file IDs
  final fileIds = materiFilesSnapshot.docs
      .map((doc) => doc.data()['id_files'] as int)
      .toList();
  
  // Step 3: Batch get all files
  final filesFutures = fileIds.map((fileId) =>
    firestore.collection('files').doc(fileId.toString()).get()
  ).toList();
  
  final filesDocs = await Future.wait(filesFutures);
  
  return filesDocs
      .where((doc) => doc.exists)
      .map((doc) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return data;
      })
      .toList();
}
```

### 2. Get All Materi Using a Specific File

```dart
Future<List<Map<String, dynamic>>> getMateriUsingFile(int fileId) async {
  final firestore = FirebaseFirestore.instance;
  
  // Step 1: Find all materi_files entries with this file
  final materiFilesSnapshot = await firestore
      .collection('materi_files')
      .where('id_files', isEqualTo: fileId)
      .get();
  
  // Step 2: Extract materi IDs
  final materiIds = materiFilesSnapshot.docs
      .map((doc) => doc.data()['id_materi'] as int)
      .toList();
  
  // Step 3: Batch get all materi
  final materiFutures = materiIds.map((materiId) =>
    firestore.collection('materi').doc(materiId.toString()).get()
  ).toList();
  
  final materiDocs = await Future.wait(materiFutures);
  
  return materiDocs
      .where((doc) => doc.exists)
      .map((doc) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return data;
      })
      .toList();
}
```

### 3. Get Materi with All File Details (Join)

```dart
Future<Map<String, dynamic>> getMateriWithFiles(int materiId) async {
  final firestore = FirebaseFirestore.instance;
  
  // Get materi
  final materiDoc = await firestore
      .collection('materi')
      .doc(materiId.toString())
      .get();
  
  if (!materiDoc.exists) {
    throw Exception('Materi not found');
  }
  
  final materiData = materiDoc.data()!;
  materiData['id'] = materiDoc.id;
  
  // Get files
  final files = await getFilesForMateri(materiId);
  materiData['files'] = files;
  
  return materiData;
}
```

### 4. Delete Materi (with Cascade)

```dart
Future<void> deleteMateri(int materiId) async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  
  // Delete materi document
  batch.delete(
    firestore.collection('materi').doc(materiId.toString())
  );
  
  // Delete all materi_files relationships
  final materiFilesSnapshot = await firestore
      .collection('materi_files')
      .where('id_materi', isEqualTo: materiId)
      .get();
  
  for (final doc in materiFilesSnapshot.docs) {
    batch.delete(doc.reference);
  }
  
  await batch.commit();
  
  // Note: Files tetap ada di collection 'files' (bisa reusable)
  // Kalau mau delete files juga, perlu cek dulu apakah file
  // masih digunakan di materi lain
}
```

---

## 📋 Data Flow

### Upload Flow:
```
1. User picks file
   ↓
2. Upload to Google Drive
   ↓
3. Save to 'files' collection (get ID: 1, 2, 3...)
   ↓
4. Store file ID in local array
   ↓
5. User fills form & clicks "Simpan Materi"
   ↓
6. Create document in 'materi' collection (get ID: 1)
   ↓
7. Create entries in 'materi_files':
   - Document ID: 1, id_materi: 1, id_files: 1
   - Document ID: 2, id_materi: 1, id_files: 2
   - Document ID: 3, id_materi: 1, id_files: 3
```

### Display Flow:
```
1. Query 'materi' by kelas/mapel
   ↓
2. Get materi document (ID: 1)
   ↓
3. Query 'materi_files' where id_materi = 1
   ↓
4. Get file IDs: [1, 2, 3]
   ↓
5. Batch query 'files' collection with those IDs
   ↓
6. Join data and display
```

---

## 🔒 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Files collection
    match /files/{fileId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                       request.resource.data.uploadedBy == request.auth.uid;
      allow update, delete: if request.auth != null && 
                               resource.data.uploadedBy == request.auth.uid;
    }
    
    // Materi collection
    match /materi/{materiId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                       request.resource.data.id_guru == request.auth.uid;
      allow update, delete: if request.auth != null && 
                               resource.data.id_guru == request.auth.uid;
    }
    
    // Materi_files junction table
    match /materi_files/{materiFileId} {
      allow read: if request.auth != null;
      
      // Only allow create if user owns the materi
      allow create: if request.auth != null && 
                       exists(/databases/$(database)/documents/materi/$(request.resource.data.id_materi)) &&
                       get(/databases/$(database)/documents/materi/$(request.resource.data.id_materi)).data.id_guru == request.auth.uid;
      
      // Only allow delete if user owns the materi
      allow delete: if request.auth != null && 
                       exists(/databases/$(database)/documents/materi/$(resource.data.id_materi)) &&
                       get(/databases/$(database)/documents/materi/$(resource.data.id_materi)).data.id_guru == request.auth.uid;
    }
  }
}
```

---

## 📊 Example Data

### Collection: `files`
```
Document ID: "1"
{
  "drive_file_id": "abc123",
  "name": "rumus_trigonometri.pdf",
  "mimeType": "application/pdf",
  "size": 1024000,
  "webViewLink": "https://drive.google.com/...",
  "uploadedBy": "1",
  "uploadedAt": "2025-12-07T10:00:00Z"
}

Document ID: "2"
{
  "drive_file_id": "def456",
  "name": "contoh_soal.pdf",
  "mimeType": "application/pdf",
  "size": 2048000,
  "webViewLink": "https://drive.google.com/...",
  "uploadedBy": "1",
  "uploadedAt": "2025-12-07T10:05:00Z"
}
```

### Collection: `materi`
```
Document ID: "1"
{
  "judul": "Trigonometri Dasar",
  "deskripsi": "Materi pengenalan trigonometri",
  "id_guru": "1",
  "id_kelas": "1",
  "id_mapel": "1",
  "createdAt": "2025-12-07T10:30:00Z",
  "updatedAt": "2025-12-07T10:30:00Z"
}

Document ID: "2"
{
  "judul": "Trigonometri Lanjut",
  "deskripsi": "Materi lanjutan trigonometri",
  "id_guru": "1",
  "id_kelas": "1",
  "id_mapel": "1",
  "createdAt": "2025-12-07T11:00:00Z",
  "updatedAt": "2025-12-07T11:00:00Z"
}
```

### Collection: `materi_files` (Junction)
```
Document ID: "1"
{
  "id_materi": 1,    // Materi: "Trigonometri Dasar"
  "id_files": 1,     // File: "rumus_trigonometri.pdf"
  "createdAt": "2025-12-07T10:30:00Z"
}

Document ID: "2"
{
  "id_materi": 1,    // Materi: "Trigonometri Dasar"
  "id_files": 2,     // File: "contoh_soal.pdf"
  "createdAt": "2025-12-07T10:30:00Z"
}

Document ID: "3"
{
  "id_materi": 2,    // Materi: "Trigonometri Lanjut"
  "id_files": 1,     // File: "rumus_trigonometri.pdf" (REUSED!)
  "createdAt": "2025-12-07T11:00:00Z"
}
```

**Result:**
- Materi #1 "Trigonometri Dasar" memiliki 2 files: rumus_trigonometri.pdf dan contoh_soal.pdf
- Materi #2 "Trigonometri Lanjut" memiliki 1 file: rumus_trigonometri.pdf
- File "rumus_trigonometri.pdf" digunakan di 2 materi berbeda (tidak duplikat!)

---

## 🎯 Performance Tips

### 1. **Batch Operations**
Gunakan batch writes untuk create multiple materi_files entries:

```dart
final batch = firestore.batch();
for (final fileId in fileIds) {
  final ref = firestore.collection('materi_files').doc(id.toString());
  batch.set(ref, {
    'id_materi': materiId,
    'id_files': fileId,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
await batch.commit();
```

### 2. **Index Optimization**
Create composite indexes:
- `materi_files`: (`id_materi`, `createdAt`)
- `materi_files`: (`id_files`, `createdAt`)

### 3. **Caching**
Cache frequently accessed materi + files joins di local storage.

---

## 🔄 Migration from Old Structure

Jika ada data lama dengan `id_files` array di materi:

```dart
Future<void> migrateToManyToMany() async {
  final firestore = FirebaseFirestore.instance;
  
  final materiSnapshot = await firestore.collection('materi').get();
  int materiFilesIdCounter = 1;
  
  for (final materiDoc in materiSnapshot.docs) {
    final materiData = materiDoc.data();
    final materiId = int.parse(materiDoc.id);
    final idFiles = List<int>.from(materiData['id_files'] ?? []);
    
    // Create materi_files entries
    for (final fileId in idFiles) {
      await firestore
          .collection('materi_files')
          .doc(materiFilesIdCounter.toString())
          .set({
        'id_materi': materiId,
        'id_files': fileId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      materiFilesIdCounter++;
    }
    
    // Remove id_files from materi
    await firestore.collection('materi').doc(materiDoc.id).update({
      'id_files': FieldValue.delete(),
    });
  }
}
```

---

## ✨ Summary

**3 Collections:**
1. `files` - Store file metadata
2. `materi` - Store materi info (no id_files!)
3. `materi_files` - Junction table (id_materi + id_files)

**Benefits:**
- ✅ True many-to-many relationship
- ✅ File reusability across multiple materi
- ✅ Cleaner data structure
- ✅ Easier maintenance and queries
- ✅ Better scalability
