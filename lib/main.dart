import 'package:expense_tracker/res/getx_loclization/languages.dart';
import 'package:expense_tracker/res/routes/routes.dart';
import 'package:expense_tracker/res/routes/routes_name.dart';
import 'package:expense_tracker/view_models/controller/theme_controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();
  Get.put(ThemeController());
  await Supabase.initialize(
    url: "https://hnuyvvusuumtixjekhne.supabase.co",
    anonKey: "sb_publishable_MigUHnBYtxqPjOulBu_VXQ_bCfSMdUT",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        translations: Languages(),
        locale: const Locale('en' ,'US'),
        fallbackLocale: const Locale('en' ,'US'),
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(), // Dark theme settings
        themeMode: ThemeMode.light,
        getPages: AppRoutes.appRoutes(),
        // home:  MainView(),
        initialRoute: RouteName.splashScreen,
        // AppRoutes.appRoutes(),
      );

  }
}

