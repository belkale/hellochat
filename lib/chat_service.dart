
import 'dart:async';
import 'dart:io';

class ChatService {
  List<String> messages = [];
  final controller = StreamController<List<String>>();
  Future<void> init() async {
    sleep(const Duration(seconds: 1));
    messages = List.generate(20, (index) => "This is message $index").reversed
        .toList();
    controller.add(messages);
  }

  Stream<List<String>> list() {
    return controller.stream;
  }

  Future<void> add(String message) async {
    sleep(const Duration(seconds: 1));
    messages = [message, ...messages];
    controller.add(messages);
    next();
  }

  Future<String?> next() async {
    sleep(const Duration(seconds: 1));
    final next = "Response to user message ${messages.length}";
    messages = [next, ...messages];
    controller.add(messages);
    return next;
  }
}