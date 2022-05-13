import 'package:flutter/material.dart';

void bcNavigatorPush({
  required context,
  required Widget page,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
