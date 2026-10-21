// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemDto {

 int get id; String get title; String get body;@JsonKey(name: 'userId') int? get userId;
/// Create a copy of ItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDtoCopyWith<ItemDto> get copyWith => _$ItemDtoCopyWithImpl<ItemDto>(this as ItemDto, _$identity);

  /// Serializes this ItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,userId);

@override
String toString() {
  return 'ItemDto(id: $id, title: $title, body: $body, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $ItemDtoCopyWith<$Res>  {
  factory $ItemDtoCopyWith(ItemDto value, $Res Function(ItemDto) _then) = _$ItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String body,@JsonKey(name: 'userId') int? userId
});




}
/// @nodoc
class _$ItemDtoCopyWithImpl<$Res>
    implements $ItemDtoCopyWith<$Res> {
  _$ItemDtoCopyWithImpl(this._self, this._then);

  final ItemDto _self;
  final $Res Function(ItemDto) _then;

/// Create a copy of ItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? userId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemDto].
extension ItemDtoPatterns on ItemDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemDto value)  $default,){
final _that = this;
switch (_that) {
case _ItemDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String body, @JsonKey(name: 'userId')  int? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemDto() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.userId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String body, @JsonKey(name: 'userId')  int? userId)  $default,) {final _that = this;
switch (_that) {
case _ItemDto():
return $default(_that.id,_that.title,_that.body,_that.userId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String body, @JsonKey(name: 'userId')  int? userId)?  $default,) {final _that = this;
switch (_that) {
case _ItemDto() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemDto implements ItemDto {
  const _ItemDto({required this.id, required this.title, required this.body, @JsonKey(name: 'userId') this.userId});
  factory _ItemDto.fromJson(Map<String, dynamic> json) => _$ItemDtoFromJson(json);

@override final  int id;
@override final  String title;
@override final  String body;
@override@JsonKey(name: 'userId') final  int? userId;

/// Create a copy of ItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDtoCopyWith<_ItemDto> get copyWith => __$ItemDtoCopyWithImpl<_ItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,userId);

@override
String toString() {
  return 'ItemDto(id: $id, title: $title, body: $body, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$ItemDtoCopyWith<$Res> implements $ItemDtoCopyWith<$Res> {
  factory _$ItemDtoCopyWith(_ItemDto value, $Res Function(_ItemDto) _then) = __$ItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String body,@JsonKey(name: 'userId') int? userId
});




}
/// @nodoc
class __$ItemDtoCopyWithImpl<$Res>
    implements _$ItemDtoCopyWith<$Res> {
  __$ItemDtoCopyWithImpl(this._self, this._then);

  final _ItemDto _self;
  final $Res Function(_ItemDto) _then;

/// Create a copy of ItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? userId = freezed,}) {
  return _then(_ItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
