import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:thenotes/Screens/AlreadyLoggedIn.dart';
import 'package:thenotes/Screens/HomePage.dart';
import 'package:thenotes/Screens/login_screen.dart';
import 'package:thenotes/Screens/registration_screen.dart';

bool isSignedIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Color.fromARGB(255, 20, 19, 19),
      systemNavigationBarDividerColor: Color.fromARGB(255, 20, 19, 19),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));

//Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      isSignedIn = true;
    }
  });
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "The Notes",
      debugShowCheckedModeBanner: false,
      initialRoute: isSignedIn ? AlreadyLogged.id : LoginScreen.id,
      routes: {
        HomePage.id: (context) => const HomePage(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        AlreadyLogged.id: ((context) => AlreadyLogged()),
      },
    );
  }
}
