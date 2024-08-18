import 'package:flutter/foundation.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';

class QuizProvider with ChangeNotifier {
  List<Quiz> _quizzes = [];
  bool _isLoading = false;
  String _error = '';

  List<Quiz> get quizzes => _quizzes;
  bool get isLoading => _isLoading;
  String get error => _error;

  final QuizService _quizService = QuizService();

  Future<void> fetchQuizzes() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _quizzes = await _quizService.getQuizzes();
    } catch (error) {
      _error = error.toString();
      print('Error fetching quizzes: $_error');
    }

    _isLoading = false;
    notifyListeners();
  }
}