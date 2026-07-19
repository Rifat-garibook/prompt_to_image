import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    // Hide current snackbar if any is showing
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 20.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.navBarBg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: AppColors.white.withValues(alpha: 0.08),
            width: 1.0,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
