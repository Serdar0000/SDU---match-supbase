// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingData {

 String get name; int get age; String? get gender; String? get lookingFor; String? get faculty; int? get yearOfStudy; String? get photoUrl; bool get isPhotoUploading; List<String> get interests;
/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDataCopyWith<OnboardingData> get copyWith => _$OnboardingDataCopyWithImpl<OnboardingData>(this as OnboardingData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingData&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.lookingFor, lookingFor) || other.lookingFor == lookingFor)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.yearOfStudy, yearOfStudy) || other.yearOfStudy == yearOfStudy)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.isPhotoUploading, isPhotoUploading) || other.isPhotoUploading == isPhotoUploading)&&const DeepCollectionEquality().equals(other.interests, interests));
}


@override
int get hashCode => Object.hash(runtimeType,name,age,gender,lookingFor,faculty,yearOfStudy,photoUrl,isPhotoUploading,const DeepCollectionEquality().hash(interests));

@override
String toString() {
  return 'OnboardingData(name: $name, age: $age, gender: $gender, lookingFor: $lookingFor, faculty: $faculty, yearOfStudy: $yearOfStudy, photoUrl: $photoUrl, isPhotoUploading: $isPhotoUploading, interests: $interests)';
}


}

/// @nodoc
abstract mixin class $OnboardingDataCopyWith<$Res>  {
  factory $OnboardingDataCopyWith(OnboardingData value, $Res Function(OnboardingData) _then) = _$OnboardingDataCopyWithImpl;
@useResult
$Res call({
 String name, int age, String? gender, String? lookingFor, String? faculty, int? yearOfStudy, String? photoUrl, bool isPhotoUploading, List<String> interests
});




}
/// @nodoc
class _$OnboardingDataCopyWithImpl<$Res>
    implements $OnboardingDataCopyWith<$Res> {
  _$OnboardingDataCopyWithImpl(this._self, this._then);

  final OnboardingData _self;
  final $Res Function(OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? age = null,Object? gender = freezed,Object? lookingFor = freezed,Object? faculty = freezed,Object? yearOfStudy = freezed,Object? photoUrl = freezed,Object? isPhotoUploading = null,Object? interests = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,lookingFor: freezed == lookingFor ? _self.lookingFor : lookingFor // ignore: cast_nullable_to_non_nullable
as String?,faculty: freezed == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as String?,yearOfStudy: freezed == yearOfStudy ? _self.yearOfStudy : yearOfStudy // ignore: cast_nullable_to_non_nullable
as int?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,isPhotoUploading: null == isPhotoUploading ? _self.isPhotoUploading : isPhotoUploading // ignore: cast_nullable_to_non_nullable
as bool,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingData].
extension OnboardingDataPatterns on OnboardingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingData value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingData value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int age,  String? gender,  String? lookingFor,  String? faculty,  int? yearOfStudy,  String? photoUrl,  bool isPhotoUploading,  List<String> interests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.name,_that.age,_that.gender,_that.lookingFor,_that.faculty,_that.yearOfStudy,_that.photoUrl,_that.isPhotoUploading,_that.interests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int age,  String? gender,  String? lookingFor,  String? faculty,  int? yearOfStudy,  String? photoUrl,  bool isPhotoUploading,  List<String> interests)  $default,) {final _that = this;
switch (_that) {
case _OnboardingData():
return $default(_that.name,_that.age,_that.gender,_that.lookingFor,_that.faculty,_that.yearOfStudy,_that.photoUrl,_that.isPhotoUploading,_that.interests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int age,  String? gender,  String? lookingFor,  String? faculty,  int? yearOfStudy,  String? photoUrl,  bool isPhotoUploading,  List<String> interests)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.name,_that.age,_that.gender,_that.lookingFor,_that.faculty,_that.yearOfStudy,_that.photoUrl,_that.isPhotoUploading,_that.interests);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingData extends OnboardingData {
  const _OnboardingData({this.name = '', this.age = 20, this.gender, this.lookingFor, this.faculty, this.yearOfStudy, this.photoUrl, this.isPhotoUploading = false, final  List<String> interests = const <String>[]}): _interests = interests,super._();
  

@override@JsonKey() final  String name;
@override@JsonKey() final  int age;
@override final  String? gender;
@override final  String? lookingFor;
@override final  String? faculty;
@override final  int? yearOfStudy;
@override final  String? photoUrl;
@override@JsonKey() final  bool isPhotoUploading;
 final  List<String> _interests;
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}


/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDataCopyWith<_OnboardingData> get copyWith => __$OnboardingDataCopyWithImpl<_OnboardingData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingData&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.lookingFor, lookingFor) || other.lookingFor == lookingFor)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.yearOfStudy, yearOfStudy) || other.yearOfStudy == yearOfStudy)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.isPhotoUploading, isPhotoUploading) || other.isPhotoUploading == isPhotoUploading)&&const DeepCollectionEquality().equals(other._interests, _interests));
}


@override
int get hashCode => Object.hash(runtimeType,name,age,gender,lookingFor,faculty,yearOfStudy,photoUrl,isPhotoUploading,const DeepCollectionEquality().hash(_interests));

@override
String toString() {
  return 'OnboardingData(name: $name, age: $age, gender: $gender, lookingFor: $lookingFor, faculty: $faculty, yearOfStudy: $yearOfStudy, photoUrl: $photoUrl, isPhotoUploading: $isPhotoUploading, interests: $interests)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDataCopyWith<$Res> implements $OnboardingDataCopyWith<$Res> {
  factory _$OnboardingDataCopyWith(_OnboardingData value, $Res Function(_OnboardingData) _then) = __$OnboardingDataCopyWithImpl;
@override @useResult
$Res call({
 String name, int age, String? gender, String? lookingFor, String? faculty, int? yearOfStudy, String? photoUrl, bool isPhotoUploading, List<String> interests
});




}
/// @nodoc
class __$OnboardingDataCopyWithImpl<$Res>
    implements _$OnboardingDataCopyWith<$Res> {
  __$OnboardingDataCopyWithImpl(this._self, this._then);

  final _OnboardingData _self;
  final $Res Function(_OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? age = null,Object? gender = freezed,Object? lookingFor = freezed,Object? faculty = freezed,Object? yearOfStudy = freezed,Object? photoUrl = freezed,Object? isPhotoUploading = null,Object? interests = null,}) {
  return _then(_OnboardingData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,lookingFor: freezed == lookingFor ? _self.lookingFor : lookingFor // ignore: cast_nullable_to_non_nullable
as String?,faculty: freezed == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as String?,yearOfStudy: freezed == yearOfStudy ? _self.yearOfStudy : yearOfStudy // ignore: cast_nullable_to_non_nullable
as int?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,isPhotoUploading: null == isPhotoUploading ? _self.isPhotoUploading : isPhotoUploading // ignore: cast_nullable_to_non_nullable
as bool,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
