# Firestore Index Setup for Notifications

## Required Composite Index

Untuk mengoptimalkan query notifikasi berdasarkan user dan waktu, diperlukan **composite index** pada Firestore collection `notifications`.

### Index Configuration

**Collection**: `notifications`

**Fields to Index**:

1. `userId` - Ascending (ASC)
2. `createdAt` - Descending (DESC)

### Setup Instructions

#### Option 1: Automatic Setup via Error Message

1. Jalankan aplikasi dan buka halaman Notifikasi
2. Firebase akan menampilkan error dengan link untuk membuat index
3. Klik link tersebut untuk otomatis membuat index di Firebase Console

#### Option 2: Manual Setup via Firebase Console

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda
3. Navigasi ke **Firestore Database** > **Indexes** > **Composite**
4. Klik **"Create Index"** atau **"Add Index"**
5. Atur konfigurasi berikut:
   - Collection ID: `notifications`
   - Fields:
     - Field path: `userId`, Order: `Ascending`
     - Field path: `createdAt`, Order: `Descending`
   - Query scope: `Collection`
6. Klik **Create**
7. Tunggu hingga status index berubah menjadi **Enabled** (biasanya 5-10 menit)

#### Option 3: Deploy via Firebase CLI

Tambahkan konfigurasi berikut ke file `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "notifications",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "userId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    }
  ],
  "fieldOverrides": []
}
```

Deploy menggunakan command:

```bash
firebase deploy --only firestore:indexes
```

### Why This Index is Needed

Query yang digunakan di `NotificationRepository`:

```dart
// getUserNotifications - mengambil semua notifikasi user, sorted by createdAt DESC
return _firestore
    .collection('notifications')
    .where('userId', isEqualTo: userId)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map(...);

// getUnreadNotifications - mengambil notifikasi belum dibaca
return _firestore
    .collection('notifications')
    .where('userId', isEqualTo: userId)
    .where('isRead', isEqualTo: false)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map(...);
```

Tanpa index ini, query akan error dengan pesan:

> "The query requires an index. You can create it here: [link]"

### Performance Impact

- **Without Index**: Query timeout atau error
- **With Index**:
  - Response time: <100ms untuk 1000 notifikasi
  - Efficient pagination support
  - Real-time updates tetap responsive

### Verification

Setelah index dibuat, verifikasi dengan:

1. Buka aplikasi dan navigasi ke **Notifikasi**
2. Pastikan notifikasi muncul tanpa error
3. Test filter (Semua/Belum Dibaca/Sudah Dibaca) berfungsi
4. Check Firebase Console > Firestore > Indexes - status harus **Enabled**

### Troubleshooting

**Index masih dalam status "Building"**

- Tunggu hingga selesai (5-15 menit untuk dataset kecil)
- Jangan hapus atau edit index saat building

**Query masih error setelah index enabled**

- Refresh aplikasi
- Check apakah field names exact match (case-sensitive)
- Verify collection name adalah `notifications` (bukan `Notifications` atau `notification`)

**Multiple indexes requested**

- Jika ada additional index requests, ikuti link yang diberikan Firebase
- Index untuk query dengan `where('isRead')` mungkin diperlukan terpisah

### Additional Indexes (Optional)

Jika ingin menambahkan filter berdasarkan type atau priority:

```json
{
  "collectionGroup": "notifications",
  "queryScope": "COLLECTION",
  "fields": [
    {
      "fieldPath": "userId",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "type",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "createdAt",
      "order": "DESCENDING"
    }
  ]
}
```

## Summary

✅ **Primary Index Required**: `userId (ASC)` + `createdAt (DESC)`  
⏱️ **Setup Time**: 5-10 minutes  
🎯 **Target Performance**: <100ms query response  
📱 **Affects**: NotificationsScreen, badge counters, real-time updates
