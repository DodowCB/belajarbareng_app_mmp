import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _namaLengkapController = TextEditingController();
  final _emailController = TextEditingController();
  final _nigController = TextEditingController();
  final _mataPelajaranController = TextEditingController();
  final _sekolahController = TextEditingController();
  final _jenisKelaminController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _tanggalLahir;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _mataPelajaranList = [
    'Matematika',
    'Bahasa Indonesia',
    'Bahasa Inggris',
    'IPA',
    'IPS',
    'Fisika',
    'Kimia',
    'Biologi',
    'Sejarah',
    'Geografi',
    'Ekonomi',
    'Sosiologi',
    'Seni Budaya',
    'Pendidikan Jasmani',
    'Teknologi Informasi',
    'Lainnya',
  ];

  final List<Map<String, String>> _jenisKelaminList = [
    {'value': 'l', 'label': 'Laki-laki'},
    {'value': 'p', 'label': 'Perempuan'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _emailController.dispose();
    _nigController.dispose();
    _mataPelajaranController.dispose();
    _sekolahController.dispose();
    _jenisKelaminController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppTheme.accentOrange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.oceanGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildRegisterCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Akun',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Buat akun guru baru',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Guru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Nama Lengkap Field
                _buildTextField(
                  controller: _namaLengkapController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // NIG Field
                _buildTextField(
                  controller: _nigController,
                  label: 'Nomor Induk Guru (NIG)',
                  hint: 'Masukkan nomor induk guru',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIG tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'NIG harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Mata Pelajaran Dropdown
                _buildDropdownField(),
                const SizedBox(height: 20),

                // Sekolah Field
                _buildTextField(
                  controller: _sekolahController,
                  label: 'Sekolah',
                  hint: 'Masukkan nama sekolah',
                  icon: Icons.school_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama sekolah tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Jenis Kelamin Dropdown
                _buildJenisKelaminDropdown(),
                const SizedBox(height: 20),

                // Tanggal Lahir Field
                _buildTanggalLahirField(),
                const SizedBox(height: 24),

                // Divider
                const Divider(),
                const SizedBox(height: 24),

                const Text(
                  'Keamanan Akun',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                // Password Field
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Masukkan password',
                  isVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password',
                  hint: 'Masukkan ulang password',
                  isVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Register Button
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: AppTheme.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mata Pelajaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: 'Pilih mata pelajaran',
            prefixIcon: const Icon(Icons.subject_outlined),
            filled: true,
            fillColor: AppTheme.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
            ),
          ),
          items: _mataPelajaranList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            _mataPelajaranController.text = value ?? '';
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pilih mata pelajaran';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildJenisKelaminDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: 'Pilih jenis kelamin',
            prefixIcon: const Icon(Icons.person_outline),
            filled: true,
            fillColor: AppTheme.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
            ),
          ),
          items: _jenisKelaminList.map((Map<String, String> item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Text(item['label']!),
            );
          }).toList(),
          onChanged: (String? value) {
            _jenisKelaminController.text = value ?? '';
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pilih jenis kelamin';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTanggalLahirField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Lahir',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: _tanggalLahir == null
                ? 'Pilih tanggal lahir'
                : '${_tanggalLahir!.day}/${_tanggalLahir!.month}/${_tanggalLahir!.year}',
            prefixIcon: const Icon(Icons.calendar_today_outlined),
            filled: true,
            fillColor: AppTheme.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
            ),
          ),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _tanggalLahir = picked;
              });
            }
          },
          validator: (value) {
            if (_tanggalLahir == null) {
              return 'Pilih tanggal lahir';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: AppTheme.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              namaLengkap: _namaLengkapController.text.trim(),
              nig: int.parse(_nigController.text.trim()),
              mataPelajaran: _mataPelajaranController.text.trim(),
              sekolah: _sekolahController.text.trim(),
              jenisKelamin: _jenisKelaminController.text.trim(),
              tanggalLahir: _tanggalLahir,
            ),
          );
    }
  }
}
