import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_note/models/note.dart';
import 'package:simple_note/pages/add_note_page.dart';

import '../pages/home_page.dart';

class AppRoutes {
  static const home = 'home';
  static const addnote = 'add-note';
  static const editnote = 'edit-note';

  static Page _homePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(
      child: HomePage(),
    );
  }

  static Page _addNotePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(
      child: AddNotePage(),
    );
  }

  static Page _editNotePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return MaterialPage(
      child: AddNotePage(
        note: state.extra as Note,
      ),
    );
  }

  static GoRouter goRouter = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: home,
      pageBuilder: _homePageBuilder,
      routes: [
        GoRoute(
          path: 'add-note',
          name: addnote,
          pageBuilder: _addNotePageBuilder,
        ),
        GoRoute(
          path: 'edit-note',
          name: editnote,
          pageBuilder: _editNotePageBuilder,
        ),
      ],
    ),
  ]);
}
