# Quiz-flutter
# Quiz App

A Flutter-based quiz application with a Go backend, featuring user authentication, quiz creation, and a dark mode toggle.

## Features

- User Authentication
- Quiz Listing and Taking
- Quiz Creation
- Dark Mode Toggle
- Animated UI Elements

## Getting Started

### Prerequisites

- Go 1.16+
- Flutter 2.0+
- Dart 2.12+

### Backend Setup

1. Navigate to the backend directory: cd backend
2. Install dependencies: go mod tidy
3. Run the server: go run main.go

The server will start on `http://localhost:8080`.

### Frontend Setup

1. Navigate to the frontend directory: cd frontend
2. Install dependencies: flutter pub get
3. Run the app: flutter run -d chrome --web-renderer html --web-browser-flag "--disable-web-security" 


To further enhance your project, consider adding these features:

User profile management
Leaderboard system
Quiz categories and difficulty levels
Timed quizzes
Social sharing of quiz results
Localization support for multiple languages