import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:flutter/foundation.dart';

abstract class BaseRepository {
  @protected
  final NetworkService networkService;

  const BaseRepository(this.networkService);
}
