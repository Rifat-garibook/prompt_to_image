import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:riverpod/legacy.dart';

import '../data/models/wallpaper_model.dart';
import 'wallpaper_state.dart';

final wallpaperProvider =
    StateNotifierProvider<WallpaperNotifier, WallpaperState>(
      (ref) => WallpaperNotifier(),
    );

class WallpaperNotifier extends StateNotifier<WallpaperState> {
  WallpaperNotifier() : super(const WallpaperState());

  static const String _apiKey =
      'c1iU1wRTETh4OnlUBHPx5V4DvU7ZU6sXYVFySaamIXiAwDuhWZfgiki3';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.pexels.com/v1/',
      headers: {'Authorization': _apiKey},
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<void> fetchWallpapers({String category = 'Curated'}) async {
    state = state.copyWith(
      loading: true,
      error: null,
      selectedCategory: category,
    );

    try {
      final String url =
          category == 'Curated'
              ? 'curated?per_page=40&page=1'
              : 'search?query=${Uri.encodeComponent(category)}&per_page=40&page=1';

      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final data = WallpaperResponseModel.fromJson(response.data);
        state = state.copyWith(loading: false, wallpapers: data.photos ?? []);
      } else {
        state = state.copyWith(
          loading: false,
          error: 'Failed to load wallpapers',
        );
      }
    } catch (e) {
      log('Pexels API Error: $e');
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
