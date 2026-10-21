import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_state.freezed.dart';

@freezed
abstract class ExampleState with _$ExampleState {
  const factory ExampleState.initial() = ExampleStateInitial;
  const factory ExampleState.loading() = ExampleStateLoading;
  const factory ExampleState.loaded({
    required List<ItemDto> items,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(1) int page,
  }) = ExampleStateLoaded;
  const factory ExampleState.error(Failure failure) = ExampleStateError;
}
