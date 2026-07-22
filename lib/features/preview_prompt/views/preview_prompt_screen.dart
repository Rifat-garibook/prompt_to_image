import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/config/app_colors.dart';
import '../../../core/utils/custom_snackbar.dart';

class PreviewPromptScreen extends StatefulWidget {
  final String imagePath;
  final String promptText;
  final bool initialIsLiked;

  const PreviewPromptScreen({
    super.key,
    required this.imagePath,
    required this.promptText,
    required this.initialIsLiked,
  });

  @override
  State<PreviewPromptScreen> createState() => _PreviewPromptScreenState();
}

class _PreviewPromptScreenState extends State<PreviewPromptScreen> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialIsLiked;
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.promptText));
    CustomSnackBar.show(
      context,
      message: 'Prompt copied to clipboard!',
      icon: Icons.check_circle,
      iconColor: Colors.greenAccent,
    );
  }

  Widget _buildGlassmorphicButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.black.withValues(alpha: 0.4),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.15),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(icon, color: iconColor ?? AppColors.white, size: 20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        title: const Text(
          'Preview Prompt',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Container(
                height: 400.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.35),
                      blurRadius: 15.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      CachedNetworkImage(
                        imageUrl: widget.imagePath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: const Color(0xFF1B1D24),
                            highlightColor: const Color(0xFF2C2F3A),
                            child: Container(color: AppColors.background),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Icon(Icons.error_outline);
                        },
                      ),
                      // Back Button Overlay
                      Positioned(
                        top: 16.0,
                        left: 16.0,
                        child: _buildGlassmorphicButton(
                          icon: Icons.arrow_back,
                          onTap: () {
                            Navigator.of(context).pop(_isLiked);
                          },
                        ),
                      ),
                      // Like Button Overlay
                      Positioned(
                        top: 16.0,
                        right: 16.0,
                        child: _buildGlassmorphicButton(
                          icon: _isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          iconColor: _isLiked
                              ? Colors.redAccent
                              : AppColors.white,
                          onTap: () {
                            setState(() {
                              _isLiked = !_isLiked;
                            });
                          },
                        ),
                      ),
                      // Download Button Overlay
                      Positioned(
                        bottom: 16.0,
                        right: 16.0,
                        child: _buildGlassmorphicButton(
                          icon: Icons.download_rounded,
                          onTap: () {
                            CustomSnackBar.show(
                              context,
                              message: 'Downloading image...',
                              icon: Icons.download_rounded,
                              iconColor: Colors.greenAccent,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Prompt Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: AppColors.navBarBg,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.05),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  widget.promptText,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: 14.0,
                    height: 1.55,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Copy Prompt Button
                  GestureDetector(
                    onTap: _copyToClipboard,
                    child: Container(
                      height: 52.0,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.copyButtonGradientStart,
                            AppColors.copyButtonGradientEnd,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(26.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.copyButtonGradientStart.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.copy_rounded,
                            color: AppColors.white,
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Copy Prompt',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14.0),

                  // Open Gemini App Button
                  GestureDetector(
                    onTap: () {
                      CustomSnackBar.show(
                        context,
                        message: 'Opening Gemini App...',
                        icon: Icons.auto_awesome_rounded,
                        iconColor: AppColors.primary,
                      );
                    },
                    child: Container(
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: AppColors.geminiButtonBg,
                        borderRadius: BorderRadius.circular(26.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.geminiButtonBg.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.white,
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Open Gemini App',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            // How to Use / Follow Me Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  // How to Use
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: AppColors.searchButtonBg,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.05),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.red.withValues(alpha: 0.8),
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              'How to use',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12.0),

                  // Follow Me
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: AppColors.searchButtonBg,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.05),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_add_rounded,
                              color: Colors.purple.withValues(alpha: 0.8),
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              'Follow me',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
