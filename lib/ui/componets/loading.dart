import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

final _tKey = GlobalKey(debugLabel: 'overlay_parent');

late OverlayEntry _loaderEntry;

bool _loaderShown = false;

class Loading extends StatelessWidget {
  final Widget? child;
  const Loading({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: child,
    );
  }
}

OverlayState? get _overlayState {
  final context = _tKey.currentContext;
  if (context == null) return null;

  NavigatorState? navigator;

  void visitor(Element element) {
    if (navigator != null) return;

    if (element.widget is Navigator) {
      navigator = (element as StatefulElement).state as NavigatorState;
    } else {
      element.visitChildElements(visitor);
    }
  }

  context.visitChildElements(visitor);
  assert(navigator != null, '''unable to show overlay''');
  return navigator!.overlay;
}
