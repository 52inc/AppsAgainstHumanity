import 'package:kt_dart/kt.dart';

enum PromptSpecial {
    pick2,
    draw2pick3
}

@nullable
PromptSpecial promptSpecial(String special) {
    if (special != null) {
        if (special.toUpperCase() == 'PICK 2') {
            return PromptSpecial.pick2;
        } else if (special.toUpperCase() == 'DRAW 2 PICK 3' || special.toUpperCase() == 'DRAW 2, PICK 3') {
            return PromptSpecial.draw2pick3;
        }
    }
    return null;
}
