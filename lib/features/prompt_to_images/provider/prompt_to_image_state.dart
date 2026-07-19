import '../data/models/prompt_to_image_response_model.dart';

class PromptToImageState {

  final bool loading;

  final String? error;

  final List<PromptToImageResponseModel> images;

  const PromptToImageState({

    this.loading = false,

    this.error,

    this.images = const [],

  });

  PromptToImageState copyWith({

    bool? loading,

    String? error,

    List<PromptToImageResponseModel>? images,

  }) {

    return PromptToImageState(

      loading: loading ?? this.loading,

      error: error,

      images: images ?? this.images,

    );

  }

}