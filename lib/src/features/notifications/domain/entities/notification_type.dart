enum NotificationType {
  // Phase 1 - Core Notifications (5)
  tugas_baru,
  tugas_submitted,
  nilai_keluar,
  pengumuman,
  tugas_deadline,

  // Phase 2 - Enhanced Notifications (10)
  // Admin
  guru_registered,
  siswa_registered,
  tugas_deadline_approaching, // 1 day before
  quiz_deadline_approaching,
  
  // Guru
  siswa_join_kelas,
  qna_jawaban_guru, // Jawaban di QnA yang dibuat guru
  
  // Siswa
  siswa_tugas_deadline_approaching, // 1 day before
  siswa_quiz_deadline_approaching,
  qna_jawaban_siswa, // Jawaban di QnA yang ditanyakan siswa
  quiz_baru, // New quiz assigned
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.tugas_baru:
        return 'Tugas Baru';
      case NotificationType.tugas_submitted:
        return 'Tugas Dikumpulkan';
      case NotificationType.nilai_keluar:
        return 'Nilai Keluar';
      case NotificationType.pengumuman:
        return 'Pengumuman';
      case NotificationType.tugas_deadline:
        return 'Deadline Tugas';
      case NotificationType.guru_registered:
        return 'Guru Terdaftar';
      case NotificationType.siswa_registered:
        return 'Siswa Terdaftar';
      case NotificationType.tugas_deadline_approaching:
        return 'Tugas Mendekati Deadline';
      case NotificationType.quiz_deadline_approaching:
        return 'Quiz Mendekati Deadline';
      case NotificationType.siswa_join_kelas:
        return 'Siswa Bergabung';
      case NotificationType.qna_jawaban_guru:
        return 'Jawaban QnA';
      case NotificationType.siswa_tugas_deadline_approaching:
        return 'Pengingat Deadline Tugas';
      case NotificationType.siswa_quiz_deadline_approaching:
        return 'Pengingat Deadline Quiz';
      case NotificationType.qna_jawaban_siswa:
        return 'Jawaban QnA';
      case NotificationType.quiz_baru:
        return 'Quiz Baru';
    }
  }

  String get category {
    switch (this) {
      case NotificationType.tugas_baru:
      case NotificationType.tugas_submitted:
      case NotificationType.tugas_deadline:
      case NotificationType.tugas_deadline_approaching:
      case NotificationType.siswa_tugas_deadline_approaching:
        return 'tugas';
      case NotificationType.quiz_baru:
      case NotificationType.quiz_deadline_approaching:
      case NotificationType.siswa_quiz_deadline_approaching:
        return 'quiz';
      case NotificationType.nilai_keluar:
        return 'nilai';
      case NotificationType.pengumuman:
        return 'pengumuman';
      case NotificationType.qna_jawaban_guru:
      case NotificationType.qna_jawaban_siswa:
        return 'qna';
      case NotificationType.guru_registered:
      case NotificationType.siswa_registered:
      case NotificationType.siswa_join_kelas:
        return 'user_management';
    }
  }
}
