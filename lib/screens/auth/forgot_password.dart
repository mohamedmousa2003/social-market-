import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:social_market/services/assets_manager.dart';
import 'package:social_market/widgets/app_name.text.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';

import '../../consts/my_validators.dart';

class ForgotPassword extends StatefulWidget {
  static const routName = '/ForgotPassword';
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _emailController;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
    }
    super.dispose();
  }

  Future<void> _forgetPasswordFCT() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppNameTextWidget(),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            FocusScope.of(context).unfocus();
          });
        },
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset(
                AssetsMamager.forgotPassword,
                height: size.height * .35,
                width: size.width * .6,
              ),
              SizedBox(
                height: 10,
              ),
              TitleTextWidget(
                label: "Forgot password",
                fontsize: 22,
              ),
              SubtitleTextWidget(
                label:
                    "please enter the email address you 'd like your password reset information sent to ",
                fontsize: 14,
              ),
              SizedBox(
                height: 25,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Email Address",
                            prefixIcon: Icon(
                              IconlyLight.message,
                            )),
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                        onFieldSubmitted: (value) {},
                      ),
                    ],
                  )),
              SizedBox(
                height: 25,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12),
                  // backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  _forgetPasswordFCT();
                },
                icon: const Icon(
                  IconlyBold.send,
                  // color: Colors.white,
                ),
                label: const Text(
                  "Request link",
                  // style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
