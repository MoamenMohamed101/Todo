import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';
import 'package:todo/layout/layout_screen.dart';
import 'package:todo/modules/splash_screen.dart';
import 'package:todo/shared/network/local/get_helper.dart';
import 'package:todo/shared/network/local/local_notification_service.dart';
import 'package:todo/shared/network/local/shared_helper.dart';
import 'package:todo/shared/themes/themes.dart';
import 'shared/bloc_observer.dart';
// https://stackoverflow.com/questions/68265930/java-lang-runtimeexception-missing-type-parameter-error-on-released-apk
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  Future.wait([
    LocalNotificationService.init(),
    //WorkManager().init(),
  ]);
  await setup();
  await getIt<SharedHelper>().init();
  bool isOnBoarding =
      await getIt<SharedHelper>().getData(key: 'isOnBoarding') ?? false;
  runApp(
    MyApp(
      isOnBoarding: isOnBoarding,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isOnBoarding;

  const MyApp({super.key, required this.isOnBoarding});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoLayoutCubit()..createDataBase(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context , child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: isOnBoarding ? LayoutScreen() : const SplashScreen(),
          );
        },
      ),
    );
  }
}
