This library provides classes to encode/decode bencoded bytes.
Mainly used to implement bittorrent related functions.


## Features

- Decode/encode bencoded bytes.

## Usage

Example:

```dart
import 'dart:typed_data';
import 'package:bencode/bencode.dart';

main() async {
  var decoded = bDecoder.convertString('d5:hello5:worlde');
  // or final decoded = bDecoder.convert('d5:hello5:worlde'.runes.toString());
  print(decoded);
  // Output: {hello: world}
  print(decoded is Map);
  // Output: true

  decoded = bDecoder.convertString('i123e');
  print(decoded);
  // Output: 123
  print(decoded is int);
  // Output: true

  decoded = bDecoder.convertString('li123ei123ee');
  print(decoded);
  // Output: [123, 123]
  print(decoded is List);
  // Output: true

  decoded = bDecoder.convertString('11:hello world');
  print(decoded);
  // bencoded strings are converted to bytes by default.
  // Output: [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]
  print(String.fromCharCodes(decoded));
  // Output: hello world
  print(decoded is List<int>);
  // Output: true

  var encoded = bEncoder.convert({'hello': 'world'});
  print(encoded);
  // Output: [100, 53, 58, 104, 101, 108, 108, 111, 53, 58, 119, 111, 114, 108, 100, 101]
  print(String.fromCharCodes(encoded));
  // Output: d5:hello5:worlde

  encoded = bEncoder.convert(123);
  print(String.fromCharCodes(encoded));
  // Output: i123e

  encoded = bEncoder.convert([123, 456]);
  print(String.fromCharCodes(encoded));
  // Output: li123ei456ee

  encoded = bEncoder.convert(Uint8List.fromList([123, 123]));
  print(encoded);
  // Output: [50, 58, 123, 123]
  print(String.fromCharCodes(encoded));
  // Output: 2:{{
}

```

Decode bittorrent files:
```dart
import 'dart:io';
import 'package:bencode/bencode.dart';

main() async {
  final data = File('test/multi.torrent').readAsBytesSync();
  final decoded = bDecoder.convert(data);
  print(decoded.keys);
  // Output: (announce, announce-list, created by, creation date, encoding, info)
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://github.com/xtyxtyx/bencode/issues
