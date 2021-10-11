import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pelpay_flutter/models/customer.dart';
import 'package:pelpay_flutter/models/transaction.dart';
import 'package:pelpay_flutter/pelpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PELPAY'),
        ),
        body: Center(
          child: MaterialButton(
            child: const Text('Test SDK Payment N50'),
            elevation: 4,
            color: Colors.green,
            highlightElevation: 2,
            padding: const EdgeInsets.all(20.0),
            onPressed: () {
              testPayment();
            },
          ),
        ),
      ),
    );
  }

  Future<void> testPayment() async {
    try {
      var result = await PelpayFlutter.makePayment(
          clientId: "Ken0000004",
          clientSecret: "d36eb5dd-a89f-411a-b024-4cdc11673c11",
          transaction: Transaction(
            integrationKey: "a6ccab0e-157d-4fb7-b15d-ddb7cd149153",
            amount: 50,
            merchantReference: UniqueKey().toString(),
            narration: "Sample payment from Flutter",
            customer: Customer(
                    customerId: "xxx",
                    customerLastName: "olajuwon",
                    customerFirstName: "adeoye",
                    customerEmail: "olajuwon@yopmail.com",
                    customerPhoneNumber: "07039544295",
                    customerAddress: "Lekki 1, Road",
                    customerCity: "Lagos",
                    customerStateCode: "LA",
                    customerPostalCode: "123456")
                .toMap(),
          ),
          isProduction: false);

      if (result.isTransactionSuccessful) {
        // ignore: avoid_print
        print("Successful, Your Advice Reference: ${result.adviceReference}");
      } else {
        // ignore: avoid_print
        print(result.errorMessage);
      }
    } on PlatformException catch (e) {
      var error = "Pelpay Error: '${e.message}'.";
      // ignore: avoid_print
      print(error);
    }
  }
}
