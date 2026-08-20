import 'package:river_blog/core/base/base_commands.dart';
import 'package:river_blog/core/base/empty_state.dart';
import 'package:river_blog/shared/providers.dart';

class HomeCommands extends BaseCommands<EmptyState> {
  @override
  EmptyState build() {
    return EmptyState();
  }

  Future<void> logout() async {
    await ref.read(userFacadeProvider)
      .logout();
  }
}
