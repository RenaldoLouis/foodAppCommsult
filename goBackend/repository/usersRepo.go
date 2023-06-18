package repository

import (
	"context"
	"go_backend/entity"
	"log"

	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
)

type UsersRepository interface {
	SetUserRole(user *entity.User) error
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
