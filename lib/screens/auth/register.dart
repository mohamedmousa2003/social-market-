import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_market/consts/my_validators.dart';
import 'package:social_market/screens/inner_screens/loading_manager.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:social_market/widgets/app_name.text.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';

import '../../widgets/auth/pick_image_widget.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = '/RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  late final TextEditingController _emailController,
      _nameController,
      _passwordController,
      _confirmPasswordController;
  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obsecureText = true;
  XFile? _pickedImage;
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  String? userImageUrl;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _registerfct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
     if (_pickedImage == null) {
        MyAppMethods.showErrorOrWarningDialog(
            context: context, subtitle: "pick up an image", fct: () {});
      }
      try {
        setState(() {
          _isLoading = true;
        });

        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child('${_emailController.text.trim()}.jpg');

        await ref.putFile(File(_pickedImage!.path));

        userImageUrl = await ref.getDownloadURL();
        await auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim()
        );
        User? user = auth.currentUser;
        final uid = user!.uid;

        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId':uid,
          'userName' : _nameController.text,
          'userImage':userImageUrl,
          'userEmail': _emailController.text,
          'userWish': [],
          'userCart':[],
          'createdAt':Timestamp.now(),
        });
        Fluttertoast.showToast(
            msg: "Account Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white);
        if (!mounted)return;
        await Navigator.pushNamed(context, LoginScreen.routName);

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

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCt: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                  TitleTextWidget(label: "Welcome", fontsize: 25),
                  SizedBox(
                    height: 10,
                  ),
                  SubtitleTextWidget(label: "sign up now "),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: size.width * .3,
                    width: size.width * .3,
                    child: PickImageWidget(
                      function: () async {
                        await localImagePicker();
                      },
                      pickedImage: _pickedImage,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintText: "user name",
                                prefixIcon: Icon(
                                  IconlyLight.profile,
                                )),
                            validator: (value) {
                              return MyValidators.displayNamevalidator(value);
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
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
                            textInputAction: TextInputAction.next,
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
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFocusNode);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
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
                                hintText: " confirm Password",
                                prefixIcon: Icon(
                                  IconlyLight.password,
                                )),
                            validator: (value) {
                              return MyValidators.repaetPasswordValidator(
                                  password: _passwordController.text,
                                  value: value);
                            },
                            onFieldSubmitted: (value) {
                              _registerfct();
                            },
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(12),
                        // backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        setState(() {
                          _registerfct();

                        });
                      },
                      child: const Text(
                        "Sign up",
                        // style: TextStyle(color: Colors.white),
                      ),
                    ),
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
