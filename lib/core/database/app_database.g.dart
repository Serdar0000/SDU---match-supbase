// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTableTable extends UserProfilesTable
    with TableInfo<$UserProfilesTableTable, UserProfilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _facultyMeta = const VerificationMeta(
    'faculty',
  );
  @override
  late final GeneratedColumn<String> faculty = GeneratedColumn<String>(
    'faculty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearOfStudyMeta = const VerificationMeta(
    'yearOfStudy',
  );
  @override
  late final GeneratedColumn<int> yearOfStudy = GeneratedColumn<int>(
    'year_of_study',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> interests =
      GeneratedColumn<String>(
        'interests',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $UserProfilesTableTable.$converterinterests,
      );
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
    'bio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsGivenMeta = const VerificationMeta(
    'starsGiven',
  );
  @override
  late final GeneratedColumn<int> starsGiven = GeneratedColumn<int>(
    'stars_given',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    age,
    faculty,
    yearOfStudy,
    imageUrl,
    interests,
    bio,
    starsGiven,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfilesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('faculty')) {
      context.handle(
        _facultyMeta,
        faculty.isAcceptableOrUnknown(data['faculty']!, _facultyMeta),
      );
    } else if (isInserting) {
      context.missing(_facultyMeta);
    }
    if (data.containsKey('year_of_study')) {
      context.handle(
        _yearOfStudyMeta,
        yearOfStudy.isAcceptableOrUnknown(
          data['year_of_study']!,
          _yearOfStudyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yearOfStudyMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('bio')) {
      context.handle(
        _bioMeta,
        bio.isAcceptableOrUnknown(data['bio']!, _bioMeta),
      );
    } else if (isInserting) {
      context.missing(_bioMeta);
    }
    if (data.containsKey('stars_given')) {
      context.handle(
        _starsGivenMeta,
        starsGiven.isAcceptableOrUnknown(data['stars_given']!, _starsGivenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfilesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfilesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      faculty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faculty'],
      )!,
      yearOfStudy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_of_study'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      interests: $UserProfilesTableTable.$converterinterests.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}interests'],
        )!,
      ),
      bio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio'],
      )!,
      starsGiven: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars_given'],
      )!,
    );
  }

  @override
  $UserProfilesTableTable createAlias(String alias) {
    return $UserProfilesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterinterests =
      const StringListConverter();
}

class UserProfilesTableData extends DataClass
    implements Insertable<UserProfilesTableData> {
  final String id;
  final String name;
  final int age;
  final String faculty;
  final int yearOfStudy;
  final String imageUrl;
  final List<String> interests;
  final String bio;
  final int starsGiven;
  const UserProfilesTableData({
    required this.id,
    required this.name,
    required this.age,
    required this.faculty,
    required this.yearOfStudy,
    required this.imageUrl,
    required this.interests,
    required this.bio,
    required this.starsGiven,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['faculty'] = Variable<String>(faculty);
    map['year_of_study'] = Variable<int>(yearOfStudy);
    map['image_url'] = Variable<String>(imageUrl);
    {
      map['interests'] = Variable<String>(
        $UserProfilesTableTable.$converterinterests.toSql(interests),
      );
    }
    map['bio'] = Variable<String>(bio);
    map['stars_given'] = Variable<int>(starsGiven);
    return map;
  }

  UserProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesTableCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      faculty: Value(faculty),
      yearOfStudy: Value(yearOfStudy),
      imageUrl: Value(imageUrl),
      interests: Value(interests),
      bio: Value(bio),
      starsGiven: Value(starsGiven),
    );
  }

  factory UserProfilesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfilesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      faculty: serializer.fromJson<String>(json['faculty']),
      yearOfStudy: serializer.fromJson<int>(json['yearOfStudy']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      interests: serializer.fromJson<List<String>>(json['interests']),
      bio: serializer.fromJson<String>(json['bio']),
      starsGiven: serializer.fromJson<int>(json['starsGiven']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'faculty': serializer.toJson<String>(faculty),
      'yearOfStudy': serializer.toJson<int>(yearOfStudy),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'interests': serializer.toJson<List<String>>(interests),
      'bio': serializer.toJson<String>(bio),
      'starsGiven': serializer.toJson<int>(starsGiven),
    };
  }

  UserProfilesTableData copyWith({
    String? id,
    String? name,
    int? age,
    String? faculty,
    int? yearOfStudy,
    String? imageUrl,
    List<String>? interests,
    String? bio,
    int? starsGiven,
  }) => UserProfilesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    faculty: faculty ?? this.faculty,
    yearOfStudy: yearOfStudy ?? this.yearOfStudy,
    imageUrl: imageUrl ?? this.imageUrl,
    interests: interests ?? this.interests,
    bio: bio ?? this.bio,
    starsGiven: starsGiven ?? this.starsGiven,
  );
  UserProfilesTableData copyWithCompanion(UserProfilesTableCompanion data) {
    return UserProfilesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      faculty: data.faculty.present ? data.faculty.value : this.faculty,
      yearOfStudy: data.yearOfStudy.present
          ? data.yearOfStudy.value
          : this.yearOfStudy,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      interests: data.interests.present ? data.interests.value : this.interests,
      bio: data.bio.present ? data.bio.value : this.bio,
      starsGiven: data.starsGiven.present
          ? data.starsGiven.value
          : this.starsGiven,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('faculty: $faculty, ')
          ..write('yearOfStudy: $yearOfStudy, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('interests: $interests, ')
          ..write('bio: $bio, ')
          ..write('starsGiven: $starsGiven')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    age,
    faculty,
    yearOfStudy,
    imageUrl,
    interests,
    bio,
    starsGiven,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfilesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.faculty == this.faculty &&
          other.yearOfStudy == this.yearOfStudy &&
          other.imageUrl == this.imageUrl &&
          other.interests == this.interests &&
          other.bio == this.bio &&
          other.starsGiven == this.starsGiven);
}

class UserProfilesTableCompanion
    extends UpdateCompanion<UserProfilesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> age;
  final Value<String> faculty;
  final Value<int> yearOfStudy;
  final Value<String> imageUrl;
  final Value<List<String>> interests;
  final Value<String> bio;
  final Value<int> starsGiven;
  final Value<int> rowid;
  const UserProfilesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.faculty = const Value.absent(),
    this.yearOfStudy = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.interests = const Value.absent(),
    this.bio = const Value.absent(),
    this.starsGiven = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesTableCompanion.insert({
    required String id,
    required String name,
    required int age,
    required String faculty,
    required int yearOfStudy,
    required String imageUrl,
    required List<String> interests,
    required String bio,
    this.starsGiven = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       age = Value(age),
       faculty = Value(faculty),
       yearOfStudy = Value(yearOfStudy),
       imageUrl = Value(imageUrl),
       interests = Value(interests),
       bio = Value(bio);
  static Insertable<UserProfilesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? faculty,
    Expression<int>? yearOfStudy,
    Expression<String>? imageUrl,
    Expression<String>? interests,
    Expression<String>? bio,
    Expression<int>? starsGiven,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (faculty != null) 'faculty': faculty,
      if (yearOfStudy != null) 'year_of_study': yearOfStudy,
      if (imageUrl != null) 'image_url': imageUrl,
      if (interests != null) 'interests': interests,
      if (bio != null) 'bio': bio,
      if (starsGiven != null) 'stars_given': starsGiven,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? age,
    Value<String>? faculty,
    Value<int>? yearOfStudy,
    Value<String>? imageUrl,
    Value<List<String>>? interests,
    Value<String>? bio,
    Value<int>? starsGiven,
    Value<int>? rowid,
  }) {
    return UserProfilesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      faculty: faculty ?? this.faculty,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      imageUrl: imageUrl ?? this.imageUrl,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      starsGiven: starsGiven ?? this.starsGiven,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (faculty.present) {
      map['faculty'] = Variable<String>(faculty.value);
    }
    if (yearOfStudy.present) {
      map['year_of_study'] = Variable<int>(yearOfStudy.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (interests.present) {
      map['interests'] = Variable<String>(
        $UserProfilesTableTable.$converterinterests.toSql(interests.value),
      );
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (starsGiven.present) {
      map['stars_given'] = Variable<int>(starsGiven.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('faculty: $faculty, ')
          ..write('yearOfStudy: $yearOfStudy, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('interests: $interests, ')
          ..write('bio: $bio, ')
          ..write('starsGiven: $starsGiven, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SwipeActionsTableTable extends SwipeActionsTable
    with TableInfo<$SwipeActionsTableTable, SwipeActionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SwipeActionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, profileId, action, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'swipe_actions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SwipeActionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SwipeActionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SwipeActionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $SwipeActionsTableTable createAlias(String alias) {
    return $SwipeActionsTableTable(attachedDatabase, alias);
  }
}

class SwipeActionsTableData extends DataClass
    implements Insertable<SwipeActionsTableData> {
  final int id;
  final String profileId;
  final String action;
  final DateTime timestamp;
  const SwipeActionsTableData({
    required this.id,
    required this.profileId,
    required this.action,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['action'] = Variable<String>(action);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  SwipeActionsTableCompanion toCompanion(bool nullToAbsent) {
    return SwipeActionsTableCompanion(
      id: Value(id),
      profileId: Value(profileId),
      action: Value(action),
      timestamp: Value(timestamp),
    );
  }

  factory SwipeActionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SwipeActionsTableData(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      action: serializer.fromJson<String>(json['action']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<String>(profileId),
      'action': serializer.toJson<String>(action),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  SwipeActionsTableData copyWith({
    int? id,
    String? profileId,
    String? action,
    DateTime? timestamp,
  }) => SwipeActionsTableData(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    action: action ?? this.action,
    timestamp: timestamp ?? this.timestamp,
  );
  SwipeActionsTableData copyWithCompanion(SwipeActionsTableCompanion data) {
    return SwipeActionsTableData(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      action: data.action.present ? data.action.value : this.action,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SwipeActionsTableData(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('action: $action, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, action, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SwipeActionsTableData &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.action == this.action &&
          other.timestamp == this.timestamp);
}

class SwipeActionsTableCompanion
    extends UpdateCompanion<SwipeActionsTableData> {
  final Value<int> id;
  final Value<String> profileId;
  final Value<String> action;
  final Value<DateTime> timestamp;
  const SwipeActionsTableCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.action = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  SwipeActionsTableCompanion.insert({
    this.id = const Value.absent(),
    required String profileId,
    required String action,
    this.timestamp = const Value.absent(),
  }) : profileId = Value(profileId),
       action = Value(action);
  static Insertable<SwipeActionsTableData> custom({
    Expression<int>? id,
    Expression<String>? profileId,
    Expression<String>? action,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (action != null) 'action': action,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  SwipeActionsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? profileId,
    Value<String>? action,
    Value<DateTime>? timestamp,
  }) {
    return SwipeActionsTableCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SwipeActionsTableCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('action: $action, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTableTable userProfilesTable =
      $UserProfilesTableTable(this);
  late final $SwipeActionsTableTable swipeActionsTable =
      $SwipeActionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfilesTable,
    swipeActionsTable,
  ];
}

typedef $$UserProfilesTableTableCreateCompanionBuilder =
    UserProfilesTableCompanion Function({
      required String id,
      required String name,
      required int age,
      required String faculty,
      required int yearOfStudy,
      required String imageUrl,
      required List<String> interests,
      required String bio,
      Value<int> starsGiven,
      Value<int> rowid,
    });
typedef $$UserProfilesTableTableUpdateCompanionBuilder =
    UserProfilesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> age,
      Value<String> faculty,
      Value<int> yearOfStudy,
      Value<String> imageUrl,
      Value<List<String>> interests,
      Value<String> bio,
      Value<int> starsGiven,
      Value<int> rowid,
    });

class $$UserProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faculty => $composableBuilder(
    column: $table.faculty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearOfStudy => $composableBuilder(
    column: $table.yearOfStudy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get interests => $composableBuilder(
    column: $table.interests,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get starsGiven => $composableBuilder(
    column: $table.starsGiven,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faculty => $composableBuilder(
    column: $table.faculty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearOfStudy => $composableBuilder(
    column: $table.yearOfStudy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interests => $composableBuilder(
    column: $table.interests,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bio => $composableBuilder(
    column: $table.bio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get starsGiven => $composableBuilder(
    column: $table.starsGiven,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get faculty =>
      $composableBuilder(column: $table.faculty, builder: (column) => column);

  GeneratedColumn<int> get yearOfStudy => $composableBuilder(
    column: $table.yearOfStudy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get interests =>
      $composableBuilder(column: $table.interests, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<int> get starsGiven => $composableBuilder(
    column: $table.starsGiven,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTableTable,
          UserProfilesTableData,
          $$UserProfilesTableTableFilterComposer,
          $$UserProfilesTableTableOrderingComposer,
          $$UserProfilesTableTableAnnotationComposer,
          $$UserProfilesTableTableCreateCompanionBuilder,
          $$UserProfilesTableTableUpdateCompanionBuilder,
          (
            UserProfilesTableData,
            BaseReferences<
              _$AppDatabase,
              $UserProfilesTableTable,
              UserProfilesTableData
            >,
          ),
          UserProfilesTableData,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableTableManager(
    _$AppDatabase db,
    $UserProfilesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String> faculty = const Value.absent(),
                Value<int> yearOfStudy = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<List<String>> interests = const Value.absent(),
                Value<String> bio = const Value.absent(),
                Value<int> starsGiven = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesTableCompanion(
                id: id,
                name: name,
                age: age,
                faculty: faculty,
                yearOfStudy: yearOfStudy,
                imageUrl: imageUrl,
                interests: interests,
                bio: bio,
                starsGiven: starsGiven,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int age,
                required String faculty,
                required int yearOfStudy,
                required String imageUrl,
                required List<String> interests,
                required String bio,
                Value<int> starsGiven = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesTableCompanion.insert(
                id: id,
                name: name,
                age: age,
                faculty: faculty,
                yearOfStudy: yearOfStudy,
                imageUrl: imageUrl,
                interests: interests,
                bio: bio,
                starsGiven: starsGiven,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTableTable,
      UserProfilesTableData,
      $$UserProfilesTableTableFilterComposer,
      $$UserProfilesTableTableOrderingComposer,
      $$UserProfilesTableTableAnnotationComposer,
      $$UserProfilesTableTableCreateCompanionBuilder,
      $$UserProfilesTableTableUpdateCompanionBuilder,
      (
        UserProfilesTableData,
        BaseReferences<
          _$AppDatabase,
          $UserProfilesTableTable,
          UserProfilesTableData
        >,
      ),
      UserProfilesTableData,
      PrefetchHooks Function()
    >;
typedef $$SwipeActionsTableTableCreateCompanionBuilder =
    SwipeActionsTableCompanion Function({
      Value<int> id,
      required String profileId,
      required String action,
      Value<DateTime> timestamp,
    });
typedef $$SwipeActionsTableTableUpdateCompanionBuilder =
    SwipeActionsTableCompanion Function({
      Value<int> id,
      Value<String> profileId,
      Value<String> action,
      Value<DateTime> timestamp,
    });

class $$SwipeActionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SwipeActionsTableTable> {
  $$SwipeActionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SwipeActionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SwipeActionsTableTable> {
  $$SwipeActionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SwipeActionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SwipeActionsTableTable> {
  $$SwipeActionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$SwipeActionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SwipeActionsTableTable,
          SwipeActionsTableData,
          $$SwipeActionsTableTableFilterComposer,
          $$SwipeActionsTableTableOrderingComposer,
          $$SwipeActionsTableTableAnnotationComposer,
          $$SwipeActionsTableTableCreateCompanionBuilder,
          $$SwipeActionsTableTableUpdateCompanionBuilder,
          (
            SwipeActionsTableData,
            BaseReferences<
              _$AppDatabase,
              $SwipeActionsTableTable,
              SwipeActionsTableData
            >,
          ),
          SwipeActionsTableData,
          PrefetchHooks Function()
        > {
  $$SwipeActionsTableTableTableManager(
    _$AppDatabase db,
    $SwipeActionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SwipeActionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SwipeActionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SwipeActionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => SwipeActionsTableCompanion(
                id: id,
                profileId: profileId,
                action: action,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String profileId,
                required String action,
                Value<DateTime> timestamp = const Value.absent(),
              }) => SwipeActionsTableCompanion.insert(
                id: id,
                profileId: profileId,
                action: action,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SwipeActionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SwipeActionsTableTable,
      SwipeActionsTableData,
      $$SwipeActionsTableTableFilterComposer,
      $$SwipeActionsTableTableOrderingComposer,
      $$SwipeActionsTableTableAnnotationComposer,
      $$SwipeActionsTableTableCreateCompanionBuilder,
      $$SwipeActionsTableTableUpdateCompanionBuilder,
      (
        SwipeActionsTableData,
        BaseReferences<
          _$AppDatabase,
          $SwipeActionsTableTable,
          SwipeActionsTableData
        >,
      ),
      SwipeActionsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableTableManager get userProfilesTable =>
      $$UserProfilesTableTableTableManager(_db, _db.userProfilesTable);
  $$SwipeActionsTableTableTableManager get swipeActionsTable =>
      $$SwipeActionsTableTableTableManager(_db, _db.swipeActionsTable);
}
