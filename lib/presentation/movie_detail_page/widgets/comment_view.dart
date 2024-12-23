import 'package:flutter/material.dart';

class CommentCardView extends StatelessWidget {
  const CommentCardView(
      {super.key,
      required this.username,
      required this.comment,
      required this.date});

  final String username;
  final String comment;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Text(username.substring(0, 2).toUpperCase(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(comment),
                    ]),
              ),
              Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
