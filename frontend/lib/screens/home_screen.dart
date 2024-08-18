import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<QuizProvider>(context, listen: false).fetchQuizzes());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Quiz App'),
            actions: [
              IconButton(
                icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
          body: Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              if (quizProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (quizProvider.error.isNotEmpty) {
                return Center(child: Text('Error: ${quizProvider.error}'));
              }
              if (quizProvider.quizzes.isEmpty) {
                return Center(child: Text('No quizzes available'));
              }
              return ListView.builder(
                itemCount: quizProvider.quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizProvider.quizzes[index];
                  return ListTile(
                    title: Text(quiz.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(quiz: quiz),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
