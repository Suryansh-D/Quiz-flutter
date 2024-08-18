import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';

class QuizService {
  final String baseUrl = 'http://localhost:8080';  // Ensure this matches your Go server port

  Future<List<Quiz>> getQuizzes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/quizzes'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> quizzesJson = data['quizzes'];
        return quizzesJson.map((json) => Quiz.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load quizzes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Failed to load quizzes: $e');
    }
  }
}