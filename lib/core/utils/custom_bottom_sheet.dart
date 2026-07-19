import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class CustomBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.navBarBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.05),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12.0),
              // Drag Handle
              Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              if (title != null) ...[
                const SizedBox(height: 16.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: child,
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      },
    );
  }
}
