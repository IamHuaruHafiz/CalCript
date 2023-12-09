import 'package:calcript/providers/notes.dart';
import 'package:calcript/utilities/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _controller = TextEditingController();
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
        backgroundColor: bcolor,
        title: Text(
          "Notes",
          style: GoogleFonts.inter(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Visibility(
            visible: _controller.text.isNotEmpty,
            child: IconButton(
                onPressed: () {
                  final note = _controller.text.trimLeft();
                  Provider.of<Notes>(context, listen: false)
                      .addNote(note: note, context: context);
                  Navigator.of(context).pop();
                  _controller.clear();
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
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              final note = _controller.text.trimLeft();
              Provider.of<Notes>(context, listen: false)
                  .addNote(note: note, context: context);
              Navigator.of(context).pop();
              _controller.clear();
            },
            keyboardType: TextInputType.text,
            controller: _controller,
            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w400),
            maxLines: null,
            decoration: const InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                contentPadding: EdgeInsets.all(8),
                hintText: "Put down something..."),
          ),
        ),
      ),
    );
  }
}
