import 'package:calcript/providers/notes.dart';
import 'package:calcript/utilities/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeleteNoteScreen extends StatefulWidget {
  final String docId;
  const DeleteNoteScreen({
    required this.docId,
    super.key,
  });

  @override
  State<DeleteNoteScreen> createState() => _DeleteNoteScreenState();
}

class _DeleteNoteScreenState extends State<DeleteNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Warning",
        style: GoogleFonts.inter(
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Are you sure you want to delete this note?",
        style: GoogleFonts.inter(
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: bcolor),
            onPressed: () async {
              Provider.of<Notes>(context, listen: false)
                  .deleteNote(docId: widget.docId, context: context);
              Navigator.of(context).pop();
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: bcolor),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
