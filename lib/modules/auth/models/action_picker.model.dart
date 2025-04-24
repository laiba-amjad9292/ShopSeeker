import 'package:get/get.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';

abstract class DropDownBottomSheetClass {
  String? name;
  SheetIconType? iconType;
  String? iconURL;
}

class ActionPickerModel extends DropDownBottomSheetClass {
  String? label;
  String? icon;
  SheetIconType? sheetIconType;

  ActionPickerModel({
    this.label,
    this.icon,
    this.sheetIconType = SheetIconType.asset,
  });
  @override
  String? get iconURL => icon;

  @override
  String? get name => label?.tr;

  @override
  SheetIconType? get iconType => sheetIconType;
}
