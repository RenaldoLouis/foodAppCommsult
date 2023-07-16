import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/BottomNavigationBar.dart';
import 'package:flutter_frontend/pages/Login/login_screen.dart';
import 'package:flutter_frontend/pages/ChatPage/BuildMessageInput.dart';
import 'package:flutter_frontend/providers/auth_provider.dart';
import 'package:flutter_frontend/providers/profile_provider.dart';
import 'package:flutter_frontend/providers/chat_provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/Constants/all_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  final String peerId;
  final String? peerAvatar;
  final String? peerNickname;
  final String? userAvatar;

  const ChatPage(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      required this.userAvatar})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
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
    currentUserId = "";
    // readLocal();
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
        _limit += _limitIncrement;
      });
    }
  }

  void readLocal() {
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false);
    }
    if (currentUserId.compareTo(widget.peerId) > 0) {
      groupChatId = '$currentUserId - ${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId} - $currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: widget.peerId});
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
              // buildListMessage(),
              BuildMessageInput(
                isLoading: isLoading,
                chatProvider: chatProvider,
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
