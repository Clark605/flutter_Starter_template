import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_dto.freezed.dart';
part 'item_dto.g.dart';

@freezed
abstract class ItemDto with _$ItemDto {
  const factory ItemDto({
    required int id,
    required String title,
    required String body,
    @JsonKey(name: 'userId') int? userId,
  }) = _ItemDto;

  factory ItemDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDtoFromJson(json);
}
