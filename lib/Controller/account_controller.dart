import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class account_controller extends GetxController {
  Database? ac_Database;

  var dbName = "Account.db";
  var dbVersion = 1;
  var dbTable = "Accounts";

  RxList<dynamic> DataList = [].obs;

  Future GetDatabase() async {
    if (ac_Database != null) {
      return ac_Database;
    } else {
      var dbDir = await getDatabasesPath();
      String path = join(dbDir, dbName);
      ac_Database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) {
        db.execute(
            """CREATE TABLE $dbTable (id INTEGER PRIMARY KEY AUTOINCREMENT,acname TEXT NOT NULL)""");
      });
    }
  }

  Future GetData() async {
    String SelectQuary = """SELECT*FROM $dbTable""";
    DataList.value = await ac_Database!.rawQuery(SelectQuary);
  }

  Future Datainsert({required String name}) async{
    String InsertData = """INSERT INTO $dbTable VALUES(NULL,'$name')""";
    ac_Database!.rawInsert(InsertData);
  }

  Future UpdateData({required String updateName, required int index})async {
    String UpdateQuary =
        """UPDATE $dbTable SET acname='$updateName' WHERE id=$index;""";
    ac_Database!.rawUpdate(UpdateQuary).then((value) => GetData());
  }

 Future DeleteData({required int index}) async{
    String DeleteQuary = """DELETE FROM $dbTable WHERE id=$index;""";
    ac_Database!.rawDelete(DeleteQuary).then((value) => GetData());
  }
}
