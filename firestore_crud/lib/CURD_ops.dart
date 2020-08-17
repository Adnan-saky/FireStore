import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CURD_methos {
  // Add or create data

  Future<void> addData(StudData) async {
    await Firestore.instance.collection("Data").add(StudData).catchError((e) {
      print(e);
    });
  }

  getData() async{
    return await Firestore.instance.collection("Data").snapshots();
  }

  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection('Data')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection('Data')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
