package auth

import (
	"context"
	"net/http"
	"strings"

	"github.com/akiratatsuhisa/todo_api/firebase"
)

// A private key for context that only this package can access. This is important
// to prevent collisions between different context uses
var userCtxKey = &contextKey{"user"}

type contextKey struct {
	name string
}

type User struct {
	Id    string
	Email string
}

// Middleware decodes the share session cookie and packs the session into context
func Middleware() func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			if r.Method == "GET" {
				next.ServeHTTP(w, r)
				return
			}

			authHeader := r.Header.Get("Authorization")

			idToken := strings.TrimPrefix(authHeader, "Bearer ")

			if idToken == "" {
				http.Error(w, "Invalid Authorization header format", http.StatusUnauthorized)
				return
			}

			decodedToken, err := firebase.Instance.VerifyIDToken(r.Context(), idToken)

			if err != nil {
				http.Error(w, "Invalid token", http.StatusUnauthorized)
				return
			}

			user := &User{
				Id:    decodedToken.Claims["user_id"].(string),
				Email: decodedToken.Claims["email"].(string),
			}

			ctx := context.WithValue(r.Context(), userCtxKey, user)

			r = r.WithContext(ctx)
			next.ServeHTTP(w, r)
		})
	}
}

// ForContext finds the user from the context. REQUIRES Middleware to have run.
func ForContext(ctx context.Context) *User {
	raw, _ := ctx.Value(userCtxKey).(*User)
	return raw
}
