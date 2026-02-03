import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nortus/presentation/cubits/auth/auth_cubit.dart';

class RouterNotifier extends ChangeNotifier {
  final AuthCubit authCubit;
  late final StreamSubscription _subscription;

  RouterNotifier(this.authCubit) {
    _subscription = authCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  AuthState get authState => authCubit.state;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
