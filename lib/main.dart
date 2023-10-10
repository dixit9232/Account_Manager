import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AppScreen/Dashboard.dart';

void main() {
  runApp(GetMaterialApp(
    home: Dashboard(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.purple),
  ));
}
