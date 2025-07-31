import 'package:flutter/material.dart';
import 'package:flutter_clean_architect/providers/album_provider.dart';
import 'package:flutter_clean_architect/repositories/album_repository.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Master Dio"),
      ),
      body: Consumer<AlbumProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          return ListView.builder(
            itemCount: provider.albums.length,
            itemBuilder: (context, index) {
              final album = provider.albums[index];
              return ListTile(
                title: Text(album.title),
                subtitle: Text('Album ID: ${album.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
