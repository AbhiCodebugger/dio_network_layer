import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architect/network/dio_factory.dart';
import 'package:flutter_clean_architect/network/network_failure.dart';
import 'package:flutter_clean_architect/network/network_manager.dart';
import 'package:flutter_clean_architect/model/album.dart';
import 'package:flutter_clean_architect/providers/base_provider.dart';
import 'package:flutter_clean_architect/repositories/album_repository.dart';

class AlbumProvider extends BaseProvider {
  late AlbumRepository _albumRepository;

  AlbumProvider(AlbumRepository repository) {
    _albumRepository = repository;
  }

  List<Album> _albums = [];
  List<Album> get albums => _albums;

  Future<void> fetchAlbums() async {
    setLoading(true);
    clearError();
    final result = await _albumRepository.getAlbums();

    setLoading(false);

    result.when(
      success: (data, statusCode) {
        _albums = data;
        notifyListeners();
      },
      failure: (NetworkFailure f) {
        setError("Something went wrong: ${f.message}");
      },
    );
  }
}
