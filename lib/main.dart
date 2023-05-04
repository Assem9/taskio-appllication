import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_helper/business_logic/app_cubit/app_cubit.dart';
import 'package:task_helper/business_logic/app_cubit/app_states.dart';
import 'package:task_helper/business_logic/cacheHelper.dart';
import 'package:task_helper/business_logic/task_cubit/task_cubit.dart';
import 'app_router.dart';
import 'business_logic/bloc_observer.dart';
import 'constants/strings.dart';
import 'constants/themes.dart';
import 'models/task.dart';
import 'models/task_type_enum.dart';
import 'models/user.dart';

void hiveRegisters(){
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskTypeAdapter());
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  //FlutterNativeSplash.remove();
  await CacheHelper.init();
  hiveRegisters();
  await getApplicationDocumentsDirectory()
      .then((value) => directoryPath = value.path);
  await Hive.initFlutter(directoryPath);
  Bloc.observer = MyBlocObserver();
  isDark = CacheHelper.getData(key: 'isDark');
  isDark ??= true;
  currentAccKey = CacheHelper.getData(key: 'currentKey');
  allKeys = CacheHelper.getList('allKeys');
  //allKeys ??= [];
  runApp( MyApp(appRouter: AppRouter(), isDark: isDark!,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter, required this.isDark});
  final AppRouter appRouter;
  final bool isDark ;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=> AppCubit()..changeTheme(isDark)..setWeekDates()),
        BlocProvider(create: (BuildContext context)=> TaskCubit()..openDataBase()),
      ],
      child: BlocBuilder<AppCubit,AppStates>(
        builder: (context, state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TASKEU',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            onGenerateRoute: appRouter.generateRoute,
            //home: const TestScreen(),
          );
        },

      ),
    );
  }
}

