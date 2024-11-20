import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_market/consts/my_validators.dart';
import 'package:social_market/root_screen.dart';
import 'package:social_market/screens/auth/register.dart';
import 'package:social_market/screens/inner_screens/loading_manager.dart';
import 'package:social_market/screens/inner_screens/orders/orders_screen.dart';
import 'package:social_market/widgets/app_name.text.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';

import '../../services/my_app_methods.dart';
import '../../widgets/auth/google_btn.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  static final routName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obsecureText = true;
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginfct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
        Fluttertoast.showToast(
            msg: "Logged in Successfully",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white,
        );
        if(!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      }on FirebaseAuthException catch (error) {
        await MyAppMethods.showErrorOrWarningDialog(
            context: context,
            subtitle: "An Error Occured ${error.message}",
            fct: () {});
      } catch(error){
        await MyAppMethods.showErrorOrWarningDialog(
            context: context,
            subtitle: "An Error Occured ${error}",
            fct: () {});

      }finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading:_isLoading ,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  AppNameTextWidget(),
                  SizedBox(
                    height: 60,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: TitleTextWidget(label: "Welcome Back")),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
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
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            textInputAction: TextInputAction.done,
                            obscureText: obsecureText,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obsecureText = !obsecureText;
                                    });
                                  },
                                  icon: Icon(
                                    obsecureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                hintText: "Password",
                                prefixIcon: Icon(
                                  IconlyLight.lock,
                                )),
                            validator: (value) {
                              return MyValidators.passwordValidator(value);
                            },
                            onFieldSubmitted: (value) {
                              _loginfct();
                            },
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ForgotPassword.routName);
                        },
                        child: SubtitleTextWidget(
                          label: "forget password?",
                          textDecoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(12),
                        // backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        _loginfct();
                      },
                      icon: const Icon(
                        IconlyBold.login,
                        // color: Colors.white,
                      ),
                      label: const Text(
                        "Sign in",
                        // style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SubtitleTextWidget(label: "OR CONNECT USING"),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(child: GoogleButton()),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            // backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            Navigator.pushReplacementNamed(context, RootScreen.routName);
                          },
                          child: const Text(
                            "Guest?",
                            // style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubtitleTextWidget(label: "Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterScreen.routName);
                          },
                          child: SubtitleTextWidget(
                            label: "Sign up",
                            textDecoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
