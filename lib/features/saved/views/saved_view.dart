import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/config/app_colors.dart';
import '../../home/widgets/prompt_card.dart';
import '../../preview_prompt/views/preview_prompt_screen.dart';
import '../../prompt_to_images/provider/prompt_to_image_provider.dart';

class SavedView extends ConsumerWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagesState = ref.watch(promptToImageProvider);
    final savedList = imagesState.promptToImageResponses
        .where((item) => item.isLiked == true)
        .toList();

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Collection',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.55),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    "Saved Prompts",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading Skeleton
          if (imagesState.loading && imagesState.promptToImageResponses.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xFF1B1D24),
                      highlightColor: const Color(0xFF2C2F3A),
                      child: Container(color: AppColors.background),
                    ),
                  );
                }, childCount: 4),
              ),
            )
          // Empty State
          else if (savedList.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.searchButtonBg,
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.redAccent,
                          size: 36.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "No Saved Prompts Yet",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Tap the heart icon on any prompt card to save it to your collection here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.5),
                          fontSize: 14.0,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          // Saved Items Grid
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = savedList[index];
                  return PromptCard(
                    imagePath: item.imageUrl ?? "",
                    isLiked: true,
                    onLikePressed: () {
                      if (item.id != null) {
                        ref
                            .read(promptToImageProvider.notifier)
                            .toggleLike(item.id!, false);
                      }
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PreviewPromptScreen(
                            imagePath: item.imageUrl ?? "",
                            promptText: item.prompt ?? '',
                            initialIsLiked: true,
                          ),
                        ),
                      );
                    },
                  );
                }, childCount: savedList.length),
              ),
            ),

          // Bottom padding for floating navigation bar
          const SliverToBoxAdapter(child: SizedBox(height: 100.0)),
        ],
      ),
    );
  }
}
