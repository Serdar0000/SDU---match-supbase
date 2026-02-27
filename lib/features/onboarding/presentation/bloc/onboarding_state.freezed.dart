// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingState()';
}


}

/// @nodoc
class $OnboardingStateCopyWith<$Res>  {
$OnboardingStateCopyWith(OnboardingState _, $Res Function(OnboardingState) __);
}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OnboardingInitial value)?  initial,TResult Function( OnboardingInProgress value)?  inProgress,TResult Function( OnboardingSaving value)?  saving,TResult Function( OnboardingStateCompleted value)?  completed,TResult Function( OnboardingError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OnboardingInitial() when initial != null:
return initial(_that);case OnboardingInProgress() when inProgress != null:
return inProgress(_that);case OnboardingSaving() when saving != null:
return saving(_that);case OnboardingStateCompleted() when completed != null:
return completed(_that);case OnboardingError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OnboardingInitial value)  initial,required TResult Function( OnboardingInProgress value)  inProgress,required TResult Function( OnboardingSaving value)  saving,required TResult Function( OnboardingStateCompleted value)  completed,required TResult Function( OnboardingError value)  error,}){
final _that = this;
switch (_that) {
case OnboardingInitial():
return initial(_that);case OnboardingInProgress():
return inProgress(_that);case OnboardingSaving():
return saving(_that);case OnboardingStateCompleted():
return completed(_that);case OnboardingError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OnboardingInitial value)?  initial,TResult? Function( OnboardingInProgress value)?  inProgress,TResult? Function( OnboardingSaving value)?  saving,TResult? Function( OnboardingStateCompleted value)?  completed,TResult? Function( OnboardingError value)?  error,}){
final _that = this;
switch (_that) {
case OnboardingInitial() when initial != null:
return initial(_that);case OnboardingInProgress() when inProgress != null:
return inProgress(_that);case OnboardingSaving() when saving != null:
return saving(_that);case OnboardingStateCompleted() when completed != null:
return completed(_that);case OnboardingError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( OnboardingData data,  int currentStep)?  inProgress,TResult Function()?  saving,TResult Function()?  completed,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OnboardingInitial() when initial != null:
return initial();case OnboardingInProgress() when inProgress != null:
return inProgress(_that.data,_that.currentStep);case OnboardingSaving() when saving != null:
return saving();case OnboardingStateCompleted() when completed != null:
return completed();case OnboardingError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( OnboardingData data,  int currentStep)  inProgress,required TResult Function()  saving,required TResult Function()  completed,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case OnboardingInitial():
return initial();case OnboardingInProgress():
return inProgress(_that.data,_that.currentStep);case OnboardingSaving():
return saving();case OnboardingStateCompleted():
return completed();case OnboardingError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( OnboardingData data,  int currentStep)?  inProgress,TResult? Function()?  saving,TResult? Function()?  completed,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case OnboardingInitial() when initial != null:
return initial();case OnboardingInProgress() when inProgress != null:
return inProgress(_that.data,_that.currentStep);case OnboardingSaving() when saving != null:
return saving();case OnboardingStateCompleted() when completed != null:
return completed();case OnboardingError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class OnboardingInitial implements OnboardingState {
  const OnboardingInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingState.initial()';
}


}




/// @nodoc


class OnboardingInProgress implements OnboardingState {
  const OnboardingInProgress({required this.data, this.currentStep = 0});
  

 final  OnboardingData data;
@JsonKey() final  int currentStep;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingInProgressCopyWith<OnboardingInProgress> get copyWith => _$OnboardingInProgressCopyWithImpl<OnboardingInProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingInProgress&&(identical(other.data, data) || other.data == data)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,data,currentStep);

@override
String toString() {
  return 'OnboardingState.inProgress(data: $data, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class $OnboardingInProgressCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory $OnboardingInProgressCopyWith(OnboardingInProgress value, $Res Function(OnboardingInProgress) _then) = _$OnboardingInProgressCopyWithImpl;
@useResult
$Res call({
 OnboardingData data, int currentStep
});


$OnboardingDataCopyWith<$Res> get data;

}
/// @nodoc
class _$OnboardingInProgressCopyWithImpl<$Res>
    implements $OnboardingInProgressCopyWith<$Res> {
  _$OnboardingInProgressCopyWithImpl(this._self, this._then);

  final OnboardingInProgress _self;
  final $Res Function(OnboardingInProgress) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? currentStep = null,}) {
  return _then(OnboardingInProgress(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OnboardingData,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingDataCopyWith<$Res> get data {
  
  return $OnboardingDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc


class OnboardingSaving implements OnboardingState {
  const OnboardingSaving();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingSaving);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingState.saving()';
}


}




/// @nodoc


class OnboardingStateCompleted implements OnboardingState {
  const OnboardingStateCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStateCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingState.completed()';
}


}




/// @nodoc


class OnboardingError implements OnboardingState {
  const OnboardingError(this.message);
  

 final  String message;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingErrorCopyWith<OnboardingError> get copyWith => _$OnboardingErrorCopyWithImpl<OnboardingError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OnboardingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $OnboardingErrorCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory $OnboardingErrorCopyWith(OnboardingError value, $Res Function(OnboardingError) _then) = _$OnboardingErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$OnboardingErrorCopyWithImpl<$Res>
    implements $OnboardingErrorCopyWith<$Res> {
  _$OnboardingErrorCopyWithImpl(this._self, this._then);

  final OnboardingError _self;
  final $Res Function(OnboardingError) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(OnboardingError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
