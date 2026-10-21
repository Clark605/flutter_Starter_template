import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/cubit/action_guard.dart';

/// Thin base Cubit that includes [ActionGuard] and closed-state emit protection.
abstract class BaseCubit<S> extends Cubit<S> with ActionGuard<S> {
  BaseCubit(super.initialState);

  @override
  void emit(S state) {
    if (isClosed) return;
    super.emit(state);
  }
}
