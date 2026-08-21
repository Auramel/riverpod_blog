import 'package:flutter/material.dart';

import 'package:river_blog/modules/app/bottom_sheets/custom_bottom_sheet.dart';

final class LogoutBottomSheetResult extends BottomSheetResult {
  final bool isConfirmed;

  const new({required this.isConfirmed});
}

class LogoutBottomSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: 24,
        children: [
          Text(
            'Вы действительно хотите выйти?',
            textAlign: .center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(
                    const LogoutBottomSheetResult(isConfirmed: true),
                  ),
                  child: const Text('Ок'),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(
                    const LogoutBottomSheetResult(isConfirmed: false),
                  ),
                  child: const Text('Отмена'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
