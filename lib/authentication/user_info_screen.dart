import 'package:chat_hub/utilites/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
final TextEditingController _nameController = TextEditingController();
  @override
  void dispose() {
    _btnController.stop();
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User Information'),
      ),
      body:   Center(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            children: [
              const Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(AssetsManager.userImage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, color: Colors.black,),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30,),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Name',

                  ),
                ),
              const SizedBox(height: 30,),
              SizedBox(
                width: double.infinity,
                child: RoundedLoadingButton(
                  controller: _btnController,
                  onPressed: () {
                    _btnController.success();
                  },
                  successIcon: Icons.check,
                  successColor: Colors.green,
                  errorColor: Colors.red,
                  child: const Text('Continue', style: TextStyle(
                    color: Colors.white
                  )),
              )),
            ],
          ),
        )
      ),
    );
  }
}
