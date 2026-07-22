import '../data/models/prompt_to_image_response_model.dart';

class PromptToImageState {

  final bool loading;

  final String? error;

  final List<PromptToImageResponseModel> promptToImageResponses;

  const PromptToImageState({

    this.loading = false,

    this.error,

    this.promptToImageResponses = const [],

  });

  PromptToImageState copyWith({

    bool? loading,

    String? error,

    List<PromptToImageResponseModel>? promptToImageResponses,

  }) {

    return PromptToImageState(

      loading: loading ?? this.loading,

      error: error,

      promptToImageResponses: promptToImageResponses ?? this.promptToImageResponses,

    );

  }

}