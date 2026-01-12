import '../../../notifications/domain/entities/notification_type.dart';

class NotificationTemplate {
  final String id;
  final NotificationType type;
  final String titleTemplate;
  final String messageTemplate;
  final Map<String, dynamic> defaultData;

  const NotificationTemplate({
    required this.id,
    required this.type,
    required this.titleTemplate,
    required this.messageTemplate,
    this.defaultData = const {},
  });

  String renderTitle(Map<String, dynamic> data) {
    var title = titleTemplate;
    final combinedData = {...defaultData, ...data};
    
    combinedData.forEach((key, value) {
      title = title.replaceAll('{$key}', value.toString());
    });
    
    return title;
  }

  String renderMessage(Map<String, dynamic> data) {
    var message = messageTemplate;
    final combinedData = {...defaultData, ...data};
    
    combinedData.forEach((key, value) {
      message = message.replaceAll('{$key}', value.toString());
    });
    
    return message;
  }

  // Predefined templates
  static final Map<NotificationType, NotificationTemplate> templates = {
    NotificationType.tugas_baru: NotificationTemplate(
      id: 'tugas_baru',
      type: NotificationType.tugas_baru,
      titleTemplate: 'Tugas Baru: {tugasJudul}',
      messageTemplate: '{guruName} memberikan tugas baru untuk {kelasName}. Deadline: {deadline}',
    ),
    NotificationType.tugas_submitted: NotificationTemplate(
      id: 'tugas_submitted',
      type: NotificationType.tugas_submitted,
      titleTemplate: 'Tugas Dikumpulkan',
      messageTemplate: '{siswaName} telah mengumpulkan tugas "{tugasJudul}"',
    ),
    NotificationType.nilai_keluar: NotificationTemplate(
      id: 'nilai_keluar',
      type: NotificationType.nilai_keluar,
      titleTemplate: 'Nilai Keluar: {namaTugas}',
      messageTemplate: 'Nilai Anda untuk "{namaTugas}": {nilai}',
    ),
    NotificationType.pengumuman: NotificationTemplate(
      id: 'pengumuman',
      type: NotificationType.pengumuman,
      titleTemplate: 'Pengumuman: {judul}',
      messageTemplate: '{isi}',
    ),
    NotificationType.tugas_deadline: NotificationTemplate(
      id: 'tugas_deadline',
      type: NotificationType.tugas_deadline,
      titleTemplate: 'Deadline Tugas Hari Ini',
      messageTemplate: 'Tugas "{tugasJudul}" akan berakhir hari ini pukul {waktu}',
    ),
    NotificationType.guru_registered: NotificationTemplate(
      id: 'guru_registered',
      type: NotificationType.guru_registered,
      titleTemplate: 'Guru Baru Terdaftar',
      messageTemplate: '{guruName} telah mendaftar sebagai guru',
    ),
    NotificationType.siswa_registered: NotificationTemplate(
      id: 'siswa_registered',
      type: NotificationType.siswa_registered,
      titleTemplate: 'Siswa Baru Terdaftar',
      messageTemplate: '{siswaName} telah mendaftar sebagai siswa',
    ),
    NotificationType.tugas_deadline_approaching: NotificationTemplate(
      id: 'tugas_deadline_approaching',
      type: NotificationType.tugas_deadline_approaching,
      titleTemplate: 'Pengingat Deadline Tugas',
      messageTemplate: 'Tugas "{tugasJudul}" akan berakhir dalam {hoursLeft} jam',
    ),
    NotificationType.quiz_deadline_approaching: NotificationTemplate(
      id: 'quiz_deadline_approaching',
      type: NotificationType.quiz_deadline_approaching,
      titleTemplate: 'Pengingat Deadline Quiz',
      messageTemplate: 'Quiz "{quizJudul}" akan berakhir dalam {hoursLeft} jam',
    ),
    NotificationType.siswa_join_kelas: NotificationTemplate(
      id: 'siswa_join_kelas',
      type: NotificationType.siswa_join_kelas,
      titleTemplate: 'Siswa Bergabung ke Kelas',
      messageTemplate: '{siswaName} telah bergabung ke kelas {kelasName}',
    ),
    NotificationType.qna_jawaban_guru: NotificationTemplate(
      id: 'qna_jawaban_guru',
      type: NotificationType.qna_jawaban_guru,
      titleTemplate: 'Jawaban Baru di QnA Anda',
      messageTemplate: '{userName} menjawab pertanyaan "{pertanyaan}"',
    ),
    NotificationType.siswa_tugas_deadline_approaching: NotificationTemplate(
      id: 'siswa_tugas_deadline_approaching',
      type: NotificationType.siswa_tugas_deadline_approaching,
      titleTemplate: '⏰ Pengingat Deadline Tugas',
      messageTemplate: 'Tugas "{tugasJudul}" akan berakhir besok pukul {waktu}',
    ),
    NotificationType.siswa_quiz_deadline_approaching: NotificationTemplate(
      id: 'siswa_quiz_deadline_approaching',
      type: NotificationType.siswa_quiz_deadline_approaching,
      titleTemplate: '⏰ Pengingat Deadline Quiz',
      messageTemplate: 'Quiz "{quizJudul}" akan berakhir besok pukul {waktu}',
    ),
    NotificationType.qna_jawaban_siswa: NotificationTemplate(
      id: 'qna_jawaban_siswa',
      type: NotificationType.qna_jawaban_siswa,
      titleTemplate: 'Jawaban Baru di QnA Anda',
      messageTemplate: '{userName} menjawab pertanyaan "{pertanyaan}"',
    ),
    NotificationType.quiz_baru: NotificationTemplate(
      id: 'quiz_baru',
      type: NotificationType.quiz_baru,
      titleTemplate: 'Quiz Baru: {quizJudul}',
      messageTemplate: '{guruName} memberikan quiz baru untuk {kelasName}. Deadline: {deadline}',
    ),
  };

  static NotificationTemplate? getTemplate(NotificationType type) {
    return templates[type];
  }
}
