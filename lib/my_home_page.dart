import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hellochat/chat_provider.dart';
import 'package:hellochat/socket_provider.dart';

class MyHomePage extends ConsumerWidget {
  final String title;
  final TextEditingController messageController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  MyHomePage({required this.title, super.key});

  void _sendMessage(WidgetRef ref) async {
    final message = messageController.text;
    ref.read(chatProvider.notifier).add(message);
    final socket = ref.read(socketProvider);
    socket.write(message);
    messageController.clear();
    myFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveChats = ref.watch(chatProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [switch(liveChats) {
        AsyncData(:final value) => Expanded(
          child: ListView.builder(
              reverse: true,
              itemCount: value.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  value[index],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )),
        ),
          AsyncError(:final error) => Text(error.toString()),
          _ => const CircularProgressIndicator(),
        },
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    onSubmitted: (message) => _sendMessage(ref),
                    focusNode: myFocusNode,
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(ref),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
