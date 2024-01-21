import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FirebaseFirestore, QuerySnapshot;
import 'package:flutter/material.dart';
import 'package:lab3/services/auth_service.dart';

import '../model/exam.dart';

class dbService {
  final firestore = FirebaseFirestore.instance;

  void addExam(String exam, DateTime date, TimeOfDay time) async {
    if(AuthService.user == null){
      return;
    }
    final toAdd = <String, dynamic>{
      "timestamp": FieldValue.serverTimestamp(),
      "user": AuthService.user?.uid,
      "title": exam,
      "day": date.day,
      "month": date.month,
      "year": date.year,
      "minute": time.minute,
      "hour": time.hour,
    };

    await firestore.collection("exams").add(toAdd);
  }

  Future<List<Exam>> getExams() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection("exams").where("user",isEqualTo: AuthService.user?.uid).get();
    print("eve");
    print(snapshot.docs
        .map((docSnapshot) => Exam.fromDocument(docSnapshot))
        .toList());
    return snapshot.docs
        .map((docSnapshot) => Exam.fromDocument(docSnapshot))
        .toList();


  }
}
