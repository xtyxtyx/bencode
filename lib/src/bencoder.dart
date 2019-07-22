import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

final bEncoder = BEncoder._();

class BEncoder extends Converter<dynamic, List<int>> {
  BEncoder._();

  /// `convert` converts dart object to bencoded bytes
  /// 
  /// Note that Strings are encoded in utf8. To encode raw bytes,
  /// please use Uint8List. More details in README and bencode_example.dart.
  List<int> convert(dynamic object) {
    if (object is String) {
      return _encodeUtf8String(object);
    }
    if (object is int) {
      return _encodeInteger(object);
    }
    if (object is Uint8List) {
      return _encodeString(object);
    }
    if (object is List) {
      return _encodeList(object);
    }
    if (object is Map) {
      return _encodeDictionary(object);
    }

    throw 'unsupported object type ${object.runtimeType}';
  }

  List<int> _encodeUtf8String(String str) {
    final builder = BytesBuilder();
    final data = utf8.encode(str);
    final length = ascii.encode(data.length.toString());
    const comma = 58; // ascii code of `:`
    builder.add(length);
    builder.addByte(comma);
    builder.add(data);
    return builder.toBytes();
  }

  List<int> _encodeString(List<int> data) {
    final builder = BytesBuilder();
    final length = ascii.encode(data.length.toString());
    const comma = 58; // ascii code of `:`
    builder.add(length);
    builder.addByte(comma);
    builder.add(data);
    return builder.toBytes();
  }

  List<int> _encodeInteger(int i) {
    return ascii.encode('i${i.toString()}e');
  }

  List<int> _encodeList(List<dynamic> list) {
    final builder = BytesBuilder();
    const i = 108; // ascii code of `l`
    const e = 101; // ascii code of `e`
    builder.addByte(i);
    for (var item in list) {
      builder.add(convert(item));
    }
    builder.addByte(e);
    return builder.toBytes();
  }

  List<int> _encodeDictionary(Map<String, dynamic> dict) {
    final builder = BytesBuilder();
    const d = 100; // ascii code of `d`
    const e = 101; // ascii code of `e`
    builder.addByte(d);
    for (var item in dict.entries) {
      builder.add(convert(item.key));
      builder.add(convert(item.value));
    }
    builder.addByte(e);
    return builder.toBytes();
  }
}
