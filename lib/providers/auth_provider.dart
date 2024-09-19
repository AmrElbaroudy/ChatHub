import 'dart:convert';
import 'dart:io';

import 'package:chat_hub/models/user_model.dart';
import 'package:chat_hub/utilites/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccessful = false;
  String? _uid;
  String? _phoneNumber;
  UserModel? _userModel;

  bool get isLoading => _isLoading;

  bool get isSuccessful => _isSuccessful;

  String? get uid => _uid;

  String? get phoneNumber => _phoneNumber;

  UserModel? get userModel => _userModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //check if user exists in firebase
  Future<bool> checkUserExists() async {
    DocumentSnapshot documentSnapshot =
        await _db.collection(Constant.user).doc(_uid).get();
    return documentSnapshot.exists;
  }

// get user data from fire store
  Future<void> getUserDataFromFirestore() async {
    DocumentSnapshot documentSnapshot =
        await _db.collection(Constant.user).doc(_uid).get();
    _userModel =
        UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    notifyListeners();
  }

  //save user data to shared preferences
  Future<void> saveUserDataToSP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(Constant.userModel, jsonEncode(_userModel!.toMap()));
  }

  //get user data from shared preferences
  Future<void> getUserDataFromSP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String data = sp.getString(Constant.userModel) ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    notifyListeners();
  }

  //Sign in with phone number
  Future<void> signInWithPhone(
      {required String phoneNumber, required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            _uid = value.user!.uid;
            _phoneNumber = value.user!.phoneNumber;
            _isLoading = false;
            _isSuccessful = true;
            notifyListeners();
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          _isSuccessful = false;
          _isLoading = false;
          notifyListeners();
          showSnackBar(context,
              e.toString()); // ScaffoldMessenger.of(context).showSnackBar(snackBar)
        },
        codeSent: (String verificationId, int? resendToken) {
          _isLoading = false;
          notifyListeners();
          //navigate to OTP screen
          Navigator.of(context).pushNamed(Constant.otp, arguments: {
            Constant.phoneNumber: phoneNumber,
            Constant.verificationId: verificationId
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _isLoading = false;
          notifyListeners();
        });
  }

// verify otp code
  Future<void> verifyOtp(
      {required String verificationId,
      required String otpCode,
      required BuildContext context,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);
    await _auth.signInWithCredential(credential).then((value) async {
      _uid = value.user!.uid;
      _phoneNumber = value.user!.phoneNumber;
      _isLoading = false;
      onSuccess();
      _isSuccessful = true;
      notifyListeners();
    }).catchError((e) {
      _isSuccessful = false;
      _isLoading = false;
      notifyListeners();
      showSnackBar(context,
          e.toString()); // ScaffoldMessenger.of(context).showSnackBar(snackBar)
    });
  }

// save user data to firestore
  void saveUserDataToFireStore(
      {required UserModel userModel,
      required File? fileImage,
      required Function onSuccess,
      required Function onFail}) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (fileImage != null) {
        String imageUrl = await storeFileToStorage(
            file: fileImage,
            reference: "${Constant.userImage}/${Constant.uid}");
        userModel.photoUrl = imageUrl;
      }
      userModel.lastSeen = DateTime.now().microsecondsSinceEpoch.toString();
      userModel.createdAt = DateTime.now().microsecondsSinceEpoch.toString();
      _userModel = userModel;
      _uid = userModel.uid;
      // save user data to firestore
      await _db
          .collection(Constant.user)
          .doc(userModel.uid)
          .set(userModel.toMap());
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      onFail(e.toString());
    }
  }

  // store file to storage
  Future<String> storeFileToStorage(
      {required File file, required String reference}) async {
    UploadTask uploadTask = _storage.ref().child(reference).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String fileUrl = await taskSnapshot.ref.getDownloadURL();
    return fileUrl;
  }
}
