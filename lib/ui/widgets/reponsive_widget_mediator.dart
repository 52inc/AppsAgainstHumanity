import 'package:flutter/material.dart';

class ResponsiveWidgetMediator extends StatelessWidget {
  final WidgetBuilder mobile;
  final WidgetBuilder tablet;

  const ResponsiveWidgetMediator({
    required this.mobile,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print("Responsive Width: $width");
    if (width < 700) {
      return mobile(context);
    } else if (width >= 700) {
      return tablet(context);
    } else {
      return mobile(context);
    }
  }
}
