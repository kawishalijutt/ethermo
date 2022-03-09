import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'snackbar.dart';

createAccountWithEmailPassword({data, type, skey, file}) async {
  // print(data);

  bool userCreation = false;
  late UserCredential cred;
  try {
    cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'], password: data['password']);
    if (cred.user != null) {
      showSnackbar(key: skey, msg: 'User Created Succesfully', status: true);
      userCreation = true;
    } else {
      showSnackbar(key: skey, msg: 'Error with User Creation', status: false);
      return false;
    }

    // cred.user!.delete();
  } on FirebaseAuthException catch (ex) {
    // print(ex);
    showSnackbar(key: skey, msg: ex.message, status: false);
    return false;
  } on Exception catch (ex) {
    // print(ex);
    showSnackbar(key: skey, msg: ex, status: false);
    return false;
  }

  if (userCreation) {
    showSnackbar(key: skey, msg: 'Saving User Profile', status: true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set(data);
    } catch (ex) {
      // print(ex);
      showSnackbar(
          key: skey, msg: 'Error While Saving User Profile', status: false);
      return false;
    }
  }
  await FirebaseAuth.instance.currentUser!
      .updateDisplayName(data!['fname']! + " " + data['lname']);
  return true;
}

loginWithEmailPassword({data, skey}) async {
  bool signIn = false;
  late UserCredential cred;
  try {
    cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email'], password: data['password']);
    if (cred.user != null) {
      showSnackbar(key: skey, msg: 'Signed In Succesfully', status: true);
      signIn = true;
    } else {
      showSnackbar(key: skey, msg: 'Error while SignIn', status: false);
      return false;
    }

    // cred.user!.delete();
  } on FirebaseAuthException catch (ex) {
    // print(ex);
    showSnackbar(key: skey, msg: ex.message, status: false);
    return false;
  } on Exception catch (ex) {
    // print(ex);
    showSnackbar(key: skey, msg: ex, status: false);
    return false;
  }

  if (signIn) {
    showSnackbar(key: skey, msg: 'Fetching User Profile', status: true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .get()
          .whenComplete(() => print("fetching complete"))
          .then((value) async {
        var data = value.data();
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(data!['fname']! + " " + data['lname']);
      });
    } catch (ex) {
      showSnackbar(
          key: skey, msg: 'Error While Fetching User Profile', status: false);
      return false;
    }
  }
  return true;
}

Uid() {
  return FirebaseAuth.instance.currentUser!.uid;
}

Future<DocumentSnapshot<Object?>> getCurrentUser({id = null}) {
  String uid = id == null ? FirebaseAuth.instance.currentUser!.uid : id;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  return collectionReference.doc(uid).get();
}
