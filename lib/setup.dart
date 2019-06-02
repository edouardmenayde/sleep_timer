import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> silencePath() async {
  return "${await _localPath()}/silence.mp3";
}

Future<void> setupMusicFiles() async {
  final storePath = "${await _localPath()}/silence.mp3";
  final f = File(storePath);
  if (!await f.exists()) {
    final assetKey = "assets/silence.mp3";
    var data = await rootBundle.load(assetKey);
    await f.writeAsBytes(data.buffer.asInt8List());
  }
}
