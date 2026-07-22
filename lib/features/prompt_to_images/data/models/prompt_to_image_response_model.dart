// To parse this JSON data, do
//
//     final promptToImageResponseModel = promptToImageResponseModelFromJson(jsonString);

import 'dart:convert';

List<PromptToImageResponseModel> promptToImageResponseModelFromJson(String str) => List<PromptToImageResponseModel>.from(json.decode(str).map((x) => PromptToImageResponseModel.fromJson(x)));

String promptToImageResponseModelToJson(List<PromptToImageResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PromptToImageResponseModel {
    final int? id;
    final String? title;
    final String? imageUrl;
    final String? prompt;
    final String? category;
    final bool? isLiked;
    final DateTime? createdAt;

    PromptToImageResponseModel({
        this.id,
        this.title,
        this.imageUrl,
        this.prompt,
        this.category,
        this.isLiked,
        this.createdAt,
    });

    factory PromptToImageResponseModel.fromJson(Map<String, dynamic> json) => PromptToImageResponseModel(
        id: json["id"],
        title: json["title"],
        imageUrl: json["image_url"],
        prompt: json["prompt"],
        category: json["category"],
        isLiked: json["is_liked"] ?? false,
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_url": imageUrl,
        "prompt": prompt,
        "category": category,
        "is_liked": isLiked,
        "created_at": createdAt?.toIso8601String(),
    };

    PromptToImageResponseModel copyWith({
      int? id,
      String? title,
      String? imageUrl,
      String? prompt,
      String? category,
      bool? isLiked,
      DateTime? createdAt,
    }) {
      return PromptToImageResponseModel(
        id: id ?? this.id,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        prompt: prompt ?? this.prompt,
        category: category ?? this.category,
        isLiked: isLiked ?? this.isLiked,
        createdAt: createdAt ?? this.createdAt,
      );
    }
}
