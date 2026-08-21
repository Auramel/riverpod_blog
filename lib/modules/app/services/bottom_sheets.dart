import 'package:flutter/widgets.dart';

import 'package:river_blog/modules/app/bottom_sheets/custom_bottom_sheet.dart';

typedef BottomSheetPresenter = Future<BottomSheetResult?> Function(Widget child);

class BottomSheets {
  BottomSheetPresenter? _presenter;
  bool _isOpened = false;

  void attach(BottomSheetPresenter presenter) {
    if (_presenter != null) {
      throw StateError('Bottom sheet presenter is already attached');
    }

    _presenter = presenter;
  }

  void detach(BottomSheetPresenter presenter) {
    if (identical(_presenter, presenter)) {
      _presenter = null;
    }
  }

  Future<Result?> open<Result extends BottomSheetResult>(Widget child) async {
    if (_isOpened) {
      throw StateError('Bottom sheet is already opened');
    }

    final BottomSheetPresenter? presenter = _presenter;

    if (presenter == null) {
      throw StateError('Bottom sheet presenter is not attached');
    }

    _isOpened = true;

    try {
      final BottomSheetResult? result = await presenter(child);

      if (result == null) {
        return null;
      }

      if (result is! Result) {
        throw StateError(
          'Expected bottom sheet result [$Result], got [${result.runtimeType}]',
        );
      }

      return result;
    } finally {
      _isOpened = false;
    }
  }
}
