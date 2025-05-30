import 'package:flutter/material.dart';
import 'package:foxbit_hiring_test_template/app/application.dart';
import 'package:foxbit_hiring_test_template/core/di/setup_di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SetupDi.setup();
  runApp(FoxbitApp());
}
