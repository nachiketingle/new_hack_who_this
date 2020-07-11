import 'package:flutter/material.dart';
import 'Helpers/Constants.dart';
import 'Pages/ImportAllPages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

void main() async {
  await DotEnv().load('.env');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Constants.primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat'
      ),
      routes: {
        '/': (context) => Home(),
        '/createGroup': (context) => CreateGroup(),
        '/joinGroup': (context) => JoinGroup(),
        '/lobby': (context) => Lobby(),
        '/chooseWord': (context) => ChooseWord(),
        '/previousSketch': (context) => PreviousSketch(),
        '/createSketch': (context) => CreateSketch(),
        '/submitSketch': (context) => SubmitSketch(),
        '/guessWord': (context) => GuessWord(),
        '/resultsWords': (context) => ResultsWords(),
        '/resultsSketches': (context) => ResultsSketches(),
      },
      initialRoute: '/',
    );
  }
}
