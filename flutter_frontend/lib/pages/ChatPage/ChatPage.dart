import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/pages/ChatPage/BuildListMessage.dart';
import 'package:flutter_frontend/pages/Login/login_screen.dart';
import 'package:flutter_frontend/pages/ChatPage/BuildMessageInput.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/providers/profile_provider.dart';
import 'package:flutter_frontend/providers/chat_provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/Constants/all_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as logger;

class ChatPage extends StatefulWidget {
  final String peerId;
  final String? peerAvatar;
  final String? peerNickname;
  final String? userAvatar;
  final String userUid;

  const ChatPage(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      required this.userAvatar,
      required this.userUid})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];

  int limit = 20;
  final int limitIncrement = 20;
  String groupChatId = '';

  bool isLoading = false;
  bool isShowSticker = false;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    currentUserId = widget.userUid;
    readLocal();
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isMessageSent(int index) {
    if ((index > 0 && listMessages[index - 1].get("idFrom") != currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        limit += limitIncrement;
      });
    }
  }

  void readLocal() {
    // if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
    //   currentUserId = authProvider.getFirebaseUserId()!;
    // } else {
    //   //this part is the problem
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => const LoginScreen()),
    //       (Route<dynamic> route) => false);
    // }
    // if (currentUserId.compareTo(widget.peerId) > 0) {
    setState(() {
      groupChatId = '$currentUserId - ${widget.peerId}';
    });
    // } else {
    // groupChatId = '${widget.peerId} - $currentUserId';
    // }

    // should be chatting with peer id but for now we hardcoded to me(admin) it cuz chat betwen user not possbile
    chatProvider.updateFirestoreData(
        FirestoreConstants.pathUserCollection,
        currentUserId,
        {FirestoreConstants.chattingWith: 'AJlEJEsybdVa4DbrjNmIwPRPdz02'});
  }

  void _callPhoneNumber(String phoneNumber) async {
    var phoneNumber = "1555010999";
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);

    // var url = Uri.parse('tel:+1-555-010-999');
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // } else {
    //   throw 'Error Occurred';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chatting with ${widget.peerNickname}'.trim()),
        actions: [
          IconButton(
            onPressed: () {
              ProfileProvider profileProvider;
              profileProvider = context.read<ProfileProvider>();
              String callPhoneNumber =
                  profileProvider.getPrefs(FirestoreConstants.phoneNumber) ??
                      "";
              _callPhoneNumber(callPhoneNumber);
            },
            icon: const Icon(Icons.phone),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_8),
          child: Column(
            children: [
              BuildListMessage(
                  groupChatId: groupChatId,
                  chatProvider: chatProvider,
                  scrollController: scrollController,
                  limit: limit,
                  currentUserId: currentUserId,
                  isMessageSent: isMessageSent,
                  isMessageReceived: isMessageReceived,
                  userAvatar: widget.userAvatar,
                  peerAvatar: widget.peerAvatar),
              BuildMessageInput(
                isLoading: isLoading,
                textEditingController: textEditingController,
                groupChatId: groupChatId,
                currentUserId: currentUserId,
                scrollController: scrollController,
                peerId: widget.peerId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
