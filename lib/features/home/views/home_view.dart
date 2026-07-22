import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/config/app_colors.dart';
import '../../preview_prompt/views/preview_prompt_screen.dart';
import '../../prompt_to_images/provider/prompt_to_image_provider.dart';
import '../widgets/prompt_card.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedCategoryIndex = 0;
  final Set<int> _likedItems = {};

  final List<String> _categories = ['TRENDING', 'BOYS', 'GIRLS', 'COUPLE'];

  final Map<String, String> _prompts = {
    'assets/images/car_man.png':
        'vibrant red button-up shirt, black cargo pants, a silver chain necklace, a watch, and pristine white sneakers, his arm resting behind his head in a relaxed pose. Perched regally on the hood of the rugged black vehicle is a stunning white Samoyed dog.',
    'assets/images/futuristic_man.png':
        'A young man wearing a clean white sweatshirt standing in a futuristic white control room with holographic panels and glowing lines, clean, high tech, sci-fi scene.',
    'assets/images/boy_sherwani.png':
        'A young South Asian boy wearing a traditional elegant white sherwani and holding an ancient book, standing in a modern brightly lit building interior, high quality, soft daylight.',
    'assets/images/subway_man.png':
        'A handsome man with a beard holding a smartphone, sitting in a modern clean subway carriage, dramatic window lighting, wearing a dark jacket, realistic photorealistic portrait.',
    'assets/images/steps_man.png':
        'A handsome man in a green tracksuit sitting on outdoor stone steps, casual, realistic portrait, detailed, daylight.',
    'assets/images/train_woman.png':
        'A stylish young woman standing next to a rustic vintage dark green train carriage, realistic, detailed, daylight.',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(promptToImageProvider.notifier).getImages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagesState = ref.watch(promptToImageProvider);
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.55),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "My Prompt",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  // Search Button
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: AppColors.searchButtonBg,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.08),
                        width: 1.0,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: AppColors.white.withValues(alpha: 0.8),
                        size: 20.0,
                      ),
                      onPressed: () {
                        // TODO: Implement search functionality
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories Selector
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    AppColors.categoryActiveGradientStart,
                                    AppColors.categoryActiveGradientEnd,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isSelected
                              ? null
                              : AppColors.categoryInactiveBg,
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: AppColors.white.withValues(
                                    alpha: 0.05,
                                  ),
                                  width: 1.0,
                                ),
                        ),
                        child: Center(
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.black
                                  : AppColors.white.withValues(alpha: 0.5),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Spacer below categories
          const SliverToBoxAdapter(child: SizedBox(height: 20.0)),

          // Prompt Cards Grid
          Consumer(
            builder: (context, ref, child) {
              if (imagesState.loading) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                    }, childCount: 6),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final imagePath = imagesState.promptToImageResponses
                        .map((e) => e.imageUrl)
                        .toList();
                    final isLiked = _likedItems.contains(index);
                    return PromptCard(
                      imagePath: imagePath[index] ?? "",
                      isLiked: isLiked,
                      onLikePressed: () {
                        setState(() {
                          if (isLiked) {
                            _likedItems.remove(index);
                          } else {
                            _likedItems.add(index);
                          }
                        });
                      },
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PreviewPromptScreen(
                              imagePath: imagePath[index] ?? "",
                              promptText: _prompts[imagePath[index]] ?? '',
                              initialIsLiked: isLiked,
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            if (result) {
                              _likedItems.add(index);
                            } else {
                              _likedItems.remove(index);
                            }
                          });
                        }
                      },
                    );
                  }, childCount: imagesState.promptToImageResponses.length),
                ),
              );
            },
          ),

          // Bottom padding so content doesn't get cut off by floating navigation bar
          const SliverToBoxAdapter(child: SizedBox(height: 100.0)),
        ],
      ),
    );
  }
}
