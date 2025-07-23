import 'package:flutter_clean_architect/network/dio_factory.dart';
import 'package:flutter_clean_architect/network/network_manager.dart';

class NetworkModule {
  static late final NetworkManager networkManager;

  static Future<void> init() async {
    final netWorkManager = DioFactory(
      baseUrl: "https://jsonplaceholder.typicode.com",
      defaultHeader: {"Content-Type": "application/json"},
      enableLogging: true,
      tokenProvider: null,
      onRefreshTokenFn: null,
      maxRetries: 3,
    ).createDio();
    networkManager = NetworkManager(netWorkManager);
  }
}
