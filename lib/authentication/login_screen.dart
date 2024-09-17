import 'package:chat_hub/utilites/assets_manager.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  Country selectedCountry = Country(
    phoneCode: "20",
    countryCode: "EG",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Egypt",
    example: "Egypt",
    displayName: "Egypt",
    displayNameNoCountryCode: "EG",
    e164Key: '',
  );
  void dispose() {
    _phoneNumberController.dispose();
    _btnController.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(AssetsManager.chatbubble),
              ),
              const SizedBox(height: 20),
              Text(
                'ChatHub',
                style: GoogleFonts.openSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
               Text(
                  'Add your phone number to send you a code to verify.',
                style: GoogleFonts.openSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                 textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneNumberController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (value){
                  setState(() {
                    _phoneNumberController.text = value;
                  });
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Phone number',
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 15,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          countryListTheme: const CountryListThemeData(
                            bottomSheetHeight: 500,
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country;
                            });
                          },
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  suffixIcon: _phoneNumberController.text.length >9
                      ? authProvider.isLoading
                          ?const CircularProgressIndicator()
                            : InkWell(
                        onTap: (){
                          authProvider.signInWithPhone(
                            phoneNumber: '+${selectedCountry.phoneCode}${_phoneNumberController.text}',
                            context: context
                          );
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,

                          ),
                          child: const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          ),
                                          ),
                      ):null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
