import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thenotes/Screens/home_page.dart';
import 'package:thenotes/Screens/login_screen.dart';
import 'package:thenotes/pages/welcome_page.dart';

final _auth = FirebaseAuth.instance;
ImageProvider img() {
  if (loggedIn.photoURL.toString() != "null") {
    return NetworkImage(loggedIn.photoURL.toString());
  } else {
    return const AssetImage('images/man.png');
  }
}

final googleSignIn = GoogleSignIn();
late User loggedIn;
String _userName = loggedIn.displayName.toString();

class UserProfile extends StatefulWidget {
  static String id = 'user_profile';
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedIn = user;
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                child: Stack(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 185, 67, 91), width: 2),
                      color: Color.fromARGB(255, 32, 32, 32),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        left: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 45, right: 15),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                _userName,
                                style: GoogleFonts.barlow(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'e-mail',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  Text(
                                    loggedIn.email.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25, top: 20),
                            child: Center(
                              child: MaterialButton(
                                color: Color.fromARGB(255, 211, 28, 64),
                                onPressed: () {
                                  _auth.signOut();
                                  googleSignIn.disconnect();
                                  Navigator.pushNamed(context, LoginScreen.id);
                                },
                                child: const Text(
                                  'Sign Out',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'hero1',
                    child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 51, 50, 56),
                            radius: 50.0,
                            backgroundImage: img(),
                          ),
                        )),
                  ),
                ]),
              ),
            ],
          )),
    );
  }
}
