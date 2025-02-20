import 'package:flutter/material.dart';
import 'package:notes_app/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DbHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DbHelper.instance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  void deleteNote(int id) async {
    await dbRef!.deleteNote(sno: id); // Pass as named argument
    getNotes();
  }

  void showEditBottomSheet(Map<String, dynamic> note) {
    titleController.text = note[DbHelper.COLUMN_NOTE_TITLE];
    descController.text = note[DbHelper.COLUMN_NOTE_DESC];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheetView(
          dbRef: dbRef!,
          titleController: titleController,
          descController: descController,
          refreshNotes: getNotes,
          isEditing: true,
          noteId: note[DbHelper.COLUMN_NOTE_SNO], // Pass note ID for update
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body:
          allNotes.isNotEmpty
              ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: Text(
                      '${allNotes[index][DbHelper.COLUMN_NOTE_SNO]}',
                    ),
                    title: Text(allNotes[index][DbHelper.COLUMN_NOTE_TITLE]),
                    subtitle: Text(allNotes[index][DbHelper.COLUMN_NOTE_DESC]),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => showEditBottomSheet(allNotes[index]),
                            child: Icon(Icons.edit, color: Colors.blue),
                          ),
                          InkWell(
                            onTap:
                                () => deleteNote(
                                  allNotes[index][DbHelper.COLUMN_NOTE_SNO],
                                ),
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
              : Center(child: Text("No Notes yet!!")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheetView(
                dbRef: dbRef!,
                titleController: titleController,
                descController: descController,
                refreshNotes: getNotes,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BottomSheetView extends StatefulWidget {
  final DbHelper dbRef;
  final TextEditingController titleController;
  final TextEditingController descController;
  final VoidCallback refreshNotes;
  final bool isEditing;
  final int? noteId; // Note ID for editing

  const BottomSheetView({
    super.key,
    required this.dbRef,
    required this.titleController,
    required this.descController,
    required this.refreshNotes,
    this.isEditing = false,
    this.noteId,
  });

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  String errorMsg = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEditing ? 'Edit Note' : 'Add Note',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 21),
            TextField(
              controller: widget.titleController,
              decoration: InputDecoration(
                hintText: "Enter title here",
                label: Text("Title *"),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            SizedBox(height: 21),
            TextField(
              controller: widget.descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter Description here",
                label: Text("Description *"),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            SizedBox(height: 21),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1, color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: () async {
                      var title = widget.titleController.text;
                      var desc = widget.descController.text;

                      if (title.isNotEmpty && desc.isNotEmpty) {
                        bool check;
                        if (widget.isEditing) {
                          check = await widget.dbRef.updateNote(
                            id: widget.noteId!,
                            mTitle: title,
                            mDesc: desc,
                          );
                        } else {
                          check = await widget.dbRef.addNote(
                            mTitle: title,
                            mDesc: desc,
                          );
                        }

                        if (check) {
                          widget.refreshNotes();
                          widget.titleController.clear();
                          widget.descController.clear();
                        }
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          errorMsg = "*Please fill all required blanks";
                        });
                      }
                    },
                    child: Text(widget.isEditing ? "Update Note" : "Add Note"),
                  ),
                ),
                SizedBox(width: 11),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1, color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                ),
              ],
            ),
            if (errorMsg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMsg,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
