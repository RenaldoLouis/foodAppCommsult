package repository

import (
	"context"
	"go_backend/entity"
	"log"
	"strings"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"
)

type UsersRepository interface {
	SetUserRole(user *entity.User) error
	GetListOfUsers(c *gin.Context) ([]entity.UserListResponse, error)
}

func NewUsersRepository() UsersRepository {
	return &repo{}
}

func (*repo) SetUserRole(user *entity.User) error {
	ctx := context.Background()
	opt := option.WithCredentialsFile("../goBackend/commsulteat-firebase-adminsdk-ogpvz-2d2c8944eb.json")

	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		log.Fatalf("Failed to initialize Firebase app: %v", err)
	}

	// Get the Firebase Authentication client
	authClient, err := app.Auth(ctx)
	if err != nil {
		log.Fatalf("Failed to get Firebase Auth client: %v", err)
	}

	// Set custom claims for the user
	claims := map[string]interface{}{
		"role": user.Role,
	}
	err = authClient.SetCustomUserClaims(ctx, user.UID, claims)
	if err != nil {
		log.Fatalf("Error setting custom claims: %v", err)
	}

	log.Println("Custom claims set successfully")

	return err

}

func (*repo) GetListOfUsers(c *gin.Context) ([]entity.UserListResponse, error) {
	var users []entity.UserListResponse
	ctx := context.Background()
	opt := option.WithCredentialsFile("../goBackend/commsulteat-firebase-adminsdk-ogpvz-2d2c8944eb.json")

	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		log.Fatalf("Failed to initialize Firebase app: %v", err)
	}

	// Get the Firebase Authentication client
	authClient, err := app.Auth(ctx)
	if err != nil {
		log.Fatalf("Failed to get Firebase Auth client: %v", err)
	}

	firebaseAuth := c.MustGet("firebaseAuth").(*auth.Client)
	authorizationToken := c.GetHeader("Authorization")
	idToken := strings.TrimSpace(strings.Replace(authorizationToken, "Bearer", "", 1))
	if idToken == "" {
		log.Fatalf("error : Id token not available")
	}

	// err = authClient.SetCustomUserClaims(ctx, user.UID, claims)
	token, err := firebaseAuth.VerifyIDToken(context.Background(), idToken)
	if err != nil {
		log.Fatalf(err.Error())
	}

	claims := token.Claims

	role := claims["role"]

	if role != "admin" {
		log.Fatalf("User not allowed to acces this data")
	}

	iter := authClient.Users(ctx, "")
	for {
		user, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("error listing users: %s\n", err)
		}

		userData := entity.UserListResponse{
			EmailVerified: user.EmailVerified,
			Disabled:      user.Disabled,
			Name:          user.DisplayName,
			Role:          user.CustomClaims["role"].(string),
			Email:         user.Email,
		}
		users = append(users, userData)
		log.Printf("read user user: %v\n", user)
	}

	return users, nil
}
