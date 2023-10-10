import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class transaction_controller extends GetxController {
  Database? transaction_database;
  Database? _database;
  var dbName1 = 'total.db';
  var dbVersion1 = 1;
  var dbTableName1 = "totals";
  var dbName = 'Transaction.db';
  var dbVersion = 1;
  var dbTableName = "Transactions";
  var istransactiontype = "".obs;
  var Data = [].obs;
  var Creditamount = "0";
  var Debitamount = "0";
  var Balance = "0";
  var amount = [].obs;
  TextEditingController date_controller = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));

  Transaction_Type({required var value}) {
    istransactiontype.value = value;
    update();
  }

  Future GetTransactionDatabase() async {
    if (transaction_database != null) {
      return transaction_database;
    } else {
      var dirdatabase = await getDatabasesPath();
      String path = join(dirdatabase, dbName);
      transaction_database = await openDatabase(path, version: dbVersion,
          onCreate: (Database db, int version) {
        db.execute(
            """CREATE TABLE $dbTableName (id INTEGER PRIMARY KEY AUTOINCREMENT,date TEXT NOT NULL,transaction_type TEXT NOT NULL,amount TEXT NOT NULL,reason TEXT,table_id INTEGER)""");
      });
    }
  }

  InsertData(
      {required var date,
      required var type,
      required var amount,
      required var reson,
      required int index}) {
    String InsertQuary =
        """INSERT INTO $dbTableName VALUES (NULL,'$date','$type','$amount','$reson',$index)""";
    transaction_database!.rawInsert(InsertQuary);
  }

  Future GetData(int index) async {
    String GetDataQuary =
        """SELECT * FROM $dbTableName WHERE table_id=$index """;
    Data.value = await transaction_database!.rawQuery(GetDataQuary);
  }

  Future EditData(
      {required var date,
      required var type,
      required var amount,
      required var reson,
      required int index}) async {
    String EditQuary =
        """UPDATE $dbTableName SET date='$date', transaction_type='$type',amount='$amount',reason='$reson' WHERE id=$index;""";
    transaction_database!.rawUpdate(EditQuary);
  }

  Future DeleteData({required int index}) async {
    String DeleteQuary = """DELETE FROM $dbTableName WHERE id=$index""";
    transaction_database!.rawDelete(DeleteQuary);
  }

  Future DeleteTable({required int index}) async {
    String DeleteQuary = """DELETE FROM $dbTableName WHERE table_id=$index""";
    transaction_database!.rawDelete(DeleteQuary);
  }

  PickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      date_controller.text =
          DateFormat('dd-MM-yyyy').format(pickedDate).toString();
    } else {
      date_controller.text =
          DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    }
  }

  Future GetTotaldb() async {
    if (_database != null) {
      return _database;
    } else {
      var dirdatabase = await getDatabasesPath();
      String path = join(dirdatabase, dbName1);
      _database = await openDatabase(path, version: dbVersion1,
          onCreate: (Database db, int version) {
        db.execute(
            """CREATE TABLE $dbTableName1 (id INTEGER PRIMARY KEY AUTOINCREMENT,credit TEXT,debit TEXT,balance TEXT)""");
      });
    }
  }

  Future Totalall(int id) async{
    double credit = 0;
    double debit = 0;
    for (int i = 0; i < Data.length; i++) {
      if (Data[i]['transaction_type'] == "Credit") {
        credit = double.parse(Data[i]['amount']) + credit;
      } else {
        debit = double.parse(Data[i]['amount']) + debit;
      }
    }
    Creditamount = credit.toStringAsFixed(2);
    Debitamount = debit.toStringAsFixed(2);
    double total = credit - debit;
    Balance = total.toStringAsFixed(2);
    String UpdateQuary =
        """UPDATE $dbTableName1 SET credit='$Creditamount',debit='$Debitamount',balance='$Balance' WHERE id=$id;""";
    _database!.rawUpdate(UpdateQuary);
  }

  Future SelectQuary() async {
    String ShowAmount = """SELECT * FROM $dbTableName1""";
    amount.value = await _database!.rawQuery(ShowAmount);
  }

  Future DeleteAmount(int id) async {
    String Delete = """DELETE FROM $dbTableName1 WHERE id=$id;""";
    _database!.rawDelete(Delete);
  }

  Future InsertAmountData() async {
    String InsertQuary =
        """INSERT INTO $dbTableName1 VALUES (NULL,'0','0','0')""";
    _database!.rawInsert(InsertQuary);
  }
}
