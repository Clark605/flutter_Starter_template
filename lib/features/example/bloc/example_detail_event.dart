import 'package:flutter_starter/core/utils/action_token.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_detail_event.freezed.dart';

@freezed
abstract class ExampleDetailEvent with _$ExampleDetailEvent {
  const factory ExampleDetailEvent.load(int id, {ActionToken? token}) = _Load;
  const factory ExampleDetailEvent.refresh(int id, {ActionToken? token}) =
      _Refresh;
}
