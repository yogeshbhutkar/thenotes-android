import 'package:auth_buttons/auth_buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:thenotes/Screens/home_page.dart';
import 'package:thenotes/Screens/registration_screen.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final googleSignIn = GoogleSignIn();
  late GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = "";
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SafeArea(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.15),
                        child: AutoSizeText(
                          'Log In',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.barlow(
                            textStyle: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 45),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Password')),
                  const SizedBox(
                    height: 24.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Divider(
                      color: Color.fromARGB(255, 196, 9, 46),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GoogleAuthButton(
                        themeMode: ThemeMode.dark,
                        onPressed: () async {
                          final googleUser = await googleSignIn.signIn();
                          if (googleUser == null) return;
                          _user = googleUser;

                          final googleAuth = await googleUser.authentication;

                          final credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );

                          final exUser = await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(context, HomePage.id);
                        },
                        style: const AuthButtonStyle(
                            iconType: AuthIconType.secondary),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don’t have an account ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                          child: const Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoundButton(
                    onpress: () async {
                      try {
                        setState(() {
                          showSpinner = true;
                        });
                        final existingUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, HomePage.id);
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        const Text('Error Occured.');
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
