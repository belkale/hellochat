import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:hellochat/socket_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';
@riverpod
class Chat extends _$Chat {
  final _localStream = StreamController<String>();
  @override
  Stream<List<String>> build() async* {
    final socket = ref.read(socketProvider);
    final multi = StreamGroup.merge([socket.map(utf8.decode),
      _localStream.stream]);

    var allMessages = const <String>[];
    await for (final message in multi) {
      // A new message has been received. Let's add it to the list of all messages.
      allMessages = [message, ...allMessages];
      yield allMessages;
    }
  }
  void add(String message) {
    _localStream.add(message);
  }
}