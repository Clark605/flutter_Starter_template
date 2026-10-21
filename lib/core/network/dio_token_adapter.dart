import 'package:dio/dio.dart';
import 'package:flutter_starter/core/utils/action_token.dart';

/// Extension to bridge [ActionToken] to Dio's [CancelToken].
extension DioActionTokenExtension on ActionToken {
  /// Converts this [ActionToken] into a Dio [CancelToken].
  ///
  /// If the [ActionToken] is already cancelled, the returned [CancelToken] is immediately cancelled.
  /// Otherwise, it listens to cancellation on the [ActionToken] and cancels the Dio token.
  CancelToken toDioCancelToken() {
    final dioToken = CancelToken();
    if (isCancelled) {
      dioToken.cancel(reason);
    } else {
      addListener(() {
        if (!dioToken.isCancelled) {
          dioToken.cancel(reason);
        }
      });
    }
    return dioToken;
  }
}
