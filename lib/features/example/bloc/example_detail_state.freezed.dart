// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExampleDetailState {

 LoadStatus get status; ItemModel? get item; Failure? get failure;
/// Create a copy of ExampleDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleDetailStateCopyWith<ExampleDetailState> get copyWith => _$ExampleDetailStateCopyWithImpl<ExampleDetailState>(this as ExampleDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.item, item) || other.item == item)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,item,failure);

@override
String toString() {
  return 'ExampleDetailState(status: $status, item: $item, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExampleDetailStateCopyWith<$Res>  {
  factory $ExampleDetailStateCopyWith(ExampleDetailState value, $Res Function(ExampleDetailState) _then) = _$ExampleDetailStateCopyWithImpl;
@useResult
$Res call({
 LoadStatus status, ItemModel? item, Failure? failure
});


$ItemModelCopyWith<$Res>? get item;

}
/// @nodoc
class _$ExampleDetailStateCopyWithImpl<$Res>
    implements $ExampleDetailStateCopyWith<$Res> {
  _$ExampleDetailStateCopyWithImpl(this._self, this._then);

  final ExampleDetailState _self;
  final $Res Function(ExampleDetailState) _then;

/// Create a copy of ExampleDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? item = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ItemModel?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ExampleDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemModelCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $ItemModelCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExampleDetailState].
extension ExampleDetailStatePatterns on ExampleDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ExampleDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadStatus status,  ItemModel? item,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleDetailState() when $default != null:
return $default(_that.status,_that.item,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadStatus status,  ItemModel? item,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ExampleDetailState():
return $default(_that.status,_that.item,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadStatus status,  ItemModel? item,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ExampleDetailState() when $default != null:
return $default(_that.status,_that.item,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ExampleDetailState implements ExampleDetailState {
  const _ExampleDetailState({this.status = LoadStatus.initial, this.item, this.failure});
  

@override@JsonKey() final  LoadStatus status;
@override final  ItemModel? item;
@override final  Failure? failure;

/// Create a copy of ExampleDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleDetailStateCopyWith<_ExampleDetailState> get copyWith => __$ExampleDetailStateCopyWithImpl<_ExampleDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.item, item) || other.item == item)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,item,failure);

@override
String toString() {
  return 'ExampleDetailState(status: $status, item: $item, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ExampleDetailStateCopyWith<$Res> implements $ExampleDetailStateCopyWith<$Res> {
  factory _$ExampleDetailStateCopyWith(_ExampleDetailState value, $Res Function(_ExampleDetailState) _then) = __$ExampleDetailStateCopyWithImpl;
@override @useResult
$Res call({
 LoadStatus status, ItemModel? item, Failure? failure
});


@override $ItemModelCopyWith<$Res>? get item;

}
/// @nodoc
class __$ExampleDetailStateCopyWithImpl<$Res>
    implements _$ExampleDetailStateCopyWith<$Res> {
  __$ExampleDetailStateCopyWithImpl(this._self, this._then);

  final _ExampleDetailState _self;
  final $Res Function(_ExampleDetailState) _then;

/// Create a copy of ExampleDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? item = freezed,Object? failure = freezed,}) {
  return _then(_ExampleDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoadStatus,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ItemModel?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ExampleDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemModelCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $ItemModelCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

// dart format on
