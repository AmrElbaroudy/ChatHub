import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_hub/authentication/login_screen.dart';
import 'package:chat_hub/authentication/otp_screen.dart';
import 'package:chat_hub/authentication/user_info_screen.dart';
import 'package:chat_hub/main_screen/home_screen.dart';
import 'package:chat_hub/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'constant.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],child:
      MyApp(
          savedThemeMode: savedThemeMode)));}

class MyApp extends StatelessWidget {


  const MyApp({super.key , required this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigoAccent,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigoAccent,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatHub',
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: Constant.login,
        routes: {
          Constant.login: (context) => const LoginScreen(),
          Constant.otp: (context) => const OTPScreen(),
          Constant.userInfo: (context) => const UserInfoScreen(),
          Constant.home: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
