import '../data/models/wallpaper_model.dart';

class WallpaperState {
  final bool loading;
  final List<WallpaperModel> wallpapers;
  final String? error;
  final String selectedCategory;

  const WallpaperState({
    this.loading = false,
    this.wallpapers = const [],
    this.error,
    this.selectedCategory = 'Curated',
  });

  WallpaperState copyWith({
    bool? loading,
    List<WallpaperModel>? wallpapers,
    String? error,
    String? selectedCategory,
  }) {
    return WallpaperState(
      loading: loading ?? this.loading,
      wallpapers: wallpapers ?? this.wallpapers,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
