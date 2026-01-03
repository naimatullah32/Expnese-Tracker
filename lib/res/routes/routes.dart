


import 'package:expense_tracker/res/routes/routes_name.dart';
import 'package:expense_tracker/view/AuthScreen/SignUp.dart';
import 'package:expense_tracker/view/home_view/navbar.dart';
import 'package:expense_tracker/view/profile_view/profileView.dart';
import 'package:expense_tracker/view/settingView/settingView.dart';
import 'package:get/get.dart';
import '../../view/AuthScreen/LoginView.dart';
import '../../view/AuthScreen/NewPasswordView.dart';
import '../../view/AuthScreen/OPTScreen.dart';
import '../../view/AuthScreen/forgotPassword.dart';
import '../../view/AuthScreen/password_success_screen.dart';
import '../../view/home_view/HomeView.dart';
import '../../view/splash_screen.dart';


class AppRoutes {

  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreen() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.mainView,
      page: () => MainView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.SignUp,
      page: () => SignUpView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.loginView,
      page: () => LoginView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.forgotPasswordView,
      page: () => ForgotPasswordView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.verificationCodeView,
      page: () => VerificationCodeView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.NewPasswordView,
      page: () => NewPasswordView(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.passSuccess,
      page: () => PasswordSuccessView(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.settingView,
      page: () => SettingsView(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.homeView,
      page: () => MainView(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.profileView,
      page: () => ProfileView(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,


  ];

}