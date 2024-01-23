import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hellochat/chat_service_provider.dart';
import 'package:hellochat/my_list_provider.dart';
import 'package:hellochat/my_stream_provider.dart';

class MyHomePage extends ConsumerWidget {
  final String title;
  final TextEditingController messageController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  MyHomePage({required this.title, super.key});

  void _sendMessage(WidgetRef ref) async {
    ref.read(myStreamProvider.notifier).add(messageController.text);
    messageController.clear();
    myFocusNode.requestFocus();

    final chatService = ref.read(chatServiceProvider);
    await chatService.add(messageController.text);
    _checkNext(ref);
  }

  Future<void> _checkNext(WidgetRef ref) async {
    final chatService = ref.read(chatServiceProvider);
    final next = await chatService.next();
    if (next != null) {
      ref.read(myStreamProvider.notifier).add(next);
    }
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveChats = ref.watch(myStreamProvider);
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
