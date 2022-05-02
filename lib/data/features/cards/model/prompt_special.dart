// import 'package:kt_dart/kt.dart';

enum PromptSpecial { pick2, draw2pick3, derp }

PromptSpecial promptSpecial(String special) {
  if (special != "") {
    if (special.toUpperCase() == 'PICK 2') {
      return PromptSpecial.pick2;
    } else if (special.toUpperCase() == 'DRAW 2 PICK 3' ||
        special.toUpperCase() == 'DRAW 2, PICK 3') {
      return PromptSpecial.draw2pick3;
    }
  }
  return PromptSpecial.derp;
}
