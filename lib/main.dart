import 'package:flutter/material.dart';
import 'package:quizzler/quizbrain.dart';

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
  var questionNumber = 0;
  bool exit = false;
  QuizeBrain questions = QuizeBrain();
  // Map<String, dynamic> myMap = {'$q1.questionText' : 'q1.questionAnswer'};

  @override
  Widget build(BuildContext context) {
    questionListLength = questions.questionBank.length;
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
                questions.questionBank[questionNumber].questionText,
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
                var correctAnswer =
                    questions.questionBank[questionNumber].questionAnswer;
                if (correctAnswer == true && exit == false) {
                  setState(() {
                    scoreKeeper.add(
                      const Icon(Icons.check, color: Colors.green),
                    );
                  });
                  correctAnswerScore++;
                } else if (correctAnswer == false && exit == false) {
                  setState(() {
                    scoreKeeper.add(
                      const Icon(Icons.close, color: Colors.red),
                    );
                  });
                  wrongAnswerScore++;
                }
                if (questionNumber < questionListLength - 1) {
                  questionNumber++;
                } else {
                  exit = true;
                  questions.questionBank[questionNumber].questionText =
                      'Finished, your score is $correctAnswerScore / $questionListLength';
                }
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
                var correctAnswer =
                    questions.questionBank[questionNumber].questionAnswer;
                if (correctAnswer == false && exit == false) {
                  setState(() {
                    scoreKeeper.add(
                      const Icon(Icons.check, color: Colors.green),
                    );
                  });
                  correctAnswerScore++;
                } else if (correctAnswer == true && exit == false) {
                  setState(() {
                    scoreKeeper.add(
                      const Icon(Icons.close, color: Colors.red),
                    );
                  });
                  wrongAnswerScore++;
                }
                if (questionNumber < questionListLength - 1) {
                  questionNumber++;
                } else {
                  questions.questionBank[questionNumber].questionText =
                      'Finished, your score is $correctAnswerScore / $questionListLength';
                  exit = true;
                }
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
