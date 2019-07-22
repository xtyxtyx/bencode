import 'dart:convert';

import 'data_reader.dart';

final bDecoder = BDecoder._();

class BDecoder extends Converter<List<int>, dynamic> {
  DataReader _reader;

  BDecoder._();

  /// `convert` converts bencoded string into `String`,
  /// bencoded dictionary into `Map<String, dynamic>`,
  /// bencoded list into `List<dynamic>`,
  /// and bencoded integers into `int`.
  dynamic convert(List<int> bytes) {
    _reader = DataReader(bytes);
    return _parse();
  }

  /// convertString is equivalent to `convert`
  /// except that convertString takes a String as its parameter.
  dynamic convertString(String str) {
    return convert(str.runes.toList());
  }

  /// tryConvert is equivalent to `convert`
  /// except that tryConvert wiil return null on failure rather than throw an exception
  dynamic tryConvert(List<int> bytes) {
    try {
      return convert(bytes);
    } catch (_) {
      return null;
    }
  }

  dynamic _parse() {
    _reader.reset();
    return _readNext();
  }

  dynamic _readNext() {
    if (_reader.matches('d')) {
      return _readDict();
    }
    if (_reader.matches('i')) {
      return _readInt();
    }
    if (_reader.matches('l')) {
      return _readList();
    }
    if (_reader.matches(RegExp(r'[0-9]'))) {
      return _readString();
    }
    if (_reader.atEOF) {
      return null;
    }

    throw 'd, i, l or <number> expected at ${_reader.pos}';
  }

  List<int> _readString() {
    final len = _reader.readInt();
    _reader.expect(':');
    final str = _reader.take(len);
    if (str == null) {
      throw 'broken string at ${_reader.pos}';
    }
    return str;
  }

  List<dynamic> _readList() {
    final result = <dynamic>[];
    _reader.expect('l');
    while (!_reader.matches('e')) {
      final value = _readNext();
      result.add(value);
    }
    _reader.expect('e');
    return result;
  }

  Map<String, dynamic> _readDict() {
    final result = <String, dynamic>{};
    _reader.expect('d');
    while (!_reader.matches('e')) {
      final key = utf8.decode(_readString());
      final value = _readNext();
      result[key] = value;
    }
    _reader.expect('e');
    return result;
  }

  int _readInt() {
    _reader.expect('i');
    final result = _reader.readInt();
    _reader.expect('e');
    return result;
  }
}
