import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../providers/auth_provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  //get the arguments from the previous screen

  final controller = TextEditingController();
  final focusNode = FocusNode();
  String? otpCode;
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final verficationId = arguments[Constant.verificationId] as String;
    final phoneNumber = arguments[Constant.phoneNumber] as String;
    final authProvider = context.watch<AuthProvider>();


    final defaultPinTheme = PinTheme(
     width: 56,
      height: 60,
      textStyle: GoogleFonts.roboto(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
    );
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Text('Verify your number',
                  style:GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ) ,),
                const SizedBox(height: 50,),
                Text('Enter the 6-digit code we just sent you',
                  textAlign: TextAlign.center,
                  style:GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ) ,),
                const SizedBox(height: 50,),
                Text(phoneNumber,textAlign: TextAlign.center,
                  style:GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ) ,),
                const SizedBox(height: 50,),
                SizedBox(
                 height: 68,
                 child: Pinput(
                   length: 6,
                   controller: controller,
                   focusNode: focusNode,
                   defaultPinTheme: defaultPinTheme,
                   onCompleted: (pin) {
                     setState(() {
                       otpCode = pin;
                     });
                     //verifyOTP code
                     verifyOTP(otpCode: otpCode!, verificationId: verficationId);

                   },
                   focusedPinTheme: defaultPinTheme.copyWith(
                     decoration: defaultPinTheme.decoration!.copyWith(

                       border: Border.all(
                         color: Colors.blue,
                       ),
                     ),
                   ),
                 ),

               ),
                const SizedBox(height: 30,),
                authProvider.isLoading ?
                const CircularProgressIndicator() :
                const SizedBox.shrink(),
                authProvider.isSuccessful?Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle
                  ),
                  child: const Icon(Icons.check,color: Colors.white,),
                )
                    :const SizedBox.shrink(),
                authProvider.isLoading ? const SizedBox.shrink() :
                Text('Didn\'t receive the code?',style: GoogleFonts.openSans(
                  fontSize: 18,
                ),),
                const SizedBox(height: 10,),
                authProvider.isLoading ? const SizedBox.shrink() :
                TextButton(onPressed: (){
                  // resend code
                }, child: Text('Resend',style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                )))

              ],
            ),
          ) ,
        ),
      ),
    );
  }
  void verifyOTP({required String otpCode,required String verificationId}) async {
    final authProvider = context.read<AuthProvider>();
    authProvider.verifyOtp(
        verificationId: verificationId,
        otpCode: otpCode,
        context: context,
        onSuccess: () async {
          // Navigator.of(context).pushNamedAndRemoveUntil(Constant.home, (route) => false);
          // check if user exists in firebase
          bool userExists = await authProvider.checkUserExists();

          if (userExists) {
            await authProvider.getUserDataFromFirestore();
            await authProvider.saveUserDataToSP();
            navigate(userExists:true);

            //
          } else {
            navigate(userExists:false);

          }

        },
    );

  }

  void navigate({required bool userExists}) {
    if (userExists) {
      //navigate to home screen and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil(Constant.home, (route) => false);
    } else {
      //navigate to userInfo screen
      Navigator.pushNamed(context, Constant.userInfo);

    }
  }
}
