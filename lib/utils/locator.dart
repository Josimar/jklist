import 'package:get_it/get_it.dart';

import 'package:jklist/services/dialog_service.dart';
import 'package:jklist/services/navigator_service.dart';

import 'package:jklist/services/firebase_service.dart';
import 'package:jklist/services/firestore_service.dart';

import 'package:jklist/view/categoria/categoria_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => FirestoreService());

  locator.registerLazySingleton(() => CategoriaService());
}
