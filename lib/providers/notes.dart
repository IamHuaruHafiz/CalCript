import 'package:calcript/utilities/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final collection = FirebaseFirestore.instance.collection("note");

class Notes with ChangeNotifier {
  Future<void> addNote({
    required String note,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    var date = DateTime.now().toIso8601String();
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("note")
          .doc(uid)
          .collection("notes")
          .add({
        "userId": uid,
        "content": note,
        "createdAt": date,
      });

      String noteId = docRef.id;

      await FirebaseFirestore.instance
          .collection("note")
          .doc(uid)
          .collection("notes")
          .doc(noteId)
          .update({"id": noteId});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed"),
        backgroundColor: Colors.red,
      ));
    }

    notifyListeners();
  }

  Future<void> updateNote({
    required String note,
    required String docId,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    var date = DateTime.now().toIso8601String();

    try {
      collection.doc(uid).collection("notes").doc(docId).update({
        "content": note,
        "createdAt": date,
      }).then((_) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Update Successful"),
          backgroundColor: bcolor,
        ));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Update failed"),
        backgroundColor: Colors.red,
      ));
    }
    notifyListeners();
  }

  Future<void> deleteNote({
    required String docId,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    try {
      await collection.doc(uid).collection("notes").doc(docId).delete().then(
          (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Successfully deleted"),
                backgroundColor: bcolor,
              )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed"),
        backgroundColor: Colors.red,
      ));
    }
    Navigator.of(context).pop();

    notifyListeners();
  }
}
