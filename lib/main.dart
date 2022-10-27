import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/hive_constants.dart';
import 'package:thefood/constants/text_styles.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<String>(HiveConstants.loginCredentials);
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  runApp(const TheFood());
}

class TheFood extends StatefulWidget {
  const TheFood({super.key});

  @override
  State<TheFood> createState() => _TheFoodState();
}

class _TheFoodState extends State<TheFood> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: ProjectTexts.appName,
      theme: ThemeData(
        scaffoldBackgroundColor: ProjectColors.mainWhite,
        useMaterial3: true,
        textTheme: ProjectTextStyles().textTheme,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        cardTheme: const CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
