import 'package:firestore_crud/fireStore.dart';
import 'package:flutter/material.dart';
import 'package:firestore_crud/main.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: fireStore(),
    ),
  );
}
