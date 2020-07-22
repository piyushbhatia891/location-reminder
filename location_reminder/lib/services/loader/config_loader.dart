import 'package:locationreminder/services/sqlite/sqlite_database_service.dart';

class ConfigLoader{
  static final ConfigLoader _instance=ConfigLoader._internal();
  SqliteDatabaseService sqliteDatabaseService;
  factory ConfigLoader() {
    return _instance;
  }

  ConfigLoader._internal(){
    sqliteDatabaseService=SqliteDatabaseService.instance;
  }

}