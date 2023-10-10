import 'package:account_manager/Controller/account_controller.dart';
import 'package:account_manager/Controller/transaction_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transection extends StatelessWidget {
  int ac_name;

  Transection(this.ac_name);

  TextEditingController amount_controller = TextEditingController();
  TextEditingController reason_controller = TextEditingController();

  account_controller ac = Get.put(account_controller());
  transaction_controller tc = Get.put(transaction_controller());

  Widget build(BuildContext context) {
    tc.GetTransactionDatabase().then((value) {
      return tc.GetData(ac_name).then((value) => tc.SelectQuary());
    });
    return Scaffold(
      appBar:
          AppBar(title: Text("${ac.DataList[ac_name]['acname']}"), actions: [
        IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return TransectionDialog();
                },
              );
            },
            icon: Icon(Icons.add_circle_outlined)),
        SizedBox(
          width: 10,
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        SizedBox(
          width: 10,
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ]),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.black12,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Particular",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Credit(₹)",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Debit(₹)",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(child: Obx(() => ListTransection()))
              ],
            ),
          ),
          Card(
            child: Container(
              height: 80,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Credit(↑)",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(() => Text("₹ ${tc.amount[ac_name]['credit']}",
                            style: TextStyle(fontWeight: FontWeight.bold)))
                      ],
                    ),
                  )),
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Debit(↓)",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(() => Text("₹ ${tc.amount[ac_name]['debit']}",
                            style: TextStyle(fontWeight: FontWeight.bold)))
                      ],
                    ),
                  )),
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    color: Colors.purple,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Balance",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Obx(() => Text(
                              "₹ ${tc.amount[ac_name]['balance']}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ListTransection() {
    return ListView.builder(
      itemCount: tc.Data.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTapDown: (details) {
            showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                    0, details.globalPosition.dy, details.globalPosition.dx, 0),
                items: [
                  PopupMenuItem(
                      onTap: () {
                        tc.date_controller.text = tc.Data[index]['date'];
                        tc.istransactiontype.value =
                            tc.Data[index]['transaction_type'];
                        amount_controller.text = tc.Data[index]['amount'];
                        reason_controller.text = tc.Data[index]['reason'];
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => EditTransectionDialog(index));
                      },
                      child: Text("Edit")),
                  PopupMenuItem(
                      onTap: () {
                        tc.DeleteData(index: tc.Data[index]['id'])
                            .then((value) => tc.GetData(ac_name))
                            .then((value) =>
                                tc.Totalall(tc.amount[ac_name]['id']))
                            .then((value) => tc.SelectQuary());
                      },
                      child: Text("Delete"))
                ]);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            color: (index % 2 == 1) ? Colors.black12 : Colors.white,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Obx(() => Text(
                          tc.Data[index]['date'],
                          style: TextStyle(
                              fontSize: 15,
                              color: (tc.Data[index]['transaction_type'] ==
                                      "Credit")
                                  ? Colors.green
                                  : Colors.red),
                        ))),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Obx(() => Text(
                          tc.Data[index]['reason'],
                          style: TextStyle(
                              fontSize: 15,
                              color: (tc.Data[index]['transaction_type'] ==
                                      "Credit")
                                  ? Colors.green
                                  : Colors.red),
                          softWrap: true,
                        ))),
                Spacer(),
                Expanded(
                    child: Obx(
                        () => (tc.Data[index]['transaction_type'] == "Credit")
                            ? Text(
                                tc.Data[index]['amount'],
                                style: TextStyle(
                                    fontSize: 15,
                                    color: (tc.Data[index]
                                                ['transaction_type'] ==
                                            "Credit")
                                        ? Colors.green
                                        : Colors.red),
                                softWrap: true,
                              )
                            : Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: (tc.Data[index]
                                                ['transaction_type'] ==
                                            "Credit")
                                        ? Colors.green
                                        : Colors.red),
                              ))),
                Spacer(),
                Expanded(
                    child: Obx(
                        () => (tc.Data[index]['transaction_type'] == "Debit")
                            ? Text(
                                tc.Data[index]['amount'],
                                style: TextStyle(
                                    fontSize: 15,
                                    color: (tc.Data[index]
                                                ['transaction_type'] ==
                                            "Credit")
                                        ? Colors.green
                                        : Colors.red),
                                softWrap: true,
                              )
                            : Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: (tc.Data[index]
                                                ['transaction_type'] ==
                                            "Credit")
                                        ? Colors.green
                                        : Colors.red),
                              ))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget TransectionDialog() {
    return AlertDialog(
      content: SizedBox(
        height: 350,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 300,
              color: Colors.purple,
              child: Text(
                "Add transaction",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            TextField(
              controller: tc.date_controller,
              onTap: () {
                tc.PickDate();
              },
              keyboardType: TextInputType.none,
              decoration: InputDecoration(labelText: "Transaction Date"),
            ),
            Row(
              children: [
                Text("Transaction type: "),
                Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                            activeColor: Colors.purple,
                            value: "Credit",
                            groupValue: tc.istransactiontype.value,
                            onChanged: (value) {
                              tc.Transaction_Type(value: value);
                            },
                          ),
                        ),
                        Text("Credit(+)"),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                            value: "Debit",
                            groupValue: tc.istransactiontype.value,
                            onChanged: (value) {
                              tc.Transaction_Type(value: value);
                            },
                          ),
                        ),
                        Text("Debit(-)"),
                      ],
                    )
                  ],
                ),
              ],
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
              controller: amount_controller,
            ),
            TextField(
              controller: reason_controller,
              decoration: InputDecoration(labelText: "Particular"),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
            style: ButtonStyle(
                side: MaterialStatePropertyAll(
                    BorderSide(width: 2, color: Colors.purple))),
            onPressed: () {
              tc.GetData(ac_name);
              tc.date_controller.text = "";
              tc.istransactiontype.value = "";
              amount_controller.clear();
              reason_controller.clear();
              Navigator.pop(Get.context!);
            },
            child: Text("CANCEL")),
        ElevatedButton(
            onPressed: () {
              if (tc.date_controller != "" &&
                  tc.istransactiontype.value != "" &&
                  amount_controller.text != "") {
                tc.InsertData(
                    index: ac_name,
                    date: tc.date_controller.text,
                    type: tc.istransactiontype,
                    amount: amount_controller.text,
                    reson: (reason_controller.text != "")
                        ? reason_controller.text
                        : "No reason");
                tc.GetData(ac_name)
                    .then((value) => tc.Totalall(tc.amount[ac_name]['id']))
                    .then((value) => tc.SelectQuary());
                tc.date_controller.text = "";
                tc.istransactiontype.value = "";
                amount_controller.clear();
                reason_controller.clear();
                Get.back();
              } else {
                Get.snackbar("Error", "Fill all required field",
                    colorText: Colors.white,
                    backgroundColor: Colors.purple,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(milliseconds: 1000),
                    margin: EdgeInsets.all(50));
              }
            },
            child: Text(
              "ADD",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  Widget EditTransectionDialog(int index) {
    return AlertDialog(
      content: SizedBox(
        height: 350,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 300,
              color: Colors.purple,
              child: Text(
                "Edit transaction",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            TextField(
              controller: tc.date_controller,
              onTap: () {
                tc.PickDate();
              },
              keyboardType: TextInputType.none,
              decoration: InputDecoration(labelText: "Transaction Date"),
            ),
            Row(
              children: [
                Text("Transaction type: "),
                Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                            activeColor: Colors.purple,
                            value: "Credit",
                            groupValue: tc.istransactiontype.value,
                            onChanged: (value) {
                              tc.Transaction_Type(value: value);
                            },
                          ),
                        ),
                        Text("Credit(+)"),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Radio(
                            value: "Debit",
                            groupValue: tc.istransactiontype.value,
                            onChanged: (value) {
                              tc.Transaction_Type(value: value);
                            },
                          ),
                        ),
                        Text("Debit(-)"),
                      ],
                    )
                  ],
                ),
              ],
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
              controller: amount_controller,
            ),
            TextField(
              controller: reason_controller,
              decoration: InputDecoration(labelText: "Particular"),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
            style: ButtonStyle(
                side: MaterialStatePropertyAll(
                    BorderSide(width: 2, color: Colors.purple))),
            onPressed: () {
              tc.GetData(ac_name);
              tc.date_controller.text = "";
              tc.istransactiontype.value = "";
              amount_controller.clear();
              reason_controller.clear();
              Navigator.pop(Get.context!);
            },
            child: Text("CANCEL")),
        ElevatedButton(
            onPressed: () {
              if (tc.date_controller != "" &&
                  tc.istransactiontype.value != "" &&
                  amount_controller.text != "") {
                tc.EditData(
                    index: tc.Data[index]['id'],
                    date: tc.date_controller.text,
                    type: tc.istransactiontype,
                    amount: amount_controller.text,
                    reson: (reason_controller.text != "")
                        ? reason_controller.text
                        : "No reason");
                tc.GetData(ac_name)
                    .then((value) => tc.Totalall(tc.amount[ac_name]['id']))
                    .then((value) => tc.SelectQuary());
                tc.date_controller.text = "";
                tc.istransactiontype.value = "";
                amount_controller.clear();
                reason_controller.clear();
                Get.back();
              } else {
                Get.snackbar("Error", "Fill all required field",
                    colorText: Colors.white,
                    backgroundColor: Colors.purple,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(milliseconds: 1000),
                    margin: EdgeInsets.all(50));
              }
            },
            child: Text(
              "SAVE",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
