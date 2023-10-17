import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/halamanlogin.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Futsal Time',
            home: DesainHalamanLogin(),
          )));
}
