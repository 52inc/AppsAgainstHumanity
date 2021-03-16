import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

extension MediaQueryExt on BuildContext {

  /// Get the padding top including system window spacing that is
  /// also web safe
  double get paddingTop {
    final top = MediaQuery.of(this).padding.top;
    if (kIsWeb) {
      return top + 24;
    } else if (Platform.isAndroid) {
      return top + 24;
    } else {
      return top + 8;
    }
  }
}
