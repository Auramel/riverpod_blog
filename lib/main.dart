import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

import 'package:river_blog/facades/device_storage_facade.dart';
import 'package:river_blog/modules/app/screens/app_layout.dart';
import 'package:river_blog/shared/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final DeviceStorageFacade deviceStorage = DeviceStorageFacade(prefs);

  runApp(
    ProviderScope(
      overrides: [
        deviceStorageFacadeProvider.overrideWithValue(deviceStorage),
      ],
      observers: [
        TalkerRiverpodObserver(),
      ],
      child: const AppLayout(),
    ),
  );
}
