// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExampleState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExampleState()';
}


}

/// @nodoc
class $ExampleStateCopyWith<$Res>  {
$ExampleStateCopyWith(ExampleState _, $Res Function(ExampleState) __);
}


/// Adds pattern-matching-related methods to [ExampleState].
extension ExampleStatePatterns on ExampleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExampleStateInitial value)?  initial,TResult Function( ExampleStateLoading value)?  loading,TResult Function( ExampleStateLoaded value)?  loaded,TResult Function( ExampleStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExampleStateInitial() when initial != null:
return initial(_that);case ExampleStateLoading() when loading != null:
return loading(_that);case ExampleStateLoaded() when loaded != null:
return loaded(_that);case ExampleStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExampleStateInitial value)  initial,required TResult Function( ExampleStateLoading value)  loading,required TResult Function( ExampleStateLoaded value)  loaded,required TResult Function( ExampleStateError value)  error,}){
final _that = this;
switch (_that) {
case ExampleStateInitial():
return initial(_that);case ExampleStateLoading():
return loading(_that);case ExampleStateLoaded():
return loaded(_that);case ExampleStateError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExampleStateInitial value)?  initial,TResult? Function( ExampleStateLoading value)?  loading,TResult? Function( ExampleStateLoaded value)?  loaded,TResult? Function( ExampleStateError value)?  error,}){
final _that = this;
switch (_that) {
case ExampleStateInitial() when initial != null:
return initial(_that);case ExampleStateLoading() when loading != null:
return loading(_that);case ExampleStateLoaded() when loaded != null:
return loaded(_that);case ExampleStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ItemModel> items,  bool hasMore,  bool isLoadingMore,  int page)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExampleStateInitial() when initial != null:
return initial();case ExampleStateLoading() when loading != null:
return loading();case ExampleStateLoaded() when loaded != null:
return loaded(_that.items,_that.hasMore,_that.isLoadingMore,_that.page);case ExampleStateError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ItemModel> items,  bool hasMore,  bool isLoadingMore,  int page)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case ExampleStateInitial():
return initial();case ExampleStateLoading():
return loading();case ExampleStateLoaded():
return loaded(_that.items,_that.hasMore,_that.isLoadingMore,_that.page);case ExampleStateError():
return error(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ItemModel> items,  bool hasMore,  bool isLoadingMore,  int page)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case ExampleStateInitial() when initial != null:
return initial();case ExampleStateLoading() when loading != null:
return loading();case ExampleStateLoaded() when loaded != null:
return loaded(_that.items,_that.hasMore,_that.isLoadingMore,_that.page);case ExampleStateError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ExampleStateInitial implements ExampleState {
  const ExampleStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExampleState.initial()';
}


}




/// @nodoc


class ExampleStateLoading implements ExampleState {
  const ExampleStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExampleState.loading()';
}


}




/// @nodoc


class ExampleStateLoaded implements ExampleState {
  const ExampleStateLoaded({required final  List<ItemModel> items, this.hasMore = true, this.isLoadingMore = false, this.page = 1}): _items = items;
  

 final  List<ItemModel> _items;
 List<ItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@JsonKey() final  bool hasMore;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  int page;

/// Create a copy of ExampleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleStateLoadedCopyWith<ExampleStateLoaded> get copyWith => _$ExampleStateLoadedCopyWithImpl<ExampleStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleStateLoaded&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasMore,isLoadingMore,page);

@override
String toString() {
  return 'ExampleState.loaded(items: $items, hasMore: $hasMore, isLoadingMore: $isLoadingMore, page: $page)';
}


}

/// @nodoc
abstract mixin class $ExampleStateLoadedCopyWith<$Res> implements $ExampleStateCopyWith<$Res> {
  factory $ExampleStateLoadedCopyWith(ExampleStateLoaded value, $Res Function(ExampleStateLoaded) _then) = _$ExampleStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<ItemModel> items, bool hasMore, bool isLoadingMore, int page
});




}
/// @nodoc
class _$ExampleStateLoadedCopyWithImpl<$Res>
    implements $ExampleStateLoadedCopyWith<$Res> {
  _$ExampleStateLoadedCopyWithImpl(this._self, this._then);

  final ExampleStateLoaded _self;
  final $Res Function(ExampleStateLoaded) _then;

/// Create a copy of ExampleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasMore = null,Object? isLoadingMore = null,Object? page = null,}) {
  return _then(ExampleStateLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ItemModel>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ExampleStateError implements ExampleState {
  const ExampleStateError(this.failure);
  

 final  Failure failure;

/// Create a copy of ExampleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleStateErrorCopyWith<ExampleStateError> get copyWith => _$ExampleStateErrorCopyWithImpl<ExampleStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleStateError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ExampleState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExampleStateErrorCopyWith<$Res> implements $ExampleStateCopyWith<$Res> {
  factory $ExampleStateErrorCopyWith(ExampleStateError value, $Res Function(ExampleStateError) _then) = _$ExampleStateErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$ExampleStateErrorCopyWithImpl<$Res>
    implements $ExampleStateErrorCopyWith<$Res> {
  _$ExampleStateErrorCopyWithImpl(this._self, this._then);

  final ExampleStateError _self;
  final $Res Function(ExampleStateError) _then;

/// Create a copy of ExampleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ExampleStateError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
