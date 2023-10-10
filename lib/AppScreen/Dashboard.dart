import 'package:account_manager/AppScreen/Transection.dart';
import 'package:account_manager/Controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/account_controller.dart';

class Dashboard extends StatelessWidget {
  TextEditingController ac_nameController = TextEditingController();

  var controller = Get.put(account_controller());
  transaction_controller tc = Get.put(transaction_controller());

  Widget build(BuildContext context) {
    controller.GetDatabase()
        .then((value) => tc.GetTotaldb())
        .then((value) => controller.GetData())
        .then((value) => tc.SelectQuary());
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
      ]),
      body: Obx(() {
        return ListOfAccount();
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            AddAccountDialog();
          },
          child: Icon(Icons.add)),
    );
  }

  Widget ListOfAccount() {
    return ListView.builder(
      itemCount: controller.DataList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.to(Transection(index));
          },
          child: Card(
            child: Container(
              margin: EdgeInsets.all(10),
              height: 150,
              width: Get.width * 0.9,
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      "${controller.DataList[index]['acname']}",
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          ac_nameController.text =
                          controller.DataList[index]['acname'];
                          UpdateDialog(index);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.purple,
                        )),
                    IconButton(
                        onPressed: () {
                          controller.DeleteData(
                              index: controller.DataList[index]['id']).then((
                              value) =>
                              tc.DeleteTable(index: index).then((value) =>
                                  controller.GetData().then((value) =>
                                      tc.DeleteAmount(tc.amount[index]['id'])))).then((value) => tc.SelectQuary());

                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.purple,
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Credit(↑)",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Obx(() =>
                                      Text(
                                        "₹ ${tc.amount[index]['credit']}",
                                        style: TextStyle(fontSize: 15),
                                      ))
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Debit(↓)",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Obx(() =>
                                      Text(
                                        "₹ ${tc.amount[index]['debit']}",
                                        style: TextStyle(fontSize: 15),
                                      ))
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Balance",
                                  style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Obx(() =>
                                    Text(
                                      "₹ ${tc.amount[index]['balance']}",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ))
                              ],
                            ),
                          ))
                    ],
                  ),
                )
              ]),
            ),
          ),
        );
      },
    );
  }

  Future AddAccountDialog() {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        titleStyle: TextStyle(fontSize: 0),
        onConfirm: () {
          controller.Datainsert(name: ac_nameController.text).then((value) =>
              controller.GetData()
                  .then((value) => tc.GetTotaldb())
                  .then((value) => tc.InsertAmountData())
                  .then((value) => tc.SelectQuary()));
          ac_nameController.clear();
          Get.back();
        },
        textConfirm: "ADD",
        confirmTextColor: Colors.white,
        onCancel: () {
          ac_nameController.clear();
        },
        content: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 300,
              color: Colors.purple,
              child: Text("Add new account",
                  style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              child: TextField(
                controller: ac_nameController,
                decoration: InputDecoration(
                  labelText: "Account name",
                ),
              ),
            ),
          ],
        ));
  }

  Future UpdateDialog(int index) {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        titleStyle: TextStyle(fontSize: 0),
        onConfirm: () {
          controller.UpdateData(
              updateName: '${ac_nameController.text}',
              index: controller.DataList[index]['id']);
          ac_nameController.clear();
          Get.back();
        },
        textConfirm: "SAVE",
        confirmTextColor: Colors.white,
        onCancel: () {
          ac_nameController.clear();
        },
        content: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 300,
              color: Colors.purple,
              child: Text("Update account",
                  style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              child: TextField(
                controller: ac_nameController,
                decoration: InputDecoration(labelText: "Account name"),
              ),
            ),
          ],
        ));
  }
}
