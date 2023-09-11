import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/Constants/all_constants.dart';
import 'package:flutter_frontend/pages/ChatPage/BuildItemListMessage.dart';
import 'package:flutter_frontend/providers/chat_provider.dart';

class BuildListMessage extends StatelessWidget {
  String groupChatId;
  ChatProvider chatProvider;
  ScrollController scrollController;
  int limit;
  String currentUserId;
  final isMessageSent;
  final isMessageReceived;
  final userAvatar;
  final peerAvatar;
  List<QueryDocumentSnapshot> listMessages;
  BuildListMessage({
    Key? key,
    required this.groupChatId,
    required this.chatProvider,
    required this.scrollController,
    required this.limit,
    required this.currentUserId,
    required this.isMessageSent,
    required this.isMessageReceived,
    required this.userAvatar,
    required this.peerAvatar,
    required this.listMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatMessage(groupChatId, limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: scrollController,
                      itemBuilder: (context, index) => BuildItemListMessage(
                        index: index,
                        snapshot: snapshot.data?.docs[index],
                        currentUserId: currentUserId,
                        isMessageSent: isMessageSent,
                        isMessageReceived: isMessageReceived,
                        userAvatar: userAvatar,
                        peerAvatar: peerAvatar,
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No messages...'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.burgundy,
                    ),
                  );
                }
              })
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.burgundy,
              ),
            ),
    );
  }
}
