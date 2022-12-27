import 'package:flutter/material.dart';

class HelperFunctions {
  static Widget wrapWithAnimatedBuilder({
    Animation<Offset>? animation,
    required Widget child,
  }) {
    if (animation != null) {
      return AnimatedBuilder(
        animation: animation,
        builder: (_, __) => FractionalTranslation(
          translation: animation.value,
          child: child,
        ),
      );
    } else {
      return child;
    }
  }
}
