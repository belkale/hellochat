
import 'dart:io';

class ChatService {
  late List<String> messages;
  Future<void> init() async {
    sleep(const Duration(seconds: 1));
    messages = List.generate(20, (index) => "This is message $index");
  }

  Future<List<String>> list() async {
    sleep(const Duration(seconds: 1));
    return messages;
  }

  Future<void> add(String message) async {
    sleep(const Duration(seconds: 1));
    messages.add(message);
    final next = "Response to user message ${messages.length}";
    messages.add(next);
  }

  Future<String?> next() async {
    sleep(const Duration(seconds: 1));
    return messages.last;
  }
}