import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_colors.dart';
import '../../home/views/home_view.dart';
import '../../prompt_to_images/provider/prompt_to_image_provider.dart';

class NavScreen extends ConsumerStatefulWidget {
  const NavScreen({super.key});

  @override
  ConsumerState<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends ConsumerState<NavScreen> {
  int _currentIndex = 0;


  // @override
  // void initState() {
  //   super.initState();
  //  WidgetsBinding.instance.addPostFrameCallback((_) {
  //    ref.read(promptToImageProvider.notifier).getImages(context);
  //  });
  // }

  final List<Widget> _views = [
    const HomeView(),
    const Center(
      child: Text(
        'Generate Prompt',
        style: TextStyle(color: AppColors.white, fontSize: 18.0),
      ),
    ),
    const Center(
      child: Text(
        'Saved Prompts',
        style: TextStyle(color: AppColors.white, fontSize: 18.0),
      ),
    ),
    const Center(
      child: Text(
        'Settings',
        style: TextStyle(color: AppColors.white, fontSize: 18.0),
      ),
    ),
  ];

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.0 : 12.0,
          vertical: 10.0,
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.navItemActiveBg,
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: AppColors.navItemActiveBorder.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.navItemActiveIcon : AppColors.white.withValues(alpha: 0.4),
              size: 22.0,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8.0),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, // Content scrolls under the floating nav bar
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 16.0),
          child: Container(
            height: 72.0,
            decoration: BoxDecoration(
              color: AppColors.navBarBg,
              borderRadius: BorderRadius.circular(36.0),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.06),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.45),
                  blurRadius: 20.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.auto_awesome_rounded, 'Create'),
                _buildNavItem(2, Icons.collections_bookmark_rounded, 'Saved'),
                _buildNavItem(3, Icons.settings_rounded, 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
