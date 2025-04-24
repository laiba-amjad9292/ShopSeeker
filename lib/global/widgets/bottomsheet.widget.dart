import 'package:flutter/material.dart';
import 'package:shop_seeker/utils/constants/app_constants.util.dart';

class ReusableBottomSheet extends StatelessWidget {
  final Widget body;

  const ReusableBottomSheet({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      right: false,
      left: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 10),
        child: Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Scrollbar(
            thumbVisibility: true,
            interactive: true,
            thickness: AppConstants.scrollbarThinkness,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  SafeArea(top: false, bottom: true, child: body),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
