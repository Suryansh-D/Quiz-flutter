package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	ID       string `json:"id"`
	Username string `json:"username"`
	Password string `json:"password"`
}

var users = []User{
	{ID: "1", Username: "testuser", Password: "$2a$10$1XjC1yQ/1FoQeY3YwW5mhOJBVMDbN5aUGCjcPWVG1oZU1Bxg2TbUW"}, // password: testpass
}

func loginHandler(c *gin.Context) {
	var loginUser User
	if err := c.ShouldBindJSON(&loginUser); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	for _, u := range users {
		if u.Username == loginUser.Username && bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(loginUser.Password)) == nil {
			token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
				"username": u.Username,
				"exp":      time.Now().Add(time.Hour * 24).Unix(),
			})
			tokenString, err := token.SignedString([]byte("your_secret_key"))
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not generate token"})
				return
			}
			c.JSON(http.StatusOK, gin.H{"token": tokenString})
			return
		}
	}

	c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
}

type Question struct {
	ID       string   `json:"id"`
	Text     string   `json:"text"`
	Options  []string `json:"options"`
	Answer   string   `json:"answer"`
	Level    int      `json:"level"`
	Category string   `json:"category"`
}

type Quiz struct {
	ID        string     `json:"id"`
	Title     string     `json:"title"`
	Questions []Question `json:"questions"`
}

var quizzes = []Quiz{
	{
		ID:    "1",
		Title: "General Knowledge",
		Questions: []Question{
			{
				ID:       "q1",
				Text:     "What is the capital of France?",
				Options:  []string{"London", "Berlin", "Paris", "Madrid"},
				Answer:   "Paris",
				Level:    1,
				Category: "Geography",
			},
			{
				ID:       "q2",
				Text:     "Who painted the Mona Lisa?",
				Options:  []string{"Van Gogh", "Da Vinci", "Picasso", "Rembrandt"},
				Answer:   "Da Vinci",
				Level:    2,
				Category: "Art",
			},
		},
	},
}

func getQuizzes(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"quizzes": quizzes})
}
func createQuiz(c *gin.Context) {
	var newQuiz Quiz
	if err := c.ShouldBindJSON(&newQuiz); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	newQuiz.ID = fmt.Sprintf("%d", len(quizzes)+1)
	quizzes = append(quizzes, newQuiz)
	c.JSON(http.StatusCreated, newQuiz)
}
func main() {
	r := gin.Default()

	// Configure CORS
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"http://localhost:3000"} // Add your Flutter web app's URL here
	config.AllowMethods = []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"}
	config.AllowHeaders = []string{"Origin", "Content-Length", "Content-Type"}
	r.Use(cors.New(config))

	// Configure CORS
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type"},
		AllowCredentials: true,
	}))
	r.POST("/login", loginHandler)
	r.POST("/quizzes", createQuiz)

	r.GET("/quizzes", getQuizzes)

	log.Println("Server is running on http://localhost:8080")
	r.Run(":8080")
}
