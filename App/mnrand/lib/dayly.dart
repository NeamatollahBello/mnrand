import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'printpayin.dart';
import 'printpayin8cm.dart';
import 'addbill.dart';
import 'addop.dart';
import 'api.dart';
import 'apptheme.dart';
import 'errors.dart';
import 'lib/db/db.dart';
import 'lib/ui/combo.dart';
import 'lib/ui/date_edit.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/list_view.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';
import 'printbill.dart';
import 'printbill8cm.dart';
import 'printbilla4.dart';

const _billOps = ['مبيعات', 'م. مبيعات', 'عرض سعر', 'محضر جرد'];

class TDaylyTable extends TTable {
  late var id = strField(null, 'ID');
  late var date = dateTimeField(id, 'Date');
  late var operation = strField(date, 'Operation');
  late var mnrOperation = strField(operation, 'Num');
  late var clientID = strField(mnrOperation, 'ClientID');
  late var clientCode = strField(clientID, 'ClientNum');
  late var clientName = strField(clientCode, 'ClientName');
  late var notes = strField(clientName, 'Notes');
  late var materials = strField(notes, 'Materials');
  TDaylyTable() {
    materials;
  }
}

IconData _opIcon(String? op) {
  switch (op) {
    case 'مبيعات':
      return Icons.receipt_long_rounded;
    case 'م. مبيعات':
      return Icons.replay_rounded;
    case 'عرض سعر':
      return Icons.edit_document;
    case 'محضر جرد':
      return Icons.inventory_2_outlined;
    case 'قبض':
      return Icons.call_received_rounded;
    case 'دفع':
      return Icons.call_made_rounded;
    case 'مصروف':
      return Icons.account_balance_wallet;
    case 'حسم ممنوح':
      return Icons.percent_rounded;
    case 'حسم مكتسب':
      return Icons.card_giftcard;
    default:
      return Icons.swap_horiz_rounded;
  }
}

Color _opColor(String? op) {
  switch (op) {
    case 'مبيعات':
      return primaryColor;
    case 'م. مبيعات':
      return const Color(0xFFDC2626);
    case 'عرض سعر':
      return const Color(0xFF2563EB);
    case 'محضر جرد':
      return const Color(0xFF10B981);
    case 'قبض':
      return const Color(0xFF10B981);
    case 'دفع':
      return primaryColor;
    case 'مصروف':
      return const Color(0xFFF59E0B);
    case 'حسم ممنوح':
      return const Color(0xFFDC2626);
    case 'حسم مكتسب':
      return const Color(0xFF8B5CF6);
    default:
      return unselectedColor;
  }
}

Color _opBgColor(String? op) {
  switch (op) {
    case 'مبيعات':
      return const Color(0xFFFFEDD5);
    case 'م. مبيعات':
      return const Color(0xFFFEE2E2);
    case 'عرض سعر':
      return const Color(0xFFDBEAFE);
    case 'محضر جرد':
      return const Color(0xFFD1FAE5);
    case 'قبض':
      return const Color(0xFFD1FAE5);
    case 'دفع':
      return const Color(0xFFFFEDD5);
    case 'مصروف':
      return const Color(0xFFFEF3C7);
    case 'حسم ممنوح':
      return const Color(0xFFFEE2E2);
    case 'حسم مكتسب':
      return const Color(0xFFEDE9FE);
    default:
      return const Color(0xFFF1F5F9);
  }
}

final _dateFormat = DateFormat('yyyy/MM/dd  hh:mm', 'ar_SY');

class TDaylyForm extends TForm {
  final String title;
  final int navActiveIndex;
  final List<String> chipFilters;
  final List<String> includeOps;
  final List<String> excludeOps;

  TDaylyForm({
    required this.title,
    required this.navActiveIndex,
    this.chipFilters = const [],
    this.includeOps = const [],
    this.excludeOps = const [],
  });

  late TDaylyTable dayly = TDaylyTable()..clear();

  String searchText = '';
  int selectedChip = -1;

  late TTextEdit searchEdt = TTextEdit(
    label: 'البحث',
    contentPadding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 8),
    onChange: (text) {
      searchText = text;
      listView.refreshItems();
    },
  );

  late TCombobox dfType = TCombobox(
    items: [
      [0, 'اليوم'],
      [1, 'اسبوع'],
      [2, 'شهر'],
      [3, 'سنة'],
      [4, 'منذ'],
      [5, 'بين'],
      [6, 'الكل'],
    ],
    value: 0,
    contentPadding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 8),
    onChange: (itemIndex, value) {
      notify();
    },
  );

  TDateEdit dtFrom = TDateEdit(
      value: DateTime.now(),
      label: 'من',
      contentPadding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 8));
  TDateEdit dtTo = TDateEdit(
      value: DateTime.now(),
      label: 'إلى',
      contentPadding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 8));

  late TListView listView = TListView(
    table: dayly,
    onFilter: recFilter,
    onDrawItem: _buildItem,
  );

  Widget _buildItem(BuildContext context, int visibleIndex, int orgIndex) {
    final op = dayly.operation[orgIndex];
    final client = dayly.clientName[orgIndex] ?? '';
    final num = dayly.mnrOperation[orgIndex] ?? '';
    final dateVal = dayly.date[orgIndex];
    final dateStr = dateVal != null ? _dateFormat.format(dateVal) : '';
    final iconColor = _opColor(op);
    final bgColor = _opBgColor(op);
    final icon = _opIcon(op);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: GestureDetector(
        onTap: () => _onItemTap(orgIndex),
        onLongPress: () => _onItemLongPress(context, orgIndex, visibleIndex),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 4, color: iconColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: iconColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: client.isNotEmpty
                                        ? Text(
                                            client,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : const SizedBox(),
                                  ),
                                  if (num.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '#$num',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: iconColor,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      op ?? '',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                dateStr,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_left_rounded,
                          color: Color(0xFFCBD5E1),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onItemTap(int orgIndex) async {
    var res = await api('opdet', {'ID': dayly.id[orgIndex]});
    if (showApiError(res)) return;
    res = res['data'];
    if (res['btype'] == 1 ||
        res['btype'] == 2 ||
        res['btype'] == 3 ||
        res['btype'] == 4) {
      await addBillForm.prepareEdit(res);
      addBillForm.showModal();
    } else if (res['optype'] != null) {
      await addOpForm.prepareEdit(res);
      addOpForm.showModal();
    }
  }

  _onItemLongPress(BuildContext context, int orgIndex, int visibleIndex) async {
    final op = dayly.operation[orgIndex];
    bool isbill = op == 'مبيعات' ||
        op == 'م. مبيعات' ||
        op == 'عرض سعر' ||
        op == 'محضر جرد' ||
        op == 'قبض';
    if (!isbill) return;

    List<String> menuItems = Platform.isAndroid
        ? ['نسخة للطباعة', 'مشاركة نسخة مطبوعة', 'طباعة']
        : (Platform.isWindows ? ['معاينة قبل الطباعة', 'طباعة'] : []);
    if (menuItems.isEmpty) return;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final result = await showMenu<int>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(overlay.size.width / 2, overlay.size.height / 2, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: menuItems
          .asMap()
          .entries
          .map((e) => PopupMenuItem<int>(value: e.key, child: Text(e.value)))
          .toList(),
    );
    if (result == null) return;
    await _handleMenuAction(result, orgIndex, op);
  }

  _handleMenuAction(int index, int orgIndex, String? op) async {
    var res = await api('opdet', {'ID': dayly.id[orgIndex]});
    if (showApiError(res)) return;
    res = res['data'];
    if (op == 'قبض') {
      if (index == 0) {
        await doPrintPayCommand8cm(res, false);
      } else if (index == 1) {
        if (Platform.isAndroid) {
          await doSharePayCommand(res);
        } else if (Platform.isWindows) {
          await doPrintPayCommand8cm(res, true);
        }
      }
    } else {
      if (index == 0) {
        await doPrintCommandA4(res, false);
      } else if (index == 1) {
        if (Platform.isAndroid) {
          await doShareCommand(res);
        } else if (Platform.isWindows) {
          await doPrintCommandA4(res, true);
        }
      } else if (index == 2) {
        if (Platform.isAndroid) {
          await doPrintCommand8cm(res, false);
        }
      }
    }
  }

  Widget _buildChipBar(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: chipFilters.length + 1,
        itemBuilder: (ctx, i) {
          final isAll = i == 0;
          final label = isAll ? 'الكل' : chipFilters[i - 1];
          final chipIndex = i - 1;
          final isSelected = selectedChip == chipIndex;
          return GestureDetector(
            onTap: () {
              selectedChip = chipIndex;
              listView.refreshItems();
              notify();
            },
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
      activeIndex: navActiveIndex,
      appBarTitle: title,
      showAppBar: true,
      showBackButton: false,
      showBottomBar: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    UI(
                      child: dfType,
                      maxHeight: 34,
                      maxWidth: 96,
                      paddingHorz: 8,
                    ),
                    if (dfType.value == 4 || dfType.value == 5)
                      UI(
                        child: dtFrom,
                        maxWidth: 160,
                        maxHeight: 34,
                        paddingHorz: 8,
                      ),
                    if (dfType.value == 5)
                      UI(paddingHorz: 8, child: const Text('و')),
                    if (dfType.value == 5)
                      UI(
                        child: dtTo,
                        maxWidth: 160,
                        maxHeight: 34,
                        paddingHorz: 8,
                      ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 8),
                      child: ElevatedButton(
                          onPressed: searchClick, child: const Text('  بحث  ')),
                    )
                  ],
                ),
              ),
            ),
          ),
          UI(
            child: searchEdt,
            maxHeight: 50,
            paddingAll: 8,
          ),
          if (chipFilters.isNotEmpty) _buildChipBar(context),
          Expanded(
            child: UI(child: listView),
          ),
        ],
      ),
    );
  }

  bool recFilter(int index) {
    final op = dayly.operation[index] ?? '';
    if (includeOps.isNotEmpty && !includeOps.contains(op)) return false;
    if (excludeOps.isNotEmpty && excludeOps.contains(op)) return false;
    if (selectedChip >= 0 && op != chipFilters[selectedChip]) return false;
    if (searchText.isEmpty) return true;
    return (dayly.clientName[index] ?? '').contains(searchText) ||
        (dayly.clientCode[index] ?? '').contains(searchText) ||
        (dayly.operation[index] ?? '').contains(searchText) ||
        (dayly.mnrOperation[index] ?? '').contains(searchText) ||
        (dayly.notes[index] ?? '').contains(searchText) ||
        (dayly.materials[index] ?? '').contains(searchText);
  }

  doPrintCommandA4(bill, bool directPrint) async {
    printBill(BillPrintA4(), bill, directPrint, () async {});
  }

  doPrintCommand8cm(bill, bool directPrint) async {
    printBill(BillPrint8Cm(), bill, directPrint, () async {});
  }

  doShareCommand(bill) async {
    if (Platform.isWindows) return;
    shareBill(BillPrintA4(), bill);
  }

  doPrintPayCommand8cm(bill, bool directPrint) async {
    printPayIn(PayInPrint8Cm(), bill, directPrint, () async {});
  }

  doSharePayCommand(bill) async {
    if (Platform.isWindows) return;
    sharePayIn(PayInPrint8Cm(), bill);
  }

  load() async {
    DateTime? d1 = DateTime.now();
    DateTime? d2;
    if (dfType.value == 5) {
      d2 = dtTo.value;
      if (d2 != null) {
        d2 = DateTime(d2.year, d2.month, d2.day + 1);
      }
    } else if (dfType.value != 6) {
      d2 = DateTime(d1.year, d1.month, d1.day + 1);
    }
    if (dfType.value == 0) {
      d1 = DateTime(d1.year, d1.month, d1.day);
    } else if (dfType.value == 1) {
      d1 = DateTime(d1.year, d1.month, d1.day - 7);
    } else if (dfType.value == 2) {
      d1 = DateTime(d1.year, d1.month - 1, d1.day);
    } else if (dfType.value == 3) {
      d1 = DateTime(d1.year - 1, d1.month, d1.day);
    } else if (dfType.value == 4 || dfType.value == 5) {
      d1 = dtFrom.value;
      if (d1 != null) {
        d1 = DateTime(d1.year, d1.month, d1.day);
      }
    } else if (dfType.value == 6) {
      d1 = null;
    }
    var res = await api('oplog', {
      'd1': d1 == null ? '' : defaultJsonDateTimeFormat.format(d1),
      'd2': d2 == null ? '' : defaultJsonDateTimeFormat.format(d2)
    });
    if (showApiError(res)) return;
    await dayly.load(res['data']);
    listView.refreshItems();
  }

  Future<void> searchClick() async {
    await load();
  }
}

TDaylyForm invoicesForm = TDaylyForm(
  title: 'الفواتير',
  navActiveIndex: 0,
  includeOps: _billOps,
  chipFilters: _billOps,
);

TDaylyForm operationsForm = TDaylyForm(
  title: 'السندات',
  navActiveIndex: 1,
  excludeOps: _billOps,
  chipFilters: ['قبض', 'دفع', 'مصروف', 'حسم ممنوح', 'حسم مكتسب'],
);

TDaylyForm daylyForm = invoicesForm;
