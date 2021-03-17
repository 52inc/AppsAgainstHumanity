import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {

  ScaffoldMessengerState get scaffold => ScaffoldMessenger.of(this);
}
