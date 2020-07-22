import 'package:locationreminder/modules/add_location/models/add_new_location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
class SqliteDatabaseService{
  static final SqliteDatabaseService instance=SqliteDatabaseService._internal();
  SqliteDatabaseService._internal();
  AddANewLocation addANewLocation;
  static Database db;
  Future<Database> get database async {
    if (db != null) return db;
    // lazily instantiate the db the first time it is accessed
    //await deleteDatabase(join(await getDatabasesPath(), 'rentzol_database.db'));
    db = await openDatabase(
        join(await getDatabasesPath(), 'rentzol_database.db'),
        onCreate: (db, version) {
          return db.execute("CREATE TABLE "
              "locations_info_detail (id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "name TEXT, description TEXT, latitude TEXT,longitude TEXT,creation_date TEXT,image TEXT)");
        },
        version: 2
    );
    return db;
  }
  /*
    Insert data in usersInfo table for first time users in the day if doesnot exist
 */
  @override
  Future<bool> insertUserInfo(AddANewLocation addANewLocation)async {
    Database database=await instance.database;
    await database.insert("locations_info_detail", addANewLocation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  @override
  Future<List<AddANewLocation>> getAll()async {
    Database database=await instance.database;
    List<Map<String,dynamic>> maps= await database.query("locations_info_detail");
    maps=maps.where((element){
      return element["name"]!=null && element["image"]!=null;
    }).toList();

    return List.generate(maps.length, (i) {
      return AddANewLocation(
        id: maps[i]['id'],
            name: maps[i]['name'],
            description: maps[i]['description'],
            image: maps[i]["image"],
        creation_date: maps[i]["creation_date"]
        );
    });
  }

  /*
    Update data in usersInfo table for first time users in the day if doesnot exist
 */
  @override
  Future<bool> updateUserInfo(AddANewLocation addANewLocation)async {
    Database database = await instance.database;
    await database.update("locations_info_detail", addANewLocation.toMap(), where: "id=?");
    return true;
  }

  /*
    Insert data in usersInfo table for first time users in the day if doesnot exist
 */
  @override
  Future<void> deleteUserInfo(int id)async {
    Database database = await instance.database;
    await database.delete("locations_info_detail",where: "id=?",whereArgs: [id]);
  }
}