import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screens/login_screen.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback onpress;
  const RoundButton({
    Key? key,
    required this.onpress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 75.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(36)),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFC466B).withOpacity(0.85),
              const Color(0xFF3F5EFB).withOpacity(0.21),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: GoogleFonts.barlow(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.04,
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
