import 'package:flutter_clean_architect/model/album.dart';
import 'package:flutter_clean_architect/network/api_result.dart';
import 'package:flutter_clean_architect/network/network_module.dart';

class AlbumRepository {
  Future<ApiResult<List<Album>>> getAlbums() async {
    return NetworkModule.networkManager.get<List<Album>>(
      "/albums",
      parser: (data) =>
          (data as List).map((json) => Album.fromJson(json)).toList(),
    );
  }
}
