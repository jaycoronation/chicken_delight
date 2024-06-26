// TODO Implement this library.

import 'dart:io';
import 'package:open_file/open_file.dart' as open_file;
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  //Get the storage folder location using path_provider package.
  String? path;

  print("PDF path Data.... ==== ${path}");

  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows) {
    final Directory directory =
    await path_provider.getApplicationSupportDirectory();
    path = directory.path;

    print("PDF path New.... ==== ${path}");
  } else {
    path = await PathProviderPlatform.instance.getApplicationSupportPath();
  }
  final File file =
  File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  if (Platform.isAndroid || Platform.isIOS) {
    //Launch the file (used open_file package)
    print("File name ::== $fileName");

    await OpenFile.open('$path/$fileName');
  //  await open_file.OpenFile.open('$path/$fileName');
  } else if (Platform.isWindows) {
    await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }
}