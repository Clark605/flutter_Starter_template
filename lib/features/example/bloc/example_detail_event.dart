import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_detail_event.freezed.dart';

@freezed
abstract class ExampleDetailEvent with _$ExampleDetailEvent {
  const factory ExampleDetailEvent.load(int id) = _Load;
  const factory ExampleDetailEvent.refresh(int id) = _Refresh;
}
