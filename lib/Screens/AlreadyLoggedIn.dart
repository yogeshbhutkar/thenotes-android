import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thenotes/Screens/login_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/rounded_button.dart';
import 'HomePage.dart';

late User loggedIn;

class AlreadyLogged extends StatefulWidget {
  static String id = 'AlreadyLogged';
  AlreadyLogged({super.key});

  @override
  State<AlreadyLogged> createState() => _AlreadyLoggedState();
}

class _AlreadyLoggedState extends State<AlreadyLogged> {
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
      //
    }
  }

  ImageProvider img() {
    if (loggedIn.photoURL.toString().isNotEmpty) {
      return NetworkImage(loggedIn.photoURL.toString());
    } else {
      return const AssetImage('images/man.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18, top: 12),
          child: GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: Text(
              'Log Out',
              style: GoogleFonts.barlow(
                fontSize: 18,
              ),
            ),
          ),
        )
      ]),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: img(),
                  radius: 75,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  loggedIn.displayName.toString().isNotEmpty
                      ? loggedIn.displayName.toString()
                      : 'User',
                  style: GoogleFonts.barlow(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
            RoundButton(onpress: () {
              Navigator.pushNamed(context, HomePage.id);
            })
          ],
        ),
      ),
    );
  }
}
