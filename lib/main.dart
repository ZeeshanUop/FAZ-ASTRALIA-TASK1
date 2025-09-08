import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/models/notes.dart';
import 'data/repository/notes_repository.dart';
import 'data/services/post_services.dart';
import 'features/notes/view_model/notes_model.dart';
import 'features/post/view_model/post_view_model.dart';
import 'features/settings/view_model/theme_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapter and open boxes
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');
  await Hive.openBox('settingsBox');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeViewModel()..load()),
      Provider(create: (_) => NotesRepository()),
      ChangeNotifierProxyProvider<NotesRepository, NotesViewModel>(
        create: (_) => NotesViewModel(NotesRepository())..load(),
        update: (_, repo, __) => NotesViewModel(repo)..load(),
      ),
      Provider(create: (_) => PostsService()),
      ChangeNotifierProvider(create: (_) => PostsViewModel(PostsService())),
    ],
    child: const MyApp(),
  ));
}
