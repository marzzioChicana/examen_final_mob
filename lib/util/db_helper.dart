import 'package:examen_final/model/super_hero_favorite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;

  Database ? dbExamenFinal;

  static final DbHelper dbHelper = DbHelper.internal();
  DbHelper.internal();
  factory DbHelper() {
    return dbHelper;
  }

  Future<Database> openDb() async {
    dbExamenFinal ??= await openDatabase(join(await getDatabasesPath(),
    'examen_final.db'),
    onCreate: (database, version) {
      database.execute('CREATE TABLE superhero(id INTEGER PRIMARY KEY, image TEXT, name TEXT)');
    }, version: version);

    return dbExamenFinal!;
  }

  Future<int> insertSuperHero(SuperHeroFavorite superHeroFavorite) async {
    int id = await this.dbExamenFinal!.insert(
      'superhero', superHeroFavorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    
    return id;
  }

  Future<List<SuperHeroFavorite>> getSuperHeroesFavorites() async {
    final List<Map<String, dynamic>> maps = await dbExamenFinal!.query('superhero');

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return SuperHeroFavorite(
          maps[i]['id'],
          maps[i]['image'],
          maps[i]['name'],
        );
      });
    } else {
      return <SuperHeroFavorite>[];
    }
  }

  Future<void> deleteSuperHeroById(int id) async {
    await dbExamenFinal!.delete(
      'superhero',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}