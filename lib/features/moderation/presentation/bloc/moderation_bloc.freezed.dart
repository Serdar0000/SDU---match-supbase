// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModerationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModerationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModerationEvent()';
}


}

/// @nodoc
class $ModerationEventCopyWith<$Res>  {
$ModerationEventCopyWith(ModerationEvent _, $Res Function(ModerationEvent) __);
}


/// Adds pattern-matching-related methods to [ModerationEvent].
extension ModerationEventPatterns on ModerationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ReportUserRequested value)?  reportUserRequested,TResult Function( _BlockUserRequested value)?  blockUserRequested,TResult Function( _UnblockUserRequested value)?  unblockUserRequested,TResult Function( _BlockedIdsRequested value)?  blockedIdsRequested,TResult Function( _BlockedIdsUpdated value)?  blockedIdsUpdated,TResult Function( _DeleteAccountRequested value)?  deleteAccountRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportUserRequested() when reportUserRequested != null:
return reportUserRequested(_that);case _BlockUserRequested() when blockUserRequested != null:
return blockUserRequested(_that);case _UnblockUserRequested() when unblockUserRequested != null:
return unblockUserRequested(_that);case _BlockedIdsRequested() when blockedIdsRequested != null:
return blockedIdsRequested(_that);case _BlockedIdsUpdated() when blockedIdsUpdated != null:
return blockedIdsUpdated(_that);case _DeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ReportUserRequested value)  reportUserRequested,required TResult Function( _BlockUserRequested value)  blockUserRequested,required TResult Function( _UnblockUserRequested value)  unblockUserRequested,required TResult Function( _BlockedIdsRequested value)  blockedIdsRequested,required TResult Function( _BlockedIdsUpdated value)  blockedIdsUpdated,required TResult Function( _DeleteAccountRequested value)  deleteAccountRequested,}){
final _that = this;
switch (_that) {
case _ReportUserRequested():
return reportUserRequested(_that);case _BlockUserRequested():
return blockUserRequested(_that);case _UnblockUserRequested():
return unblockUserRequested(_that);case _BlockedIdsRequested():
return blockedIdsRequested(_that);case _BlockedIdsUpdated():
return blockedIdsUpdated(_that);case _DeleteAccountRequested():
return deleteAccountRequested(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ReportUserRequested value)?  reportUserRequested,TResult? Function( _BlockUserRequested value)?  blockUserRequested,TResult? Function( _UnblockUserRequested value)?  unblockUserRequested,TResult? Function( _BlockedIdsRequested value)?  blockedIdsRequested,TResult? Function( _BlockedIdsUpdated value)?  blockedIdsUpdated,TResult? Function( _DeleteAccountRequested value)?  deleteAccountRequested,}){
final _that = this;
switch (_that) {
case _ReportUserRequested() when reportUserRequested != null:
return reportUserRequested(_that);case _BlockUserRequested() when blockUserRequested != null:
return blockUserRequested(_that);case _UnblockUserRequested() when unblockUserRequested != null:
return unblockUserRequested(_that);case _BlockedIdsRequested() when blockedIdsRequested != null:
return blockedIdsRequested(_that);case _BlockedIdsUpdated() when blockedIdsUpdated != null:
return blockedIdsUpdated(_that);case _DeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String reportedId,  String reason,  String? details)?  reportUserRequested,TResult Function( String blockedId)?  blockUserRequested,TResult Function( String blockedId)?  unblockUserRequested,TResult Function()?  blockedIdsRequested,TResult Function( List<String> ids)?  blockedIdsUpdated,TResult Function()?  deleteAccountRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportUserRequested() when reportUserRequested != null:
return reportUserRequested(_that.reportedId,_that.reason,_that.details);case _BlockUserRequested() when blockUserRequested != null:
return blockUserRequested(_that.blockedId);case _UnblockUserRequested() when unblockUserRequested != null:
return unblockUserRequested(_that.blockedId);case _BlockedIdsRequested() when blockedIdsRequested != null:
return blockedIdsRequested();case _BlockedIdsUpdated() when blockedIdsUpdated != null:
return blockedIdsUpdated(_that.ids);case _DeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String reportedId,  String reason,  String? details)  reportUserRequested,required TResult Function( String blockedId)  blockUserRequested,required TResult Function( String blockedId)  unblockUserRequested,required TResult Function()  blockedIdsRequested,required TResult Function( List<String> ids)  blockedIdsUpdated,required TResult Function()  deleteAccountRequested,}) {final _that = this;
switch (_that) {
case _ReportUserRequested():
return reportUserRequested(_that.reportedId,_that.reason,_that.details);case _BlockUserRequested():
return blockUserRequested(_that.blockedId);case _UnblockUserRequested():
return unblockUserRequested(_that.blockedId);case _BlockedIdsRequested():
return blockedIdsRequested();case _BlockedIdsUpdated():
return blockedIdsUpdated(_that.ids);case _DeleteAccountRequested():
return deleteAccountRequested();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String reportedId,  String reason,  String? details)?  reportUserRequested,TResult? Function( String blockedId)?  blockUserRequested,TResult? Function( String blockedId)?  unblockUserRequested,TResult? Function()?  blockedIdsRequested,TResult? Function( List<String> ids)?  blockedIdsUpdated,TResult? Function()?  deleteAccountRequested,}) {final _that = this;
switch (_that) {
case _ReportUserRequested() when reportUserRequested != null:
return reportUserRequested(_that.reportedId,_that.reason,_that.details);case _BlockUserRequested() when blockUserRequested != null:
return blockUserRequested(_that.blockedId);case _UnblockUserRequested() when unblockUserRequested != null:
return unblockUserRequested(_that.blockedId);case _BlockedIdsRequested() when blockedIdsRequested != null:
return blockedIdsRequested();case _BlockedIdsUpdated() when blockedIdsUpdated != null:
return blockedIdsUpdated(_that.ids);case _DeleteAccountRequested() when deleteAccountRequested != null:
return deleteAccountRequested();case _:
  return null;

}
}

}

/// @nodoc


class _ReportUserRequested implements ModerationEvent {
  const _ReportUserRequested({required this.reportedId, required this.reason, this.details});
  

 final  String reportedId;
 final  String reason;
 final  String? details;

/// Create a copy of ModerationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportUserRequestedCopyWith<_ReportUserRequested> get copyWith => __$ReportUserRequestedCopyWithImpl<_ReportUserRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportUserRequested&&(identical(other.reportedId, reportedId) || other.reportedId == reportedId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,reportedId,reason,details);

@override
String toString() {
  return 'ModerationEvent.reportUserRequested(reportedId: $reportedId, reason: $reason, details: $details)';
}


}

/// @nodoc
abstract mixin class _$ReportUserRequestedCopyWith<$Res> implements $ModerationEventCopyWith<$Res> {
  factory _$ReportUserRequestedCopyWith(_ReportUserRequested value, $Res Function(_ReportUserRequested) _then) = __$ReportUserRequestedCopyWithImpl;
@useResult
$Res call({
 String reportedId, String reason, String? details
});




}
/// @nodoc
class __$ReportUserRequestedCopyWithImpl<$Res>
    implements _$ReportUserRequestedCopyWith<$Res> {
  __$ReportUserRequestedCopyWithImpl(this._self, this._then);

  final _ReportUserRequested _self;
  final $Res Function(_ReportUserRequested) _then;

/// Create a copy of ModerationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reportedId = null,Object? reason = null,Object? details = freezed,}) {
  return _then(_ReportUserRequested(
reportedId: null == reportedId ? _self.reportedId : reportedId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _BlockUserRequested implements ModerationEvent {
  const _BlockUserRequested({required this.blockedId});
  

 final  String blockedId;

/// Create a copy of ModerationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockUserRequestedCopyWith<_BlockUserRequested> get copyWith => __$BlockUserRequestedCopyWithImpl<_BlockUserRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockUserRequested&&(identical(other.blockedId, blockedId) || other.blockedId == blockedId));
}


@override
int get hashCode => Object.hash(runtimeType,blockedId);

@override
String toString() {
  return 'ModerationEvent.blockUserRequested(blockedId: $blockedId)';
}


}

/// @nodoc
abstract mixin class _$BlockUserRequestedCopyWith<$Res> implements $ModerationEventCopyWith<$Res> {
  factory _$BlockUserRequestedCopyWith(_BlockUserRequested value, $Res Function(_BlockUserRequested) _then) = __$BlockUserRequestedCopyWithImpl;
@useResult
$Res call({
 String blockedId
});




}
/// @nodoc
class __$BlockUserRequestedCopyWithImpl<$Res>
    implements _$BlockUserRequestedCopyWith<$Res> {
  __$BlockUserRequestedCopyWithImpl(this._self, this._then);

  final _BlockUserRequested _self;
  final $Res Function(_BlockUserRequested) _then;

/// Create a copy of ModerationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? blockedId = null,}) {
  return _then(_BlockUserRequested(
blockedId: null == blockedId ? _self.blockedId : blockedId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UnblockUserRequested implements ModerationEvent {
  const _UnblockUserRequested({required this.blockedId});
  

 final  String blockedId;

/// Create a copy of ModerationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnblockUserRequestedCopyWith<_UnblockUserRequested> get copyWith => __$UnblockUserRequestedCopyWithImpl<_UnblockUserRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnblockUserRequested&&(identical(other.blockedId, blockedId) || other.blockedId == blockedId));
}


@override
int get hashCode => Object.hash(runtimeType,blockedId);

@override
String toString() {
  return 'ModerationEvent.unblockUserRequested(blockedId: $blockedId)';
}


}

/// @nodoc
abstract mixin class _$UnblockUserRequestedCopyWith<$Res> implements $ModerationEventCopyWith<$Res> {
  factory _$UnblockUserRequestedCopyWith(_UnblockUserRequested value, $Res Function(_UnblockUserRequested) _then) = __$UnblockUserRequestedCopyWithImpl;
@useResult
$Res call({
 String blockedId
});




}
/// @nodoc
class __$UnblockUserRequestedCopyWithImpl<$Res>
    implements _$UnblockUserRequestedCopyWith<$Res> {
  __$UnblockUserRequestedCopyWithImpl(this._self, this._then);

  final _UnblockUserRequested _self;
  final $Res Function(_UnblockUserRequested) _then;

/// Create a copy of ModerationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? blockedId = null,}) {
  return _then(_UnblockUserRequested(
blockedId: null == blockedId ? _self.blockedId : blockedId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _BlockedIdsRequested implements ModerationEvent {
  const _BlockedIdsRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedIdsRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModerationEvent.blockedIdsRequested()';
}


}




/// @nodoc


class _BlockedIdsUpdated implements ModerationEvent {
  const _BlockedIdsUpdated(final  List<String> ids): _ids = ids;
  

 final  List<String> _ids;
 List<String> get ids {
  if (_ids is EqualUnmodifiableListView) return _ids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ids);
}


/// Create a copy of ModerationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedIdsUpdatedCopyWith<_BlockedIdsUpdated> get copyWith => __$BlockedIdsUpdatedCopyWithImpl<_BlockedIdsUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedIdsUpdated&&const DeepCollectionEquality().equals(other._ids, _ids));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ids));

@override
String toString() {
  return 'ModerationEvent.blockedIdsUpdated(ids: $ids)';
}


}

/// @nodoc
abstract mixin class _$BlockedIdsUpdatedCopyWith<$Res> implements $ModerationEventCopyWith<$Res> {
  factory _$BlockedIdsUpdatedCopyWith(_BlockedIdsUpdated value, $Res Function(_BlockedIdsUpdated) _then) = __$BlockedIdsUpdatedCopyWithImpl;
@useResult
$Res call({
 List<String> ids
});




}
/// @nodoc
class __$BlockedIdsUpdatedCopyWithImpl<$Res>
    implements _$BlockedIdsUpdatedCopyWith<$Res> {
  __$BlockedIdsUpdatedCopyWithImpl(this._self, this._then);

  final _BlockedIdsUpdated _self;
  final $Res Function(_BlockedIdsUpdated) _then;

/// Create a copy of ModerationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ids = null,}) {
  return _then(_BlockedIdsUpdated(
null == ids ? _self._ids : ids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class _DeleteAccountRequested implements ModerationEvent {
  const _DeleteAccountRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAccountRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModerationEvent.deleteAccountRequested()';
}


}




/// @nodoc
mixin _$ModerationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModerationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModerationState()';
}


}

/// @nodoc
class $ModerationStateCopyWith<$Res>  {
$ModerationStateCopyWith(ModerationState _, $Res Function(ModerationState) __);
}


/// Adds pattern-matching-related methods to [ModerationState].
extension ModerationStatePatterns on ModerationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,TResult Function( _BlockedIdsLoaded value)?  blockedIdsLoaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _BlockedIdsLoaded() when blockedIdsLoaded != null:
return blockedIdsLoaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,required TResult Function( _BlockedIdsLoaded value)  blockedIdsLoaded,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Error():
return error(_that);case _BlockedIdsLoaded():
return blockedIdsLoaded(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,TResult? Function( _BlockedIdsLoaded value)?  blockedIdsLoaded,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _BlockedIdsLoaded() when blockedIdsLoaded != null:
return blockedIdsLoaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message,  List<String> blockedIds)?  success,TResult Function( String message)?  error,TResult Function( List<String> ids)?  blockedIdsLoaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.message,_that.blockedIds);case _Error() when error != null:
return error(_that.message);case _BlockedIdsLoaded() when blockedIdsLoaded != null:
return blockedIdsLoaded(_that.ids);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message,  List<String> blockedIds)  success,required TResult Function( String message)  error,required TResult Function( List<String> ids)  blockedIdsLoaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success(_that.message,_that.blockedIds);case _Error():
return error(_that.message);case _BlockedIdsLoaded():
return blockedIdsLoaded(_that.ids);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message,  List<String> blockedIds)?  success,TResult? Function( String message)?  error,TResult? Function( List<String> ids)?  blockedIdsLoaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.message,_that.blockedIds);case _Error() when error != null:
return error(_that.message);case _BlockedIdsLoaded() when blockedIdsLoaded != null:
return blockedIdsLoaded(_that.ids);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ModerationState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModerationState.initial()';
}


}




/// @nodoc


class _Loading implements ModerationState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModerationState.loading()';
}


}




/// @nodoc


class _Success implements ModerationState {
  const _Success({required this.message, required final  List<String> blockedIds}): _blockedIds = blockedIds;
  

 final  String message;
 final  List<String> _blockedIds;
 List<String> get blockedIds {
  if (_blockedIds is EqualUnmodifiableListView) return _blockedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blockedIds);
}


/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._blockedIds, _blockedIds));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_blockedIds));

@override
String toString() {
  return 'ModerationState.success(message: $message, blockedIds: $blockedIds)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $ModerationStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 String message, List<String> blockedIds
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? blockedIds = null,}) {
  return _then(_Success(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,blockedIds: null == blockedIds ? _self._blockedIds : blockedIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class _Error implements ModerationState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ModerationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ModerationStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _BlockedIdsLoaded implements ModerationState {
  const _BlockedIdsLoaded(final  List<String> ids): _ids = ids;
  

 final  List<String> _ids;
 List<String> get ids {
  if (_ids is EqualUnmodifiableListView) return _ids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ids);
}


/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockedIdsLoadedCopyWith<_BlockedIdsLoaded> get copyWith => __$BlockedIdsLoadedCopyWithImpl<_BlockedIdsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockedIdsLoaded&&const DeepCollectionEquality().equals(other._ids, _ids));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ids));

@override
String toString() {
  return 'ModerationState.blockedIdsLoaded(ids: $ids)';
}


}

/// @nodoc
abstract mixin class _$BlockedIdsLoadedCopyWith<$Res> implements $ModerationStateCopyWith<$Res> {
  factory _$BlockedIdsLoadedCopyWith(_BlockedIdsLoaded value, $Res Function(_BlockedIdsLoaded) _then) = __$BlockedIdsLoadedCopyWithImpl;
@useResult
$Res call({
 List<String> ids
});




}
/// @nodoc
class __$BlockedIdsLoadedCopyWithImpl<$Res>
    implements _$BlockedIdsLoadedCopyWith<$Res> {
  __$BlockedIdsLoadedCopyWithImpl(this._self, this._then);

  final _BlockedIdsLoaded _self;
  final $Res Function(_BlockedIdsLoaded) _then;

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ids = null,}) {
  return _then(_BlockedIdsLoaded(
null == ids ? _self._ids : ids // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
