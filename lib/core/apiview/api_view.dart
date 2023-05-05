import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ApiView<T extends Cubit> extends StatelessWidget {
  const ApiView({super.key});
  T get cubit => WalletInjector.instance.getIt.get<T>();
}

abstract class StatefulApiView<T extends Cubit> extends StatefulWidget {
  const StatefulApiView({super.key});
  T get cubit => WalletInjector.instance.getIt.get<T>();
}
