// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemDto _$ItemDtoFromJson(Map<String, dynamic> json) => _ItemDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String,
  userId: (json['userId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ItemDtoToJson(_ItemDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'userId': instance.userId,
};
