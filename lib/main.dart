import 'package:flutter/material.dart';
import 'package:flutter_clean_architect/network/network_module.dart';
import 'package:flutter_clean_architect/presentation/home_page.dart';
import 'package:flutter_clean_architect/providers/album_provider.dart';
import 'package:flutter_clean_architect/repositories/album_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NetworkModule.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AlbumProvider(AlbumRepository())..fetchAlbums(),
        ),
      ],
      child: MaterialApp(
        title: 'Master Dio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
