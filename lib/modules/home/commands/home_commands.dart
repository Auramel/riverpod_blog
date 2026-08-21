import 'package:river_blog/core/base/base_commands.dart';
import 'package:river_blog/core/base/empty_state.dart';
import 'package:river_blog/facades/user_facade.dart';
import 'package:river_blog/modules/app/providers.dart';
import 'package:river_blog/modules/app/services/bottom_sheets.dart';
import 'package:river_blog/modules/home/bottom_sheets/logout_bottom_sheet.dart';
import 'package:river_blog/shared/providers.dart';

class HomeCommands extends BaseCommands<EmptyState> {
  @override
  EmptyState build() {
    return const EmptyState();
  }

  Future<void> logout() async {
    final BottomSheets bottomSheets = ref.read(bottomSheetsProvider);
    final UserFacade userFacade = ref.read(userFacadeProvider);

    final LogoutBottomSheetResult? result = await bottomSheets.open<LogoutBottomSheetResult>(
      const LogoutBottomSheet(),
    );

    if (!(result?.isConfirmed ?? false)) {
      return;
    }

    await userFacade.logout();
  }
}
