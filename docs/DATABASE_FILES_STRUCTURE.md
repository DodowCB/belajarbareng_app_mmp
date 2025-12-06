# Database Structure - Files & Materi

## Collection Structure

### 📁 Collection: `files`

Menyimpan metadata file yang diupload ke Google Drive.

**Document ID**: Integer (1, 2, 3, ...)

```json
{
  "drive_file_id": "abc123xyz",           // ID file di Google Drive
  "name": "trigonometri.pdf",             // Nama file
  "mimeType": "application/pdf",          // Tipe file
  "size": 2621440,                        // Ukuran file (bytes)
  "webViewLink": "https://drive.google.com/file/d/abc123/view",
  "uploadedBy": "1",                      // ID guru yang upload
  "uploadedAt": "2025-12-07T10:30:00Z"    // Timestamp upload
}
```

**Index yang direkomendasikan:**
- `uploadedBy` (untuk query files by user)
- `uploadedAt` (untuk sorting by date)

---

### 📚 Collection: `materi`

Menyimpan informasi materi pembelajaran dengan referensi ke files.

**Document ID**: Integer (1, 2, 3, ...)

```json
{
  "judul": "Materi Trigonometri Dasar",
  "deskripsi": "Materi pengenalan trigonometri untuk kelas 10",
  "id_guru": "1",
  "id_kelas": "1",
  "id_mapel": "1",
  "id_files": [1, 2, 3],                  // Array of file IDs (integers)
  "createdAt": "2025-12-07T10:30:00Z",
  "updatedAt": "2025-12-07T10:30:00Z"
}
```

**Index yang direkomendasikan:**
- `id_guru` (untuk query materi by guru)
- `id_kelas` (untuk query materi by kelas)
- `id_mapel` (untuk query materi by mapel)
- Composite: `id_kelas` + `id_mapel` (untuk filtering)

---

## Keuntungan Struktur Terpisah

### ✅ **Normalisasi Database**
- File tidak duplikat jika digunakan di multiple materi
- Update file metadata di 1 tempat saja

### ✅ **Flexible Relationships**
- 1 materi bisa punya multiple files
- 1 file bisa digunakan di multiple materi (jika perlu)

### ✅ **Query Optimization**
- Query materi lebih cepat (tidak perlu load full file data)
- Bisa query files independent dari materi

### ✅ **Storage Efficiency**
- Dokumen materi lebih kecil
- Tidak ada nested arrays yang besar

---

## Query Examples

### Get Materi dengan Files

```dart
// 1. Get materi
final materiDoc = await FirebaseFirestore.instance
    .collection('materi')
    .doc('1')
    .get();

final materiData = materiDoc.data();
final fileIds = List<int>.from(materiData['id_files'] ?? []);

// 2. Get files
final files = [];
for (final fileId in fileIds) {
  final fileDoc = await FirebaseFirestore.instance
      .collection('files')
      .doc(fileId.toString())
      .get();
  
  if (fileDoc.exists) {
    files.add(fileDoc.data());
  }
}

// Result: materi dengan full file details
```

### Get All Files Uploaded by Guru

```dart
final filesSnapshot = await FirebaseFirestore.instance
    .collection('files')
    .where('uploadedBy', isEqualTo: '1')
    .orderBy('uploadedAt', descending: true)
    .get();

final files = filesSnapshot.docs.map((doc) => doc.data()).toList();
```

### Get Materi by Kelas dan Mapel

```dart
final materiSnapshot = await FirebaseFirestore.instance
    .collection('materi')
    .where('id_kelas', isEqualTo: '1')
    .where('id_mapel', isEqualTo: '1')
    .get();

final materiList = materiSnapshot.docs.map((doc) {
  final data = doc.data();
  data['id'] = doc.id;
  return data;
}).toList();
```

---

## Migration Notes

### Jika Sudah Ada Data Lama (dengan `files` array)

Perlu migration script untuk:
1. Extract files dari materi
2. Create documents di collection `files`
3. Update materi dengan `id_files` array

```dart
Future<void> migrateOldData() async {
  final firestore = FirebaseFirestore.instance;
  
  // Get all old materi
  final materiSnapshot = await firestore.collection('materi').get();
  
  int fileIdCounter = 1;
  
  for (final materiDoc in materiSnapshot.docs) {
    final materiData = materiDoc.data();
    final oldFiles = materiData['files'] as List?;
    
    if (oldFiles == null || oldFiles.isEmpty) continue;
    
    final fileIds = <int>[];
    
    // Migrate each file
    for (final fileData in oldFiles) {
      final fileId = fileIdCounter.toString();
      
      // Create file document
      await firestore.collection('files').doc(fileId).set({
        'drive_file_id': fileData['id'],
        'name': fileData['name'],
        'mimeType': fileData['mimeType'],
        'size': fileData['size'],
        'webViewLink': fileData['webViewLink'],
        'uploadedBy': materiData['id_guru'],
        'uploadedAt': materiData['createdAt'],
      });
      
      fileIds.add(fileIdCounter);
      fileIdCounter++;
    }
    
    // Update materi with id_files
    await firestore.collection('materi').doc(materiDoc.id).update({
      'id_files': fileIds,
    });
    
    // Remove old files field
    await firestore.collection('materi').doc(materiDoc.id).update({
      'files': FieldValue.delete(),
    });
  }
}
```

---

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Files collection
    match /files/{fileId} {
      // Allow read for authenticated users
      allow read: if request.auth != null;
      
      // Allow create for authenticated users
      allow create: if request.auth != null && 
                       request.resource.data.uploadedBy == request.auth.uid;
      
      // Allow update/delete only by file owner
      allow update, delete: if request.auth != null && 
                               resource.data.uploadedBy == request.auth.uid;
    }
    
    // Materi collection
    match /materi/{materiId} {
      // Allow read for authenticated users
      allow read: if request.auth != null;
      
      // Allow create for authenticated teachers
      allow create: if request.auth != null && 
                       request.resource.data.id_guru == request.auth.uid;
      
      // Allow update/delete only by materi owner (guru)
      allow update, delete: if request.auth != null && 
                               resource.data.id_guru == request.auth.uid;
    }
  }
}
```

---

## Performance Considerations

### Batching Reads
Untuk performa lebih baik, gunakan batch reads:

```dart
Future<List<Map<String, dynamic>>> getFilesForMateri(String materiId) async {
  final materiDoc = await FirebaseFirestore.instance
      .collection('materi')
      .doc(materiId)
      .get();
  
  final fileIds = List<int>.from(materiDoc.data()?['id_files'] ?? []);
  
  // Batch read all files
  final filesFutures = fileIds.map((fileId) => 
    FirebaseFirestore.instance
        .collection('files')
        .doc(fileId.toString())
        .get()
  ).toList();
  
  final filesDocs = await Future.wait(filesFutures);
  
  return filesDocs
      .where((doc) => doc.exists)
      .map((doc) => doc.data()!)
      .toList();
}
```

### Caching
Implement caching untuk files yang sering diakses:
- Use `GetOptions(source: Source.cache)` for offline support
- Store frequently accessed files in local storage

---

## Comparison: Old vs New Structure

| Aspect | Old Structure | New Structure |
|--------|---------------|---------------|
| **Files Location** | Embedded in `materi` | Separate `files` collection |
| **Document Size** | Large (with full file data) | Small (only IDs) |
| **Query Speed** | Slower (large docs) | Faster (smaller docs) |
| **Reusability** | No (duplicated files) | Yes (reference same file) |
| **Maintenance** | Update multiple places | Update once |
| **Scalability** | Limited | Better |

---

## Example Data Flow

### Upload Flow:
```
1. User picks file
   ↓
2. Upload to Google Drive
   ↓
3. Get Drive file metadata
   ↓
4. Create document in 'files' collection (ID: 1, 2, 3...)
   ↓
5. Store file ID in local array
   ↓
6. User fills form & clicks "Simpan Materi"
   ↓
7. Create document in 'materi' with id_files: [1, 2, 3]
```

### Display Flow:
```
1. Query 'materi' by kelas/mapel
   ↓
2. Get materi document
   ↓
3. Extract id_files array
   ↓
4. Batch query 'files' collection with those IDs
   ↓
5. Join data and display to user
```
