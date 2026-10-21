/// Lightweight token representing cooperative cancellation for async operations.
///
/// Can be passed to `guard()` to check cancellation before, during, and between retries.
/// Can also be bridged to network-specific cancel tokens (e.g. Dio's `CancelToken`)
/// via adapter extensions in `lib/core/network/`.
class ActionToken {
  bool _isCancelled = false;
  String? _reason;
  final List<void Function()> _listeners = [];

  /// Returns true if [cancel] has been invoked.
  bool get isCancelled => _isCancelled;

  /// Optional explanation of why the action was cancelled.
  String? get reason => _reason;

  /// Cancels the in-flight action and notifies listeners.
  void cancel([String? reason]) {
    if (_isCancelled) return;
    _isCancelled = true;
    _reason = reason;

    for (final listener in List<void Function()>.from(_listeners)) {
      listener();
    }
  }

  /// Adds a callback invoked when this token is cancelled.
  void addListener(void Function() listener) {
    if (_isCancelled) {
      listener();
      return;
    }
    _listeners.add(listener);
  }

  /// Removes a previously registered cancellation listener.
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }
}
