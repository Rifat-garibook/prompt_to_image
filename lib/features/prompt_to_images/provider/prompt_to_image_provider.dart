import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/legacy.dart';

import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/dio/dio_client.dart';
import '../../../core/network/exceptions/api_exceptions.dart';
import '../../../core/utilities/widgets/custom_snack.dart';
import '../data/models/prompt_to_image_response_model.dart';
import 'prompt_to_image_state.dart';

final promptToImageProvider =
    StateNotifierProvider<PromptToImageNotifier, PromptToImageState>(
      (ref) => PromptToImageNotifier(),
    );

class PromptToImageNotifier extends StateNotifier<PromptToImageState> {
  PromptToImageNotifier() : super(const PromptToImageState());

  final Dio _dio = DioClient.dio;

  Future<void> getImages(BuildContext context, {bool force = false}) async {
    if (state.promptToImageResponses.isNotEmpty && !force) {
      return;
    }
    state = state.copyWith(loading: true, error: null);

    try {
      final response = await _dio.get("/rest/v1/ai_images");
      log("response code ${response.statusCode}");
      List<PromptToImageResponseModel> images = [];
      if (response.statusCode == 200) {
        if (!context.mounted) return;

        images = (response.data as List)
            .map((e) => PromptToImageResponseModel.fromJson(e))
            .toList();
        state = state.copyWith(promptToImageResponses: images);
      } else {
        if (!context.mounted) return;
        Utils.customSnackBar(
          context: context,
          snackText: "Something went wrong",
        );
      }
    } on DioException catch (e) {
      if (!context.mounted) return;
      Utils.customSnackBar(
        context: context,
        snackText: ApiExceptions.getMessage(e),
      );
    } catch (e) {
      if (!context.mounted) return;
      Utils.customSnackBar(context: context, snackText: e.toString());
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> toggleLike(int id, bool isLiked) async {
    // 1. Optimistic UI update
    log("toggleLike for id=$id, isLiked=$isLiked");
    final updatedList = state.promptToImageResponses.map((item) {
      if (item.id == id) {
        return item.copyWith(isLiked: isLiked);
      }
      return item;
    }).toList();

    state = state.copyWith(promptToImageResponses: updatedList);

    // 2. Update Supabase backend database table
    try {
      log("is click 2 ---");
      final response = await _dio.patch(
        "/rest/v1/ai_images?id=eq.$id",
        data: {"is_liked": isLiked},
        options: Options(headers: {"Prefer": "return=representation"}),
      );
      log("response code toggleLike=== ${response.statusCode}");
      log("response data toggleLike=== ${response.data}");
    } catch (e) {
      log("Error updating like status in Supabase: $e");
      // Revert optimistic update if request fails
      final revertedList = state.promptToImageResponses.map((item) {
        if (item.id == id) {
          return item.copyWith(isLiked: !isLiked);
        }
        return item;
      }).toList();
      state = state.copyWith(promptToImageResponses: revertedList);
    }
  }
}
