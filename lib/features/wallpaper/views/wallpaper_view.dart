import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/config/app_colors.dart';
import '../provider/wallpaper_provider.dart';
import 'wallpaper_detail_screen.dart';

class WallpaperView extends ConsumerStatefulWidget {
  const WallpaperView({super.key});

  @override
  ConsumerState<WallpaperView> createState() => _WallpaperViewState();
}

class _WallpaperViewState extends ConsumerState<WallpaperView> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Curated',
    'Nature',
    'Dark',
    'Cyberpunk',
    'Minimal',
    'Anime',
    'Cars',
    'Abstract',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentList = ref.read(wallpaperProvider).wallpapers;
      if (currentList.isEmpty) {
        ref
            .read(wallpaperProvider.notifier)
            .fetchWallpapers(category: 'Curated');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      ref
          .read(wallpaperProvider.notifier)
          .fetchWallpapers(category: query.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wallpaperProvider);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pexels Collection',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.55),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    "HD Wallpapers",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Search Bar
                  Container(
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: AppColors.searchButtonBg,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: AppColors.white.withValues(alpha: 0.5),
                          size: 20.0,
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: _onSearchSubmitted,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 14.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search wallpapers (e.g. Neon, Nature)',
                              hintStyle: TextStyle(
                                color: AppColors.white.withValues(alpha: 0.35),
                                fontSize: 13.0,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              ref
                                  .read(wallpaperProvider.notifier)
                                  .fetchWallpapers(category: 'Curated');
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.white.withValues(alpha: 0.5),
                              size: 18.0,
                            ),
                          ),
                      ],
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
                  final cat = _categories[index];
                  final isSelected =
                      state.selectedCategory.toLowerCase() == cat.toLowerCase();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        ref
                            .read(wallpaperProvider.notifier)
                            .fetchWallpapers(category: cat);
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
                                ),
                        ),
                        child: Center(
                          child: Text(
                            cat,
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

          const SliverToBoxAdapter(child: SizedBox(height: 20.0)),

          // Shimmer Loading Skeleton
          if (state.loading && state.wallpapers.isEmpty)
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
                }, childCount: 6),
              ),
            )
          // Error State
          else if (state.error != null && state.wallpapers.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.redAccent,
                        size: 40.0,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Failed to load wallpapers',
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.7),
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(wallpaperProvider.notifier)
                              .fetchWallpapers(
                                category: state.selectedCategory,
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.black,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          // Empty State
          else if (state.wallpapers.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    'No wallpapers found for "${state.selectedCategory}"',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.6),
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            )
          // Wallpapers Grid
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
                  final wallpaper = state.wallpapers[index];
                  final imageUrl =
                      wallpaper.src?.portrait ??
                      wallpaper.src?.medium ??
                      wallpaper.src?.original ??
                      '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              WallpaperDetailScreen(wallpaper: wallpaper),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
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
                              return const Icon(
                                Icons.image_not_supported_rounded,
                                color: Colors.grey,
                              );
                            },
                          ),
                          // Bottom photographer gradient overlay
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.black.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Text(
                                wallpaper.photographer ?? '',
                                style: TextStyle(
                                  color: AppColors.white.withValues(
                                    alpha: 0.85,
                                  ),
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: state.wallpapers.length),
              ),
            ),

          // Bottom Navigation Bar spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100.0)),
        ],
      ),
    );
  }
}
