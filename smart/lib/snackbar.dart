import 'package:flutter/material.dart';

showSnackbar({var key, var msg, bool? status}) {
  Color? clr;
  if (status == null) {
    clr = Colors.yellow[700];
  } else if (status) {
    clr = Colors.green;
  } else if (!status) {
    clr = Colors.red;
  }
  key.currentState.showSnackBar(SnackBar(
    content: Text(
      "$msg",
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: clr,
    // padding: EdgeInsetsGeometry.infinity,
  ));
}
