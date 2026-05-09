import 'package:flutter/material.dart';
import 'additem.dart';
import 'appui.dart';
import 'lib/ui/forms.dart';
import 'lib/ui/grid.dart';
import 'lib/ui/ui.dart';
import 'pagetemplate.dart';
import 'pos.dart';

class TPOSEditForm extends TForm {
  bool needRefreshSummery = false;
  late TDBGrid itemsGrid = TDBGrid(
      settingsFileName: '${rootDir}itemsgs.conf',
      [
        TGridColumn(posForm.items.name, 'المادة'),
        TGridColumn(posForm.items.unitName, 'الواحدة'),
        TGridColumn(posForm.items.qty, 'الكمية', format: ',###.###'),
        TGridColumn(posForm.items.price, 'السعر', format: ',###.##'),
        TGridColumn(posForm.items.total, 'الاجمالي', format: ',###.##'),
        TGridColumn(posForm.items.notes, 'ملاحظات'),
      ],
      popupMenuItems: ['حذف'],
      onMenuItemPressed: gridPopupClick,
      onCellTap: gridCellTap);

  TPOSEditForm() : super() {
    onClosed = () async {
      if (needRefreshSummery) {
        posForm.recalc();
        posForm.sumview.refresh();
      }
    };
  }

  gridCellTap(TCellCoordinates details) async {
    addItemForm.init(
        posForm.items.id[details.tableRowIndex],
        posForm.items.qty[details.tableRowIndex] ?? 0,
        posForm.items.price[details.tableRowIndex] ?? 0,
        posForm.items.notes[details.tableRowIndex] ?? '',
        posForm.items.unit[details.tableRowIndex] ?? 1,
        defaultPayedPrice);
    var r = await addItemForm.showModal();
    if (r == null) return;
    await posForm.items.edit(details.tableRowIndex, () {
      posForm.items.id.value = r[0];
      posForm.items.name.value = r[1];
      posForm.items.qty.value = r[2];
      posForm.items.price.value = r[3];
      posForm.items.notes.value = r[4];
      posForm.items.total.value = r[2] * r[3];
      posForm.items.unit.value = r[5];
      posForm.items.unitName.value = r[6];
    });
    needRefreshSummery = true;
    itemsGrid.refreshItems();
  }

  addItemClick() async {
    addItemForm.init(null, 1, 0, '', 1, defaultPayedPrice);
    var r = await addItemForm.showModal();
    if (r == null) return;
    await posForm.items.add(() {
      posForm.items.id.value = r[0];
      posForm.items.name.value = r[1];
      posForm.items.qty.value = r[2];
      posForm.items.price.value = r[3];
      posForm.items.notes.value = r[4];
      posForm.items.total.value = r[2] * r[3];
      posForm.items.unit.value = r[5];
      posForm.items.unitName.value = r[6];
    });
    needRefreshSummery = true;
    itemsGrid.refreshItems();
  }

  gridPopupClick(int index, String text, TCellCoordinates details) async {
    await posForm.items.delete(details.tableRowIndex);
    itemsGrid.refreshItems(refreshMode: TGridRefreshMode.grmFilter);
    needRefreshSummery = true;
  }

  @override
  Widget build(BuildContext context) {
    return TTemplatePage(
        showBottomBar: false,
        activeIndex: 0,
        showAppBar: true,
        appBarTitle: 'تعديل فاتورة نقطة بيع',
        showBackButton: true,
        backFunc: () {
          close();
        },
        child: UI(
          border: Border.all(color: Colors.black),
          paddingAll: 8,
          child: itemsGrid,
        ));
  }
}

TPOSEditForm posEditForm = TPOSEditForm();
