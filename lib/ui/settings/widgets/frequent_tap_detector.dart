import 'dart:async';

import 'package:flutter/material.dart';

class FrequentTapDetector extends StatefulWidget {
  final Widget child;
  final int? threshold;
  final VoidCallback? onTapCountReachedCallback;

  FrequentTapDetector({
    required this.child,
    this.threshold = 5,
    this.onTapCountReachedCallback,
  });

  @override
  _FrequentTapDetectorState createState() => _FrequentTapDetectorState();
}

class _FrequentTapDetectorState extends State<FrequentTapDetector> {
  late Timer _timer;
  int _tapCount = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: widget.child,
      onTap: () {
        _tapCount += 1;
        print("Tap Count ($_tapCount)");
        if (_tapCount >= widget.threshold!) {
          widget.onTapCountReachedCallback?.call();
          _tapCount = 0;
        } else {
          _startResetDelay();
        }
      },
    );
  }

  void _startResetDelay() {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: 1000), _onResetTapCount);
  }

  void _onResetTapCount() {
    _tapCount = 0;
    print("Reset tap count");
  }
}
