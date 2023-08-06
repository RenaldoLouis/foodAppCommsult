import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/Constants/all_constants.dart';
import 'package:flutter_frontend/models/chat_messages.dart';
import 'package:flutter_frontend/providers/chat_provider.dart';
import 'package:flutter_frontend/components/common_widgets.dart';
import 'package:intl/intl.dart';

class BuildItemListMessage extends StatelessWidget {
  int index;
  DocumentSnapshot? snapshot;
  String currentUserId;
  final isMessageSent;
  final isMessageReceived;
  String userAvatar;
  String peerAvatar;
  BuildItemListMessage({
    Key? key,
    required this.index,
    required this.snapshot,
    required this.currentUserId,
    required this.isMessageSent,
    required this.isMessageReceived,
    required this.userAvatar,
    required this.peerAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatMessages chatMessages = ChatMessages.fromDocument(snapshot);
    return snapshot != null
        ? chatMessages.idFrom == currentUserId
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      chatMessages.type == MessageType.text
                          ? MessageBubble(
                              chatContent: chatMessages.content,
                              color: AppColors.spaceLight,
                              textColor: AppColors.white,
                              margin:
                                  const EdgeInsets.only(right: Sizes.dimen_10),
                            )
                          : chatMessages.type == MessageType.image
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      right: Sizes.dimen_10,
                                      top: Sizes.dimen_10),
                                  child: ChatImage(
                                      imageSrc: chatMessages.content,
                                      onTap: () {}),
                                )
                              : const SizedBox.shrink(),
                      isMessageSent(index)
                          ? Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_20),
                              ),
                              child: Image.network(
                                userAvatar,
                                width: Sizes.dimen_40,
                                height: Sizes.dimen_40,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext ctx, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.burgundy,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stackTrace) {
                                  return const Icon(
                                    Icons.account_circle,
                                    size: 35,
                                    color: AppColors.greyColor,
                                  );
                                },
                              ),
                            )
                          : Container(
                              width: 35,
                            ),
                    ],
                  ),
                  isMessageSent(index)
                      ? Container(
                          margin: const EdgeInsets.only(
                              right: Sizes.dimen_50,
                              top: Sizes.dimen_6,
                              bottom: Sizes.dimen_8),
                          child: Text(
                            DateFormat('dd MMM yyyy, hh:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(chatMessages.timestamp),
                              ),
                            ),
                            style: const TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: Sizes.dimen_12,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isMessageReceived(index)
                          // left side (received message)
                          ? Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Sizes.dimen_20),
                              ),
                              child: Image.network(
                                peerAvatar,
                                width: Sizes.dimen_40,
                                height: Sizes.dimen_40,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext ctx, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.burgundy,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stackTrace) {
                                  return const Icon(
                                    Icons.account_circle,
                                    size: 35,
                                    color: AppColors.greyColor,
                                  );
                                },
                              ),
                            )
                          : Container(
                              width: 35,
                            ),
                      chatMessages.type == MessageType.text
                          ? MessageBubble(
                              color: AppColors.burgundy,
                              textColor: AppColors.white,
                              chatContent: chatMessages.content,
                              margin:
                                  const EdgeInsets.only(left: Sizes.dimen_10),
                            )
                          : chatMessages.type == MessageType.image
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: Sizes.dimen_10,
                                      top: Sizes.dimen_10),
                                  child: ChatImage(
                                      imageSrc: chatMessages.content,
                                      onTap: () {}),
                                )
                              : const SizedBox.shrink(),
                    ],
                  ),
                  isMessageReceived(index)
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: Sizes.dimen_50,
                              top: Sizes.dimen_6,
                              bottom: Sizes.dimen_8),
                          child: Text(
                            DateFormat('dd MMM yyyy, hh:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(chatMessages.timestamp),
                              ),
                            ),
                            style: const TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: Sizes.dimen_12,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              )
        : SizedBox.shrink();
  }
}
