import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/utils/load_status.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_state.freezed.dart';

/// Invariant: [failure] is set only when [status] == [LoadStatus.failure]; cleared on loading/success.
@freezed
abstract class ExampleState with _$ExampleState {
  const factory ExampleState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ItemModel>[]) List<ItemModel> items,
    @Default(1) int page,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    Failure? failure,
  }) = _ExampleState;
}
