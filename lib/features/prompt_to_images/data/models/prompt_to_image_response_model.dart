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
    final DateTime? createdAt;

    PromptToImageResponseModel({
        this.id,
        this.title,
        this.imageUrl,
        this.prompt,
        this.category,
        this.createdAt,
    });

    factory PromptToImageResponseModel.fromJson(Map<String, dynamic> json) => PromptToImageResponseModel(
        id: json["id"],
        title: json["title"],
        imageUrl: json["image_url"],
        prompt: json["prompt"],
        category: json["category"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_url": imageUrl,
        "prompt": prompt,
        "category": category,
        "created_at": createdAt?.toIso8601String(),
    };
}
