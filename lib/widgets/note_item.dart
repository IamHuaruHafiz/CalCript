import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  final String content;
  final String id;
  final DateTime createdAt;
  const NoteItem({
    super.key,
    required this.content,
    required this.id,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black,
            offset: Offset(5, 5),
          )
        ],
        color: const Color.fromRGBO(33, 38, 47, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            id,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          content,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          createdAt.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
