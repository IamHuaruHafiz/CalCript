import 'package:calcript/providers/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateNoteScreen extends StatefulWidget {
  final String docId;
  final String content;
  const UpdateNoteScreen({
    super.key,
    required this.docId,
    required this.content,
  });

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _controller = TextEditingController(text: widget.content);
    _controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      setState(() {});
    });
    _controller.dispose();
    super.dispose();
  }

  var newString = "";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 30,
            )),
        backgroundColor: const Color.fromRGBO(33, 38, 47, 1),
        title: Text("Update note",
            style: GoogleFonts.inter(
              fontSize: 27,
              color: Colors.white,
            )),
        centerTitle: true,
        actions: [
          Visibility(
            visible: _controller.text.isNotEmpty,
            child: IconButton(
                onPressed: () {
                  final note = _controller.text.trimLeft();
                  if (widget.content == note) {
                    Navigator.of(context).pop();
                  } else {
                    Provider.of<Notes>(
                      context,
                      listen: false,
                    ).updateNote(
                      note: note,
                      docId: widget.docId,
                      context: context,
                    );
                  }
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: height * 90,
          width: width,
          child: TextField(
            onChanged: (str) {
              newString = str;
            },
            onSubmitted: (_) {
              final note = _controller.text;
              if (widget.content == note) {
                Navigator.of(context).pop();
              } else {
                Provider.of<Notes>(
                  context,
                  listen: false,
                ).updateNote(
                  note: note,
                  docId: widget.docId,
                  context: context,
                );
              }
            },
            keyboardType: TextInputType.text,
            controller: _controller,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 21,
            ),
            maxLines: null,
            decoration: const InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(8),
                hintText: "Update your note"),
          ),
        ),
      ),
    );
  }
}
