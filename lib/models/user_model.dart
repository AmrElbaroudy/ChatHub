import '../constant.dart';

class UserModel {
  String uid;
  String name;
  String token;
  String photoUrl;
  String phoneNumber;
  String aboutMe;
  String lastSeen;
  String createdAt;
  bool isOnline;
  List<String> friends;
  List<String> friendRequests;
  List<String> sentFriendRequests;

  UserModel({
    required this.uid,
    required this.name,
    required this.token,
    required this.photoUrl,
    required this.phoneNumber,
    required this.aboutMe,
    required this.lastSeen,
    required this.createdAt,
    required this.isOnline,
    required this.friends,
    required this.friendRequests,
    required this.sentFriendRequests
  });
  //from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map[Constant.uid] ?? '',
      name: map[Constant.name] ?? '',
      token: map[Constant.token] ?? '',
      photoUrl: map[Constant.photoUrl] ?? '',
      phoneNumber: map[Constant.phoneNumber] ?? '',
      aboutMe: map[Constant.aboutMe] ?? '',
      lastSeen: map[Constant.lastSeen] ?? '',
      createdAt: map[Constant.createdAt] ?? '',
      isOnline: map[Constant.isOnline] ?? false,
      friends: List<String>.from(map[Constant.friends] ?? []),
      friendRequests: List<String>.from(map[Constant.friendRequests] ?? []),
      sentFriendRequests: List<String>.from(map[Constant.sentFriendRequests] ?? [])
    );
  }
  //to map
  Map<String, dynamic> toMap() {
    return {
      Constant.uid: uid,
      Constant.name: name,
      Constant.token: token,
      Constant.photoUrl: photoUrl,
      Constant.phoneNumber: phoneNumber,
      Constant.aboutMe: aboutMe,
      Constant.lastSeen: lastSeen,
      Constant.createdAt: createdAt,
      Constant.isOnline: isOnline,
      Constant.friends: friends,
      Constant.friendRequests: friendRequests,
      Constant.sentFriendRequests: sentFriendRequests
    };
  }
}