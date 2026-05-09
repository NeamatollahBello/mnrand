import 'package:flutter/material.dart';
import 'addbill.dart';
import 'addop.dart';
import 'appui.dart';
import 'dayly.dart';
import 'lib/andsysutils.dart';
import 'lib/flutter_utils.dart';
import 'pos.dart';
import 'reports.dart';
import 'settings.dart';

class TTemplatePage extends StatefulWidget {
  final bool showBottomBar;
  final bool showAppBar;
  final bool showBackButton;
  final String appBarTitle;
  final void Function()? backFunc;
  final int activeIndex;
  final Widget child;

  const TTemplatePage(
      {super.key,
      required this.showBottomBar,
      required this.activeIndex,
      required this.showAppBar,
      required this.appBarTitle,
      required this.showBackButton,
      this.backFunc,
      required this.child});

  @override
  State<TTemplatePage> createState() => _TTemplatePageState();
}

class _TTemplatePageState extends State<TTemplatePage> {
  bool _isFabOpen = false;
  late BuildContext menuButtonContext;

  bottomBarButtonClick(int index) async {
    if (index == 1) {
      await invoicesForm.load();
      invoicesForm.showOnly();
    }
    if (index == 2) {
      await operationsForm.load();
      operationsForm.showOnly();
    }
    if (index == 3) {
      reportsForm.showOnly();
    }
    if (index == 4) {
      settingsForm.showOnly();
    }
  }

  handleNewCommand(int index) async {
    if (index == 0) {
      if (!canAddBill) {
        showSnack('ليس لديك صلاحيات لإضافة فاتورة مبيعات');
        return;
      }
      await addBillForm.prepareNew(1);
      addBillForm.showModal();
    }
    if (index == 1) {
      if (!canAddPayIn) {
        showSnack('ليس لديك صلاحيات لإضافة عملية قبض');
        return;
      }
      addOpForm.prepareNew(1);
      addOpForm.showModal();
    }
    if (index == 2) {
      if (!canAddDiscOut) {
        showSnack('ليس لديك صلاحيات لإضافة حسم ممنوح');
        return;
      }
      addOpForm.prepareNew(4);
      addOpForm.showModal();
    }
    if (index == 3) {
      if (!canAddDiscIn) {
        showSnack('ليس لديك صلاحيات لإضافة حسم مكتسب');
        return;
      }
      addOpForm.prepareNew(5);
      addOpForm.showModal();
    }
    if (index == 4) {
      if (!canAddSpent) {
        showSnack('ليس لديك صلاحيات لإضافة مصاريف');
        return;
      }
      addOpForm.prepareNew(3);
      addOpForm.showModal();
    }
    if (index == 5) {
      if (!canAddPayOut) {
        showSnack('ليس لديك صلاحيات لإضافة عملية دفع');
        return;
      }
      addOpForm.prepareNew(2);
      addOpForm.showModal();
    }
    if (index == 6) {
      if (!canAddReturn) {
        showSnack('ليس لديك صلاحيات لإضافة فاتورة مرتجع مبيعات');
        return;
      }
      addBillForm.prepareNew(2);
      addBillForm.showModal();
    }
    if (index == 7) {
      if (!canAddPrice) {
        showSnack('ليس لديك صلاحيات لإضافة عرض سعر');
        return;
      }
      addBillForm.prepareNew(3);
      addBillForm.showModal();
    }
    if (index == 8) {
      if (!canAddStock) {
        showSnack('ليس لديك صلاحيات لإضافة محضر جرد');
        return;
      }
      addBillForm.prepareNew(4);
      addBillForm.showModal();
    }
    if (index == 9) {
      if (!canAddBill) {
        showSnack('ليس لديك صلاحيات لإضافة فاتورة مبيعات');
        return;
      }
      if (!licHasPOS) {
        showSnack('الترخيص غير صا��ح.');
        return;
      }
      posForm.prepareNew();
      posForm.needRefreshDayly = false;
      posForm.showModal();
    }
  }

  Widget _buildSpeedDialItem({
    required IconData icon,
    required String title,
    required Color color,
    required Color bgColor,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        setState(() => _isFabOpen = false);
        handleNewCommand(index);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            widget.child,
            // FAB Menu overlay
            if (_isFabOpen) ...[
              // Background overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _isFabOpen = false),
                  child: Container(color: Colors.black.withValues(alpha: 0.3)),
                ),
              ),
              // Speed dial menu - uses PositionedDirectional for RTL support
              PositionedDirectional(
                bottom: 100,
                start: 20,
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSpeedDialItem(
                        icon: Icons.point_of_sale,
                        title: 'نقطة بيع',
                        color: const Color(0xFFF97316),
                        bgColor: const Color(0xFFFFEDD5),
                        index: 9,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.inventory_2_outlined,
                        title: 'محضر جرد',
                        color: const Color(0xFF10B981),
                        bgColor: const Color(0xFFD1FAE5),
                        index: 8,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.description_outlined,
                        title: 'عرض سعر',
                        color: const Color(0xFF2563EB),
                        bgColor: const Color(0xFFDBEAFE),
                        index: 7,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.replay_rounded,
                        title: 'مرتجع مبيعات',
                        color: const Color(0xFFDC2626),
                        bgColor: const Color(0xFFFEE2E2),
                        index: 6,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.call_made_rounded,
                        title: 'سند دفع',
                        color: const Color(0xFFEF4444),
                        bgColor: const Color(0xFFFEE2E2),
                        index: 5,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.account_balance_wallet,
                        title: 'مصاريف',
                        color: const Color(0xFFF59E0B),
                        bgColor: const Color(0xFFFEF3C7),
                        index: 4,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.card_giftcard,
                        title: 'حسم مكتسب',
                        color: const Color(0xFF8B5CF6),
                        bgColor: const Color(0xFFEDE9FE),
                        index: 3,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.percent_rounded,
                        title: 'حسم ممنوح',
                        color: const Color(0xFFDC2626),
                        bgColor: const Color(0xFFFEE2E2),
                        index: 2,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.call_received_rounded,
                        title: 'سند قبض',
                        color: const Color(0xFF10B981),
                        bgColor: const Color(0xFFD1FAE5),
                        index: 1,
                      ),
                      _buildSpeedDialItem(
                        icon: Icons.shopping_cart_outlined,
                        title: 'فاتورة مبيعات',
                        color: const Color(0xFFF97316),
                        bgColor: const Color(0xFFFFEDD5),
                        index: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        appBar: !widget.showAppBar
            ? null
            : AppBar(
                title: Text(widget.appBarTitle),
                leading: !widget.showBackButton
                    ? null
                    : BackButton(
                        onPressed: widget.backFunc,
                      ),
              ),
        floatingActionButton: widget.showBottomBar
            ? FloatingActionButton(
                onPressed: () => setState(() => _isFabOpen = !_isFabOpen),
                backgroundColor: _isFabOpen
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF97316),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _isFabOpen ? Icons.close_rounded : Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        bottomNavigationBar: !widget.showBottomBar
            ? null
            : Builder(
                builder: (context) {
                  menuButtonContext = context;
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        currentIndex: widget.activeIndex,
                        backgroundColor: Colors.white,
                        selectedItemColor: const Color(0xFFF97316),
                        unselectedItemColor: const Color(0xFF94A3B8),
                        elevation: 0,
                        onTap: (value) {
                          bottomBarButtonClick(value + 1);
                        },
                        items: const [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.receipt_long_rounded),
                              label: 'الفواتير'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.account_balance_wallet_rounded),
                              label: 'السندات'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.report), label: 'التقارير'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.settings), label: 'الإعدادات'),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
