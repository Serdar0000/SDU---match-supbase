// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id; String get name; int get age; String get faculty; int get yearOfStudy; String get imageUrl; List<String> get interests; String get bio; String get email; String get gender;// 'male', 'female', 'other'
 String get lookingFor;// 'male', 'female', 'all'
 int get starsGiven;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.yearOfStudy, yearOfStudy) || other.yearOfStudy == yearOfStudy)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.email, email) || other.email == email)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.lookingFor, lookingFor) || other.lookingFor == lookingFor)&&(identical(other.starsGiven, starsGiven) || other.starsGiven == starsGiven));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,age,faculty,yearOfStudy,imageUrl,const DeepCollectionEquality().hash(interests),bio,email,gender,lookingFor,starsGiven);

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, age: $age, faculty: $faculty, yearOfStudy: $yearOfStudy, imageUrl: $imageUrl, interests: $interests, bio: $bio, email: $email, gender: $gender, lookingFor: $lookingFor, starsGiven: $starsGiven)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, int age, String faculty, int yearOfStudy, String imageUrl, List<String> interests, String bio, String email, String gender, String lookingFor, int starsGiven
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? age = null,Object? faculty = null,Object? yearOfStudy = null,Object? imageUrl = null,Object? interests = null,Object? bio = null,Object? email = null,Object? gender = null,Object? lookingFor = null,Object? starsGiven = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,faculty: null == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as String,yearOfStudy: null == yearOfStudy ? _self.yearOfStudy : yearOfStudy // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,lookingFor: null == lookingFor ? _self.lookingFor : lookingFor // ignore: cast_nullable_to_non_nullable
as String,starsGiven: null == starsGiven ? _self.starsGiven : starsGiven // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int age,  String faculty,  int yearOfStudy,  String imageUrl,  List<String> interests,  String bio,  String email,  String gender,  String lookingFor,  int starsGiven)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.faculty,_that.yearOfStudy,_that.imageUrl,_that.interests,_that.bio,_that.email,_that.gender,_that.lookingFor,_that.starsGiven);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int age,  String faculty,  int yearOfStudy,  String imageUrl,  List<String> interests,  String bio,  String email,  String gender,  String lookingFor,  int starsGiven)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.name,_that.age,_that.faculty,_that.yearOfStudy,_that.imageUrl,_that.interests,_that.bio,_that.email,_that.gender,_that.lookingFor,_that.starsGiven);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int age,  String faculty,  int yearOfStudy,  String imageUrl,  List<String> interests,  String bio,  String email,  String gender,  String lookingFor,  int starsGiven)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.faculty,_that.yearOfStudy,_that.imageUrl,_that.interests,_that.bio,_that.email,_that.gender,_that.lookingFor,_that.starsGiven);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile extends UserProfile {
  const _UserProfile({required this.id, required this.name, required this.age, required this.faculty, required this.yearOfStudy, required this.imageUrl, required final  List<String> interests, required this.bio, this.email = '', this.gender = 'other', this.lookingFor = 'all', this.starsGiven = 0}): _interests = interests,super._();
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override final  String name;
@override final  int age;
@override final  String faculty;
@override final  int yearOfStudy;
@override final  String imageUrl;
 final  List<String> _interests;
@override List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

@override final  String bio;
@override@JsonKey() final  String email;
@override@JsonKey() final  String gender;
// 'male', 'female', 'other'
@override@JsonKey() final  String lookingFor;
// 'male', 'female', 'all'
@override@JsonKey() final  int starsGiven;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.faculty, faculty) || other.faculty == faculty)&&(identical(other.yearOfStudy, yearOfStudy) || other.yearOfStudy == yearOfStudy)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.email, email) || other.email == email)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.lookingFor, lookingFor) || other.lookingFor == lookingFor)&&(identical(other.starsGiven, starsGiven) || other.starsGiven == starsGiven));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,age,faculty,yearOfStudy,imageUrl,const DeepCollectionEquality().hash(_interests),bio,email,gender,lookingFor,starsGiven);

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, age: $age, faculty: $faculty, yearOfStudy: $yearOfStudy, imageUrl: $imageUrl, interests: $interests, bio: $bio, email: $email, gender: $gender, lookingFor: $lookingFor, starsGiven: $starsGiven)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int age, String faculty, int yearOfStudy, String imageUrl, List<String> interests, String bio, String email, String gender, String lookingFor, int starsGiven
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? age = null,Object? faculty = null,Object? yearOfStudy = null,Object? imageUrl = null,Object? interests = null,Object? bio = null,Object? email = null,Object? gender = null,Object? lookingFor = null,Object? starsGiven = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,faculty: null == faculty ? _self.faculty : faculty // ignore: cast_nullable_to_non_nullable
as String,yearOfStudy: null == yearOfStudy ? _self.yearOfStudy : yearOfStudy // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,lookingFor: null == lookingFor ? _self.lookingFor : lookingFor // ignore: cast_nullable_to_non_nullable
as String,starsGiven: null == starsGiven ? _self.starsGiven : starsGiven // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
