import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bencode/bencode.dart';
import 'package:test/test.dart';

void main() {
  group('bDecoder tests', () {
    test('Convert torrent file', () async {
      final data = await File('test/multi.torrent').readAsBytes();
      expect(bDecoder.convert(data), anything);
    });

    test('Convert int', () {
      expect(bDecoder.convertString('i123e'), equals(123));
      expect(bDecoder.convertString('i456e'), equals(456));
      expect(bDecoder.convertString('i-123e'), equals(-123));
    });

    test('Convert dict', () {
      expect(bDecoder.convertString('d3:agei123e4:name4:xutye'),
          equals({'name': 'xuty'.runes.toList(), 'age': 123}));
    });

    test('Convert list', () {
      expect(
          bDecoder.convertString('l3:agei123e4:name4:xutye'),
          equals([
            'age'.runes.toList(),
            123,
            'name'.runes.toList(),
            'xuty'.runes.toList(),
          ]));
    });

    test('Convert string', () {
      expect(bDecoder.convertString('11:hello world'),
          equals('hello world'.runes.toList()));
      expect(bDecoder.convertString('4:hola'), equals('hola'.runes.toList()));
      expect(() => bDecoder.convertString('100:haha'),
          throwsA(equals('broken string at 4')));
    });
  });

  group('bEncoder tests', () {
    test('Encode string', () {
      expect(bEncoder.convert('hello world'),
          equals('11:hello world'.runes.toList()));
    });

    test('Encode cjk', () {
      expect(bEncoder.convert('你好，世界'), equals(utf8.encode('15:你好，世界')));
    });

    test('Encode integer', () {
      expect(bEncoder.convert(123), equals('i123e'.runes.toList()));
    });

    test('Encode list', () {
      expect(bEncoder.convert([123, 'xuty']),
          equals('li123e4:xutye'.runes.toList()));
    });

    test('Encode bytes', () {
      expect(bEncoder.convert(Uint8List.fromList([0xAB, 0xCD])),
          equals('2:\u00ab\u00cd'.runes.toList()));
    });

    test('Encode map', () {
      expect(bEncoder.convert({'name': 'xuty'}),
          equals('d4:name4:xutye'.runes.toList()));
    });

    test('decode and re-encode torrent file', () async {
      final data = await File('test/multi.torrent').readAsBytes();
      final decoded = bDecoder.convert(data);
      final encoded = bEncoder.convert(decoded);
      expect(encoded, equals(data));
    });
  });
}
