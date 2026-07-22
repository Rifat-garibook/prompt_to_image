class WallpaperResponseModel {
  final int? page;
  final int? perPage;
  final List<WallpaperModel>? photos;
  final int? totalResults;

  WallpaperResponseModel({
    this.page,
    this.perPage,
    this.photos,
    this.totalResults,
  });

  factory WallpaperResponseModel.fromJson(Map<String, dynamic> json) {
    return WallpaperResponseModel(
      page: json['page'],
      perPage: json['per_page'],
      photos: json['photos'] != null
          ? (json['photos'] as List)
              .map((v) => WallpaperModel.fromJson(v))
              .toList()
          : [],
      totalResults: json['total_results'],
    );
  }
}

class WallpaperModel {
  final int? id;
  final int? width;
  final int? height;
  final String? url;
  final String? photographer;
  final String? photographerUrl;
  final String? avgColor;
  final WallpaperSrcModel? src;
  final String? alt;

  WallpaperModel({
    this.id,
    this.width,
    this.height,
    this.url,
    this.photographer,
    this.photographerUrl,
    this.avgColor,
    this.src,
    this.alt,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      photographer: json['photographer'],
      photographerUrl: json['photographer_url'],
      avgColor: json['avg_color'],
      src: json['src'] != null ? WallpaperSrcModel.fromJson(json['src']) : null,
      alt: json['alt'],
    );
  }
}

class WallpaperSrcModel {
  final String? original;
  final String? large2x;
  final String? large;
  final String? medium;
  final String? small;
  final String? portrait;
  final String? landscape;
  final String? tiny;

  WallpaperSrcModel({
    this.original,
    this.large2x,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.landscape,
    this.tiny,
  });

  factory WallpaperSrcModel.fromJson(Map<String, dynamic> json) {
    return WallpaperSrcModel(
      original: json['original'],
      large2x: json['large2x'],
      large: json['large'],
      medium: json['medium'],
      small: json['small'],
      portrait: json['portrait'],
      landscape: json['landscape'],
      tiny: json['tiny'],
    );
  }
}
