import 'package:freezed_annotation/freezed_annotation.dart';

part 'connectivity_state.freezed.dart';

@freezed
abstract class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState({
    @Default(true) bool isOnline,
    @Default(false) bool hasCheckedInitial,
  }) = _ConnectivityState;
}
