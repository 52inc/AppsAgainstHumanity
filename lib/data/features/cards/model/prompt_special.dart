import 'package:kt_dart/kt.dart';

// Added derp b/c null safety, prob not right
enum PromptSpecial {
  derp,
  pick2,
  draw2pick3,
}

// @nullable
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
