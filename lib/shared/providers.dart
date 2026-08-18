import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:river_blog/facades/device_storage_facade.dart';
import 'package:river_blog/facades/user_facade.dart';

final Provider<DeviceStorageFacade> deviceStorageFacadeProvider = Provider<DeviceStorageFacade>(
  (Ref ref) => throw UnimplementedError(),
);

final Provider<UserFacade> userFacadeProvider = Provider<UserFacade>((Ref ref) => UserFacade(ref.read(deviceStorageFacadeProvider)));
