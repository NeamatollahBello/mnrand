import 'package:flutter/material.dart';
import 'appui.dart';
import 'kashf.dart';
import 'lib/flutter_utils.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';
import 'teacher.dart';

class TReportsForm extends TForm {
  onMenuTap(int index) async {
    if (index == 0) {
      if (!canKashf) {
        showSnack("ليس لديك صلاحية كشف الحساب.");
        return;
      }
      kashfForm.showModal();
    }
    if (index == 1) {
      if (!canTeacher) {
        showSnack("ليس لديك صلاحية كشف الحساب.");
        return;
      }
      teacherForm.showModal();
    }
  }

// Reports icons for menu items
  final List<IconData> _reportIcons = [
    Icons.account_balance_wallet_rounded,
    Icons.menu_book_rounded,
  ];

  // Report descriptions
  final List<String> _reportDescriptions = [
    'كشف حساب عميل',
    'دفتر الأستاذ العام',
  ];

  TReportsForm() : super();
  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
      activeIndex: 2,
      appBarTitle: 'التقارير',
      showAppBar: true,
      showBackButton: false,
      showBottomBar: true,
      backFunc: () {
        close();
      },
      child: UI(
        paddingAll: 16,
        child: ListView(
          children: [
            const SizedBox(height: 8),
            // Title
            const Text(
              ' اختر التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            // Report Cards
            _buildReportCard(0),
            const SizedBox(height: 12),
            _buildReportCard(1),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(int index) {
    return InkWell(
      onTap: () => onMenuTap(index),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _reportIcons[index],
                color: const Color(0xFFF97316),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _reportTitles[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _reportDescriptions[index],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFFCBD5E1),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // Report titles
  final List<String> _reportTitles = [
    'كشف حساب',
    'دفتر الأستاذ',
  ];
}

TReportsForm reportsForm = TReportsForm();
