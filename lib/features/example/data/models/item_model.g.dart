// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => _ItemModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String,
  userId: (json['userId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ItemModelToJson(_ItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'userId': instance.userId,
    };
