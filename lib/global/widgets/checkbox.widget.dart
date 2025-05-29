import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';

class CheckBoxNew extends StatefulWidget {
  const CheckBoxNew({
    super.key,
    required this.value,
    this.hasError = false,
    required this.onChanged,
    this.isDisabled = false,
  });

  final bool value;
  final bool hasError;

  final bool isDisabled;
  final ValueChanged<bool?> onChanged;

  @override
  State<CheckBoxNew> createState() => _CheckBoxNewState();
}

class _CheckBoxNewState extends State<CheckBoxNew> {
  Color getColor(Color color, {isBorderColor = false}) {
    return widget.isDisabled ? AppColors.white : color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: widget.value == true ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(2.r),
          border: Border.all(
            color:
                widget.hasError
                    ? AppColors.colorF97970
                    : widget.value == true
                    ? getColor(AppColors.primary)
                    : getColor(AppColors.color98A2B3),
            width: 1,
          ),
        ),
        child:
            widget.value == true
                ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(Icons.check, color: Colors.white, size: 18.r),
                )
                : null,
      ),
    );
  }
}
