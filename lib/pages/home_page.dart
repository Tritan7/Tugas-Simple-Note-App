import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/db/database_service.dart';
import 'package:simple_note/extensions/format_date.dart';
import 'package:simple_note/models/note.dart';
import 'package:simple_note/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simple Notes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(DatabaseService.boxName).listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Tidak ada catatan'),
            );
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final note = box.getAt(index);
                return NoteCard(
                  note: note,
                  databaseService: dbService,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed('add-note');
        },
        child: const Icon(
          Icons.note_add_rounded,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.databaseService,
  });

  final Note note;
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.key.toString()),
      onDismissed: (_) {
        databaseService.deleteNote(note).then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  content: Text('Catatan berhasil dihapus'),
                ),
              ),
            });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.deepPurple[100],
        ),
        child: ListTile(
          onTap: () {
            GoRouter.of(context).pushNamed(
              AppRoutes.editnote,
              extra: note,
            );
          },
          title: Text(
            note.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(note.desc),
          trailing: Text('Dibuat pada:\n${note.createdAt.formatDate()}'),
        ),
      ),
    );
  }
}
