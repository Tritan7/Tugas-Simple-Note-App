import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_note/db/database_service.dart';
import 'package:simple_note/models/note.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({
    super.key,
    this.note,
  });

  final Note? note;

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;

  DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    _titleController = TextEditingController();
    _descController = TextEditingController();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descController.text = widget.note!.desc;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note != null ? "Edit Note" : "Add Note",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Masukkan Judul',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: _descController,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Masukkan Deskripsi',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Note note = Note(
            _titleController.text,
            _descController.text,
            DateTime.now(),
          );

          if (widget.note != null) {
            await dbService.editNote(widget.note!.key, note);
          } else {
            await dbService.addNote(note);
          }
          if (!mounted) return;
          GoRouter.of(context).pop();
        },
        label: const Text('Simpan'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
