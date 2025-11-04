import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itd_2/presentation/blocs/daily_bonus_bloc/bloc.dart';
import 'package:itd_2/presentation/blocs/main_bloc/bloc.dart';
import 'package:itd_2/presentation/blocs/onboarding_bloc/bloc.dart';
import 'package:itd_2/presentation/screens/main/loading/loading/loading_screen.dart';
import 'package:itd_2/routes/app_router.dart';

import './core/constants/app_colors.dart';
import './core/constants/app_text.dart';
import 'data/datasources/local/sound_service.dart';
import 'data/datasources/local/storage_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final storageService = StorageService();
  await storageService.init();

  // Initialize SoundService with saved settings
  final soundService = SoundService();
  await soundService.init();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  const MyApp({super.key, required this.storageService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnboardingBloc(storageService: storageService)),
        BlocProvider(create: (_) => MainBloc(storage: storageService)),
        BlocProvider(create: (_) => BonusBloc(storage: storageService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Platform.isAndroid
            ? AppTexts.appAndroidTitle
            : AppTexts.appIosTitle,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          scaffoldBackgroundColor: AppColors.topBlue80,
          fontFamily: 'Knewave',
        ),
        initialRoute: LoadScreen.routeName,
        onGenerateRoute: AppNavigator.generateRoutes,
      ),
    );
  }
}

