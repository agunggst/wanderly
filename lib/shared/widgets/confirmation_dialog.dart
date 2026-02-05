import 'package:flutter/material.dart';
import 'package:wanderly/core/theme/app_colors.dart';
import 'package:wanderly/core/theme/app_text.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  String title = "Confirm",
  String message = "Are you sure?",
  String confirmText = "Delete",
  String cancelText = "Cancel",
  Color? confirmColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText, style: AppTextStyles.bodyBold(context),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? AppColors.of(context).error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText, style: AppTextStyles.textButton(context),),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
