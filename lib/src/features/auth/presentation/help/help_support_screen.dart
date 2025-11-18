import 'package:flutter/material.dart';
import '../../../../core/config/theme.dart';
import '../widgets/admin_header.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<FAQItem> _faqItems = [
    FAQItem(
      category: 'Account',
      question: 'How do I reset my password?',
      answer:
          'To reset your password, go to Settings > Security & Privacy > Change Password. Enter your current password and then your new password twice to confirm.',
      icon: Icons.lock_reset,
    ),
    FAQItem(
      category: 'Account',
      question: 'How do I update my profile information?',
      answer:
          'Go to Profile from the menu, click on Edit Profile button, make your changes, and click Save.',
      icon: Icons.person,
    ),
    FAQItem(
      category: 'Classes',
      question: 'How do I add a new class?',
      answer:
          'Navigate to Classes Management, click the + button, fill in the class details including level, number, academic year, and assign a homeroom teacher.',
      icon: Icons.class_,
    ),
    FAQItem(
      category: 'Classes',
      question: 'How do I manage students in a class?',
      answer:
          'Click on a class card to view details, then click "View Students" to see and manage all students enrolled in that class.',
      icon: Icons.people,
    ),
    FAQItem(
      category: 'Teachers',
      question: 'How do I add a new teacher?',
      answer:
          'Go to Teachers Management, click the + button, fill in the teacher details including name, NIG, email, and phone number.',
      icon: Icons.person_add,
    ),
    FAQItem(
      category: 'Students',
      question: 'How do I register a new student?',
      answer:
          'Navigate to Students Management, click Add Student, fill in all required information including personal details, contact info, and parent information.',
      icon: Icons.school,
    ),
    FAQItem(
      category: 'Subjects',
      question: 'How do I create a new subject?',
      answer:
          'Go to Subjects Management, click the + button, enter the subject name, and save.',
      icon: Icons.library_books,
    ),
    FAQItem(
      category: 'Technical',
      question: 'The app is running slow, what should I do?',
      answer:
          'Try clearing the app cache by going to Settings > Data & Storage > Clear Cache. If the issue persists, contact support.',
      icon: Icons.speed,
    ),
    FAQItem(
      category: 'Technical',
      question: 'How do I enable dark mode?',
      answer:
          'You can toggle dark mode from the profile menu or go to Settings > Appearance > Dark Mode.',
      icon: Icons.dark_mode,
    ),
    FAQItem(
      category: 'Notifications',
      question: 'How do I manage notifications?',
      answer:
          'Go to Settings > Notifications to customize which notifications you want to receive via email, push, or with sound/vibration.',
      icon: Icons.notifications,
    ),
  ];

  List<FAQItem> get _filteredFAQs {
    var filtered = _faqItems;

    if (_selectedCategory != 'All') {
      filtered = filtered.where((faq) => faq.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((faq) =>
              faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  List<String> get _categories {
    final categories = _faqItems.map((faq) => faq.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminHeader(
        title: 'Help & Support',
        icon: Icons.help,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(
            child: _filteredFAQs.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      ..._filteredFAQs.map((faq) => _buildFAQCard(faq)),
                      const SizedBox(height: 20),
                      _buildContactSupport(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.sunsetGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.help_center, size: 64, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            'How can we help you?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find answers to common questions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search for help...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryPurple
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryPurple
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQCard(FAQItem faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(faq.icon, color: AppTheme.primaryPurple, size: 20),
          ),
          title: Text(
            faq.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              faq.category,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryPurple.withOpacity(0.7),
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupport() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.support_agent,
              size: 48,
              color: AppTheme.primaryPurple,
            ),
            const SizedBox(height: 12),
            const Text(
              'Still need help?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact our support team',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildContactButton(
              icon: Icons.email,
              label: 'Email Us',
              subtitle: 'support@belajarbareng.com',
              color: AppTheme.primaryPurple,
              onTap: () => _showContactDialog('Email'),
            ),
            const SizedBox(height: 12),
            _buildContactButton(
              icon: Icons.phone,
              label: 'Call Us',
              subtitle: '+62 812-3456-7890',
              color: AppTheme.accentGreen,
              onTap: () => _showContactDialog('Phone'),
            ),
            const SizedBox(height: 12),
            _buildContactButton(
              icon: Icons.chat,
              label: 'Live Chat',
              subtitle: 'Available 24/7',
              color: AppTheme.secondaryTeal,
              onTap: () => _showContactDialog('Chat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(String method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              method == 'Email'
                  ? Icons.email
                  : method == 'Phone'
                      ? Icons.phone
                      : Icons.chat,
              color: AppTheme.primaryPurple,
            ),
            const SizedBox(width: 12),
            Text('Contact via $method'),
          ],
        ),
        content: Text(
          method == 'Email'
              ? 'Opening email client...'
              : method == 'Phone'
                  ? 'Initiating call...'
                  : 'Starting live chat...',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String category;
  final String question;
  final String answer;
  final IconData icon;

  FAQItem({
    required this.category,
    required this.question,
    required this.answer,
    required this.icon,
  });
}
