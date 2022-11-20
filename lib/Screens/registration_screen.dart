import 'package:auth_buttons/auth_buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

String validateError = '';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final googleSignIn = GoogleSignIn();
  late GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = '';
  late String password;
  String displayName = '';

  bool validateUser() {
    if (displayName.length == 0 || password.length == 0 || email.length == 0) {
      setState(() {
        validateError = "Enter all the fields";
      });
      return false;
    }
    if (password.length <= 7) {
      setState(() {
        validateError = "Password should contain more than 7 characters";
      });
      return false;
    }
    if (!email.contains('@')) {
      setState(() {
        validateError = "Email format is found to be incorrect";
      });

      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.10),
                    child: AutoSizeText(
                      'Register',
                      maxLines: 1,
                      style: GoogleFonts.barlow(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: AutoSizeText(
                      displayName,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        textStyle: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Email'),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          displayName = value;
                        });
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Username'),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
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

                        await FirebaseAuth.instance
                            .signInWithCredential(credential);

                        Navigator.pushNamed(context, HomePage.id);
                      },
                      style: const AuthButtonStyle(
                          iconType: AuthIconType.secondary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        validateError,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.07),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          child: const Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoundButton(
                    onpress: () async {
                      if (validateUser()) {
                        try {
                          setState(() {
                            showSpinner = true;
                          });

                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          var user = FirebaseAuth.instance.currentUser;
                          user?.updateDisplayName(displayName);
                          Navigator.pushNamed(context, HomePage.id);
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          //
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
