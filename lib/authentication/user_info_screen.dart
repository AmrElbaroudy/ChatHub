import 'dart:io';

import 'package:chat_hub/constant.dart';
import 'package:chat_hub/utilites/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../utilites/methods.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();
  final TextEditingController _nameController = TextEditingController();
  File? finalImage;
  String userImage = '';

  void selectImage(bool isCamera) async {
    finalImage = await pickImage(
        context: context,
        isCamera: isCamera,
        onFail: (e) {
          showSnackBar(context, e);
        });
    //crop image
    cropImage(finalImage?.path);
  }

  void cropImage(filePath) async {
    //crop image
    if (filePath != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxHeight: 800,
        maxWidth: 800,
        compressQuality: 90,
      );
      if (croppedFile != null) {
        setState(() {
          finalImage = File(croppedFile.path);
        });
      } else {}
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 5,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      selectImage(true);
                      Navigator.of(context).pop();
                    },
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      selectImage(false);
                      Navigator.of(context).pop();
                    },
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                  ),
                ],
              ),
            ));
  }

  @override
  void dispose() {
    _btnController.stop();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text('User Information'),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              children: [
                finalImage == null
                    ? Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(AssetsManager.userImage),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          showBottomSheet();
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                )
                    : Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(File(finalImage!.path)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          showBottomSheet();
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Name',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: double.infinity,
                    child: RoundedLoadingButton(
                      controller: _btnController,
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _nameController.text.length < 3) {
                          showSnackBar(context, 'please enter your name');
                          _btnController.reset();
                          return;
                        }
                        // save user info to firestore
                        saveUserInfoToFirestore();
                      },
                      successIcon: Icons.check,
                      successColor: Colors.green,
                      errorColor: Colors.red,
                      child: const Text('Continue',
                          style: TextStyle(color: Colors.white,fontSize: 18)),
                    )),
              ],
            ),
          )),
    );
  }

  //save user info to firestore
  void saveUserInfoToFirestore() async {
    final authProvider = context.read<AuthProvider>();
    UserModel userModel = UserModel(
      name: _nameController.text.trim(),
      uid: authProvider.uid!,
      photoUrl: '',
      isOnline: true,
      phoneNumber: authProvider.phoneNumber!,
      token: '',
      aboutMe: 'Hey there! I\'m using ChatHub.',
      lastSeen: '',
      createdAt: '',
      friends: [],
      friendRequests: [],
      sentFriendRequests: [],
    );
    authProvider.saveUserDataToFireStore(userModel: userModel,
        fileImage: finalImage,
        onSuccess: () async {
          _btnController.success();
          await authProvider.saveUserDataToSP();
          navigateToHomeScreen();

           },
        onFail: () async{
          _btnController.error();
          showSnackBar(context, 'Something went wrong');
          await Future.delayed(const Duration(seconds: 1));
          _btnController.reset();

        },
    );
  }

  void navigateToHomeScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Constant.home,
      (route) => false,
    );
  }
}
