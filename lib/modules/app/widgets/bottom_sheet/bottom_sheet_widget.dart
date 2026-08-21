import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/modules/app/bottom_sheets/custom_bottom_sheet.dart';
import 'package:river_blog/modules/app/providers.dart';
import 'package:river_blog/modules/app/services/bottom_sheets.dart';

class BottomSheetWidget extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const new({
    required this.navigatorKey,
    required this.child,
    super.key,
  });

  @override
  ConsumerState<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends ConsumerState<BottomSheetWidget> {
  late final BottomSheets _bottomSheets;
  late final BottomSheetPresenter _presenter;

  @override
  void initState() {
    super.initState();

    _bottomSheets = ref.read(bottomSheetsProvider);
    _presenter = _open;

    _bottomSheets.attach(_presenter);
  }

  @override
  void dispose() {
    _bottomSheets.detach(_presenter);

    super.dispose();
  }

  Future<BottomSheetResult?> _open(Widget child) async {
    final BuildContext? context = widget.navigatorKey.currentState
      ?.overlay
      ?.context;

    if (context == null) {
      throw StateError('Root navigator is not mounted');
    }

    return showModalBottomSheet<BottomSheetResult>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
