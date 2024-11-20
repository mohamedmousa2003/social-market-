import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_market/root_screen.dart';
import 'package:social_market/services/my_app_methods.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});


  Future<void> _googleSignIn({required BuildContext context}) async {
    final googleSignIn = GoogleSignIn();

    try {
      final googleAccount = await googleSignIn.signIn();

      if (googleAccount == null) {
        print('Google sign-in canceled by user.');
        return; // User canceled the sign-in
      }

      final googleAuth = await googleAccount.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResults = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );

          if (authResults.user != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              Navigator.pushReplacementNamed(context, RootScreen.routName);
            });
          } else {
            throw FirebaseAuthException(
              code: 'USER_NOT_FOUND',
              message: 'User not found or could not be authenticated.',
            );
          }
        } on FirebaseAuthException catch (error) {
          print('FirebaseAuthException: ${error.message}');
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await MyAppMethods.showErrorOrWarningDialog(
              context: context,
              subtitle: "An Error occurred: ${error.message}",
              fct: () {},
            );
          });
        } catch (error) {
          print('Unknown error: $error');
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await MyAppMethods.showErrorOrWarningDialog(
              context: context,
              subtitle: "An Error occurred: $error",
              fct: () {},
            );
          });
        }
      } else {
        print('Access token or ID token is null');
        throw FirebaseAuthException(
          code: 'NULL_TOKENS',
          message: 'Google authentication tokens are null.',
        );
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await MyAppMethods.showErrorOrWarningDialog(
          context: context,
          subtitle: "An Error occurred: $error",
          fct: () {},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
        // backgroundColor: Colors.red,
      ),
      onPressed: () async {
         _googleSignIn(context: context);
      },
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        //style: TextStyle(color: Colors.white),
      ),
    );
  }
}
