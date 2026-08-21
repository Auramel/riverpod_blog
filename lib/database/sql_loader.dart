import 'package:flutter/services.dart';

class SqlLoader {
  final AssetBundle _bundle;
  final Map<String, Future<String>> _cache = {};
  Future<AssetManifest>? _manifest;

  SqlLoader([AssetBundle? bundle]): _bundle = bundle ?? rootBundle;

  Future<String> load(String path) {
    return _cache.putIfAbsent(path, () => _bundle.loadString(path));
  }

  Future<List<String>> loadDirectory(String directory) async {
    final String prefix = directory.endsWith('/')
      ? directory
      : '$directory/';
    final AssetManifest manifest = await (_manifest ??= AssetManifest.loadFromAssetBundle(_bundle));
    final List<String> paths = manifest.listAssets()
      .where((String path) => (
        path.startsWith(prefix)
        && path.endsWith('.sql')
      ))
      .toList()
      ..sort();

    return Future.wait(paths.map(load));
  }
}
