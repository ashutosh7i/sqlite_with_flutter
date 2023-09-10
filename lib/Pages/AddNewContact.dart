import 'package:flutter/material.dart';

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 30, top: 20, right: 30),
        child: Column(children: [
          Row(
            children: [Text("Name-"), Expanded(child: TextField())],
          ),
          Row(
            children: [Text("Number-"), Expanded(child: TextField())],
          ),
          Row(
            children: [Text("Email-"), Expanded(child: TextField())],
          ),
          Row(
            children: [Text("Notes-"), Expanded(child: TextField())],
          )
        ]));
  }
}
