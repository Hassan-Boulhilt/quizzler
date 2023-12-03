import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:quizzler/quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 49, 48, 48),
        body: Center(
          child: QuizPage(),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  var correctAnswerScore = 0;
  var wrongAnswerScore = 0;
  var questionListLength = 0;

  bool exit = false;
  QuizeBrain questions = QuizeBrain();

  void checkAnswer(bool userAnswer) {
    bool answer = questions.getQuestionAnswer();
    setState(() {
      if (answer == userAnswer) {
        scoreKeeper.add(
          const Icon(Icons.check, color: Colors.green),
        );
        correctAnswerScore++;
      } else {
        scoreKeeper.add(
          const Icon(Icons.close, color: Colors.red),
        );
        wrongAnswerScore++;
      }
    });
    if (questions.hasNext()) {
      questions.nextQuestion();
    } else {
      displayAlert();
    }
  }

  void reinitialiserEtat() {
    setState(() {
      questions.initCursor();
      scoreKeeper = [];
      correctAnswerScore = 0;
      wrongAnswerScore = 0;
    });
  }

  void displayAlert() {
    Alert(
      context: context,
      type: correctAnswerScore > wrongAnswerScore
          ? AlertType.success
          : AlertType.warning,
      title: correctAnswerScore > wrongAnswerScore
          ? "Congratulation!\nYour Score is:"
          : "Try again!\nYou Score is:",
      desc: "$correctAnswerScore / $questionListLength",
      buttons: [
        DialogButton(
          onPressed: () {
            // Check platform
            if (defaultTargetPlatform == TargetPlatform.android) {
              FlutterExitApp.exitApp();
            } else if (defaultTargetPlatform == TargetPlatform.iOS) {
              FlutterExitApp.exitApp(iosForceExit: true);
            }
          },
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          child: const Text(
            "Exit",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () {
            reinitialiserEtat();
            Navigator.pop(context);
          },
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    questionListLength = questions.getQuestionsLength();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                questions.getQuestionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.zero),
              ),
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.zero),
              ),
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Wrap(
            direction: Axis.horizontal,
            children: scoreKeeper
                .map(
                  (i) => i,
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
