import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/Constants/all_constants.dart';
import 'package:flutter_frontend/providers/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_frontend/models/chat_messages.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BuildMessageInput extends StatefulWidget {
  bool isLoading;
  late ChatProvider chatProvider;
  TextEditingController textEditingController;
  String groupChatId;
  final String currentUserId;
  String peerId;
  ScrollController scrollController;

  BuildMessageInput({
    super.key,
    required this.isLoading,
    required ChatProvider chatProvider,
    required this.textEditingController,
    required this.groupChatId,
    required this.currentUserId,
    required this.scrollController,
    required this.peerId,
  });

  @override
  State<BuildMessageInput> createState() => _BuildMessageInputState();
}

class _BuildMessageInputState extends State<BuildMessageInput> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    File? imageFile;
    String imageUrl = '';

    void onSendMessage(String content, int type) {
      if (content.trim().isNotEmpty) {
        widget.textEditingController.clear();
        widget.chatProvider.sendChatMessage(content, type, widget.groupChatId,
            widget.currentUserId, widget.peerId);
        widget.scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      } else {
        Fluttertoast.showToast(
            msg: 'Nothing to send', backgroundColor: Colors.grey);
      }
    }

    void uploadImageFile() async {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask uploadTask =
          widget.chatProvider.uploadImageFile(imageFile!, fileName);
      try {
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          widget.isLoading = false;
          onSendMessage(imageUrl, MessageType.image);
        });
      } on FirebaseException catch (e) {
        setState(() {
          widget.isLoading = false;
        });
        Fluttertoast.showToast(msg: e.message ?? e.toString());
      }
    }

    Future getImage() async {
      if (Platform.isAndroid) {
        ImagePicker imagePicker = ImagePicker();
        XFile? pickedFile;
        pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          imageFile = File(pickedFile.path);
          if (imageFile != null) {
            setState(() {
              widget.isLoading = true;
            });
            uploadImageFile();
          }
        }
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result?.files.single.path != null) {
          // File? file = File(result?.files.single.path);
          String? pathString = result?.files.single.path;

          File? file = File(pathString!);
          if (file != null) {
            imageFile = File(file.path);
            if (imageFile != null) {
              setState(() {
                widget.isLoading = true;
              });
              uploadImageFile();
            }
          }
        } else {
          // User canceled the picker
        }
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: Sizes.dimen_4),
            decoration: BoxDecoration(
              color: AppColors.burgundy,
              borderRadius: BorderRadius.circular(Sizes.dimen_30),
            ),
            child: IconButton(
              onPressed: getImage,
              icon: const Icon(
                Icons.camera_alt,
                size: Sizes.dimen_28,
              ),
              color: AppColors.white,
            ),
          ),
          Flexible(
              child: TextField(
            focusNode: focusNode,
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: widget.textEditingController,
            decoration:
                kTextInputDecoration.copyWith(hintText: 'write here...'),
            onSubmitted: (value) {
              onSendMessage(
                  widget.textEditingController.text, MessageType.text);
            },
          )),
          // Container(
          //   margin: const EdgeInsets.only(left: Sizes.dimen_4),
          //   decoration: BoxDecoration(
          //     color: AppColors.burgundy,
          //     borderRadius: BorderRadius.circular(Sizes.dimen_30),
          //   ),
          //   child: IconButton(
          //     onPressed: () {
          //       onSendMessage(textEditingController.text, MessageType.text);
          //     },
          //     icon: const Icon(Icons.send_rounded),
          //     color: AppColors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
