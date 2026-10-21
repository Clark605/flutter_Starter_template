import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
abstract class ItemModel with _$ItemModel {
  const factory ItemModel({
    required int id,
    required String title,
    required String body,
    @JsonKey(name: 'userId') int? userId,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
}
