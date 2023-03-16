import 'dart:io';
import 'package:crud_db/model/city_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'crud_db.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "crud_db.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data =
      await rootBundle.load(join('assets', 'crud_db.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<Map<String, Object?>>> getUserListFromUserTable() async {
    Database db = await initDatabase();
    List<Map<String, Object?>> data = await db.rawQuery(
        'SELECT Tbl_User.Name as UserName,'
            'Tbl_City.Name as CityName,'
            'Age ,'
            'UserID '
            'FROM Tbl_User '
            'INNER JOIN Tbl_City '
            'ON '
            'Tbl_User.CityID = Tbl_City.CityID');
    return data;
  }

  Future<List<CityModel>> getCityList() async {
    Database db = await initDatabase();
    List<Map<String, Object?>> data = await db.rawQuery('Select * from Tbl_City');
    List<CityModel> cityList = [];
    for(int i=0; i<data.length; i++) {
      CityModel model = CityModel();
      model.CityID = int.parse(data[i]['CityID'].toString());
      model.Name = data[i]['Name'].toString();
      cityList.add(model);
    }
    return cityList;
  }

  Future<int> insertUserDetail(map) async {
    Database db = await initDatabase();
    int userId = await db.insert('Tbl_User', map);
    return userId;
  }

  Future<int> updateUserDetail(map,id) async {
    Database db = await initDatabase();
    int userId = await db.update('Tbl_User', map,where: 'UserID = ?',whereArgs: [id]);
    return userId;
  }

  Future<int> deleteUserDetail(id) async {
    Database db = await initDatabase();
    int userId = await db.delete('Tbl_User',where: 'UserID = ?',whereArgs: [id]);
    return userId;
  }
}



