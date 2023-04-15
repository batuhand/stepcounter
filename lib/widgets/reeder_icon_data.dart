import 'package:flutter/material.dart';

class ReederIconData extends StatelessWidget {
  final Color avatarColor;
  final Widget icon;
  final String text;

  const ReederIconData(
      {Key? key,
      required this.avatarColor,
      required this.icon,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          child: icon,
          backgroundColor: avatarColor,
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
            width: 70,
            child: Text(
              text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }
}
