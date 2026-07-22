import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/config/app_colors.dart';

class PromptCard extends StatelessWidget {
  final String imagePath;
  final bool isLiked;
  final VoidCallback onLikePressed;
  final VoidCallback? onTap;

  const PromptCard({
    super.key,
    required this.imagePath,
    required this.isLiked,
    required this.onLikePressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The background image
            CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF1B1D24),
                  highlightColor: const Color(0xFF2C2F3A),
                  child: Container(
                    color: AppColors.background,
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Icon(Icons.error_outline);
              },
            ),
            // Heart button in the top right corner
            Positioned(
              top: 12.0,
              right: 12.0,
              child: GestureDetector(
                onTap: onLikePressed,
                child: Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.black.withValues(alpha: 0.3),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.15),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.redAccent : AppColors.white,
                      size: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
