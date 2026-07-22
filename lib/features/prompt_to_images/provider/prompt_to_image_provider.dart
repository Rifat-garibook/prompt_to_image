import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/legacy.dart';

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

  Future<void> getImages(BuildContext context) async {
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
}
