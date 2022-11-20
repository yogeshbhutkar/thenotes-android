import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Message',
  hintStyle: TextStyle(color: Colors.grey),
  border: InputBorder.none,
);

const kMessageSearchTextFieldDecoration = InputDecoration(
  hintText: 'Message',
  prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 247, 11, 58)),
  filled: true,
  fillColor: Color.fromARGB(255, 17, 17, 17),
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 75, 74, 77), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 94, 91, 91), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.grey, width: 2.0),
  ),
);

const kDrawerTextStyleDark =
    TextStyle(color: Color.fromARGB(255, 190, 189, 189));
const KDrawerTextStyleLight = TextStyle(color: Colors.black);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Color.fromARGB(255, 17, 17, 17),
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 75, 74, 77), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 163, 6, 37), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);
