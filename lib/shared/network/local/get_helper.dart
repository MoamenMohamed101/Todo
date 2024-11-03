import 'package:get_it/get_it.dart';
import 'package:todo/shared/network/local/shared_helper.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerLazySingleton<SharedHelper>(
    () => SharedHelper(),
  );
}
