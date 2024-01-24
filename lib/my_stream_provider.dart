import 'dart:async';

import 'package:hellochat/chat_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_stream_provider.g.dart';
@riverpod
Stream<List<String>> myStream(MyStreamRef ref) {
  final chatService = ref.read(chatServiceProvider);
  return chatService.list();
}