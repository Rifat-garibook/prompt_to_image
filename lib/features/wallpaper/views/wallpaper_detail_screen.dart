import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/utilities/widgets/custom_snack.dart';
import '../data/models/wallpaper_model.dart';

class WallpaperDetailScreen extends StatefulWidget {
  final WallpaperModel wallpaper;

  const WallpaperDetailScreen({super.key, required this.wallpaper});

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  bool _isDownloading = false;

  Future<void> _downloadAndSaveImage() async {
    final imageUrl =
        widget.wallpaper.src?.original ??
        widget.wallpaper.src?.portrait ??
        widget.wallpaper.src?.large2x ??
        '';

    if (imageUrl.isEmpty) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      // 1. Check and request gallery permission
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          if (!mounted) return;
          Utils.customSnackBar(
            context: context,
            snackText: "Gallery permission denied. Please enable in settings.",
          );
          return;
        }
      }

      // 2. Download image bytes
      final response = await Dio().get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data != null) {
        // 3. Save to phone gallery
        await Gal.putImageBytes(Uint8List.fromList(response.data!));

        if (!mounted) return;
        Utils.customSnackBar(
          context: context,
          snackText: "Download complete! Image saved to your gallery.",
        );
      }
    } on GalException catch (e) {
      if (!mounted) return;
      Utils.customSnackBar(
        context: context,
        snackText: "Gallery error: ${e.type.message}",
      );
    } catch (e) {
      if (!mounted) return;
      Utils.customSnackBar(
        context: context,
        snackText: "Error: $e",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        widget.wallpaper.src?.portrait ??
        widget.wallpaper.src?.large2x ??
        widget.wallpaper.src?.original ??
        '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fullscreen Wallpaper Image
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return Shimmer.fromColors(
                baseColor: const Color(0xFF1B1D24),
                highlightColor: const Color(0xFF2C2F3A),
                child: Container(color: AppColors.background),
              );
            },
            errorWidget: (context, url, error) {
              return const Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  color: AppColors.white,
                  size: 48.0,
                ),
              );
            },
          ),

          // Top Back Button Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.0,
            left: 16.0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.black.withValues(alpha: 0.4),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 18.0,
                ),
              ),
            ),
          ),

          // Bottom Details & Photographer Info Overlay
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: MediaQuery.of(context).padding.bottom + 24.0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.4),
                    blurRadius: 20.0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.wallpaper.alt != null &&
                      widget.wallpaper.alt!.isNotEmpty) ...[
                    Text(
                      widget.wallpaper.alt!,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                  ],
                  Row(
                    children: [
                      const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.primary,
                        size: 16.0,
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          "Photo by ${widget.wallpaper.photographer ?? 'Pexels Creator'}",
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.75),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _isDownloading ? null : _downloadAndSaveImage,
                          icon: _isDownloading
                              ? const SizedBox(
                                  width: 18.0,
                                  height: 18.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: AppColors.black,
                                  ),
                                )
                              : const Icon(
                                  Icons.download_rounded,
                                  size: 18.0,
                                ),
                          label: Text(
                            _isDownloading ? "Downloading..." : "Download HD",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
