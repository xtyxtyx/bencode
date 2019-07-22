import 'dart:io';

import 'package:torrent_bencode/torrent_bencode.dart';

main() async {
  final data = File('test/multi.torrent').readAsBytesSync();
  final decoded = bDecoder.convert(data);
  print(decoded.keys);
  // Output: (announce, announce-list, created by, creation date, encoding, info)
}