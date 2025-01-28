package firebase

import (
	"context"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/auth"
	"google.golang.org/api/option"
)

var Instance *auth.Client

func Init() {
	opt := option.WithCredentialsFile("firebase/firebase-adminsdk.json")
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		panic("error initializing Firebase app")
	}

	Instance, err = app.Auth(context.Background())
	if err != nil {
		panic("error initializing Firebase auth client")
	}
}
