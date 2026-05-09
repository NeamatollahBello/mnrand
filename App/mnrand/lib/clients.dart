import 'package:flutter/material.dart';
import 'appui.dart';
import 'lib/db/db.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/grid.dart';
import 'lib/ui/text_edit.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';

class TAccountsTable extends TTable {
  late final id = strField(null, 'id');
  late final name = strField(id, 'name');
  late final number = intField(name, 'number');
  late final code = strField(number, 'code');
  late final phone = strField(code, 'phone');
  late final taxNum = strField(phone, 'TaxNum');
  late final priceKind = intField(taxNum, 'CustPrice');
  late final address = strField(priceKind, 'Address');
  TAccountsTable() {
    address;
  }
}

class TAccountsForm extends TForm {
  TAccountsForm() : super() {
    onShow = () async {
      grid.refreshItems();
    };
  }
  TAccountsTable clients = TAccountsTable();
  TAccountsTable accounts = TAccountsTable();

  int _listCompare(int index1, int index2) {
    return (clients.name[index1] ?? '').compareTo(clients.name[index2] ?? "");
  }

  bool _listFilter(int index) {
    return (clients.name[index] ?? '').contains(searchText) ||
        (clients.phone[index] ?? '').contains(searchText) ||
        (clients.code[index] ?? '').contains(searchText) ||
        (clients.taxNum[index] ?? '').contains(searchText) ||
        (clients.address[index] ?? '').contains(searchText);
  }

  late TDBGrid grid = TDBGrid(
    settingsFileName: '${rootDir}accgs.conf',
    [
      TGridColumn(clients.name, 'اسم الزبون', sortable: true),
      TGridColumn(clients.code, 'الكود', sortable: true),
      TGridColumn(clients.taxNum, 'الرقم الضريبي', sortable: true),
      TGridColumn(clients.phone, 'الهاتف', sortable: true),
      TGridColumn(clients.address, 'العنوان', sortable: true),
    ],
    onFilter: _listFilter,
    onCompare: _listCompare,
  );
  String searchText = '';
  late TTextEdit searchEdit = TTextEdit(
    label: "البحث",
    onChange: (text) {
      searchText = text;
      grid.refreshItems(refreshMode: TGridRefreshMode.grmFilter);
    },
    contentPadding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 8),
  );
  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
        showBottomBar: false,
        activeIndex: 0,
        showAppBar: true,
        appBarTitle: 'الزبائن',
        showBackButton: true,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: UI(
                  child: searchEdit,
                  constraints: const BoxConstraints(maxHeight: 40),
                  padding: const EdgeInsets.all(4),
                )),
              ],
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: UI(child: grid),
            )),
          ],
        ));
  }
}

TAccountsForm accountsForm = TAccountsForm();
