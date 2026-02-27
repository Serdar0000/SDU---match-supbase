import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Конвертер для хранения списка строк (интересов) в виде JSON в базе данных
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return List<String>.from(json.decode(fromDb));
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}

// Таблица для кэширования профилей
class UserProfilesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get faculty => text()();
  IntColumn get yearOfStudy => integer()();
  TextColumn get imageUrl => text()();
  TextColumn get interests => text().map(const StringListConverter())();
  TextColumn get bio => text()();
  IntColumn get starsGiven => integer().withDefault(const Constant(0))(); // Супер-лайки

  @override
  Set<Column> get primaryKey => {id};
}

// Таблица для сохранения действий свайпа (лайк/дизлайк)
class SwipeActionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get action => text()(); // 'like' или 'pass'
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [UserProfilesTable, SwipeActionsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Увеличиваем версию схемы

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(swipeActionsTable);
        }
      },
    );
  }

  // Методы для работы со свайпами
  Future<int> saveSwipeAction(String profileId, String action) {
    return into(swipeActionsTable).insert(
      SwipeActionsTableCompanion.insert(
        profileId: profileId,
        action: action,
      ),
    );
  }

  Future<List<SwipeActionsTableData>> getAllSwipes() {
    return select(swipeActionsTable).get();
  }

  Future<List<String>> getSwipedProfileIds() async {
    final query = selectOnly(swipeActionsTable)..addColumns([swipeActionsTable.profileId]);
    final result = await query.map((row) => row.read(swipeActionsTable.profileId)!).get();
    return result;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sdu_match_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
