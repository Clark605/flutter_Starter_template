import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_detail_state.freezed.dart';

@freezed
abstract class ExampleDetailState with _$ExampleDetailState {
  const factory ExampleDetailState.initial() = _Initial;
  const factory ExampleDetailState.loading() = _Loading;
  const factory ExampleDetailState.loaded(ItemDto item) = _Loaded;
  const factory ExampleDetailState.error(Failure failure) = _Error;
}
