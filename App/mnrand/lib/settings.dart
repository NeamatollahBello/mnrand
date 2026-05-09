import 'package:flutter/material.dart';
import 'clients.dart';
import 'appsettings.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/ui.dart';
import 'login.dart';
import 'materials.dart';
import 'options.dart';
import 'pagetemplate.dart';

class TSettingsForm extends TForm {
  onMenuTap(int index) async {
    if (index == 0) {
      accountsForm.showModal();
    }
    if (index == 1) {
      materialsForm.showModal();
    }
    if (index == 2) {
      optionsForm.showModal();
    }
    if (index == 3) {
      //reconnect
      loginForm.isLoading = false;
      loginForm.edtComp.value = lastComp;
      loginForm.edtUser.value = lastUser;
      loginForm.edtPass.value = lastPass;
      loginForm.showModal();
    }
    if (index == 4) {
      //log out
      loginForm.isLoading = false;
      loginForm.edtComp.value = '';
      loginForm.edtUser.value = '';
      loginForm.edtPass.value = '';
      loginForm.chkRemember.checked = false;
      await setApiToken('', true);
      await setLastUserPass('', '', '', true);
      loginForm.showOnly();
    }
  }

  // Settings icons for menu items
  final List<IconData> _menuIcons = [
    Icons.people_outline_rounded,
    Icons.grid_view_rounded,
    Icons.settings_outlined,
    Icons.refresh_rounded,
    Icons.logout_rounded,
  ];

// Subtitle for menu items - will use dynamic values
  String _getSubtitle(int index) {
    switch (index) {
      case 0:
        return '${accountsForm.clients.recordCount} زبون';
      case 1:
        return '${materialsForm.materials.recordCount} مادة';
      case 2:
        return 'إعدادات النظام';
      case 3:
        return 'تغيير بيانات الدخول';
      case 4:
        return 'تسجيل خروج من النظام';
      default:
        return '';
    }
  }

  TSettingsForm() : super();
  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
      activeIndex: 3,
      appBarTitle: 'الإعدادات',
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
            // DATA Group
            _buildSettingsGroup(
              title: 'إدارة البيانات',
              children: [
                _buildSettingsTile(0),
                _buildSettingsTile(1),
              ],
            ),
            const SizedBox(height: 20),
            // Settings Group (خيارات)
            _buildSettingsGroup(
              title: 'إعدادات',
              children: [
                _buildSettingsTile(2),
              ],
            ),
            const SizedBox(height: 20),
            // Connection Group
            _buildSettingsGroup(
              title: 'الاتصال',
              children: [
                _buildSettingsTile(3),
                _buildSettingsTile(4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFEA580C),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile(int index) {
    // Show border for last item in each group: 1 (إدارة البيانات), 2 (إعدادات), 4 (الاتصال)
    bool showBorder = (index == 1 || index == 2 || index == 4);
    return InkWell(
      onTap: () => onMenuTap(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(bottom: BorderSide(color: Colors.grey.shade50))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              _menuIcons[index],
              color: const Color(0xFF94A3B8),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _menuTitles[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getSubtitle(index),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Menu titles
  final List<String> _menuTitles = [
    'إدارة الزبائن',
    'إدارة المواد',
    'خيارات',
    'إعادة الاتصال',
    'تسجيل خروج',
  ];
}

TSettingsForm settingsForm = TSettingsForm();
