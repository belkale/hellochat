import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_stream_provider.g.dart';
@riverpod
class MyStream extends _$MyStream {
  final controller = StreamController<List<String>>();
  List<String> messages = [];
  @override
  Stream<List<String>> build() {
    controller.add(messages);
    return controller.stream;
  }

  void add(String message) {
    messages = [message, ...messages];
    controller.add(messages);
  }
}