package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.63

import (
	"context"
	"fmt"

	"github.com/akiratatsuhisa/todo_api/graph/model"
)

func strPtr(s string) *string {
	return &s
}

var id = 10
var todos = []*model.Todo{
	{ID: "1", Text: "Buy groceries", Done: false, Archived: false, Description: strPtr("Buy milk, eggs, bread, and other essential groceries for the week. Also, get some snacks and drinks.")},
	{ID: "2", Text: "Read book", Done: true, Archived: true, Description: strPtr("Finish reading 'The Great Gatsby' and write a summary of the book. Reflect on the themes and characters.")},
	{ID: "3", Text: "Workout", Done: true, Description: strPtr("Complete a 30-minute workout including cardio and strength training exercises. Focus on core and legs.")},
	{ID: "4", Text: "Call mom", Done: false, Description: nil},
	{ID: "5", Text: "Clean house", Done: true, Description: strPtr("Vacuum and dust the living room, and clean the kitchen and bathrooms. Organize the closets and drawers.")},
	{ID: "6", Text: "Write blog post", Done: false, Archived: false, Description: strPtr("Write a detailed blog post about Go programming and its features. Include code examples and best practices.")},
	{ID: "7", Text: "Plan trip", Done: true, Archived: true, Description: nil},
	{ID: "8", Text: "Fix bike", Done: true, Description: strPtr("Repair the flat tire on the bike and check the brakes and gears. Test ride to ensure everything is working.")},
	{ID: "9", Text: "Cook dinner", Done: false, Description: nil},
	{ID: "10", Text: "Learn guitar", Done: true, Description: strPtr("Practice chords for 30 minutes and learn a new song. Focus on finger placement and strumming patterns.")},
	{ID: "11", Text: "Meditate", Done: false, Archived: false, Description: strPtr("Meditate for 10 minutes to relax and clear the mind. Use guided meditation for better focus.")},
	{ID: "12", Text: "Pay bills", Done: true, Archived: true, Description: nil},
	{ID: "13", Text: "Attend meeting", Done: false, Description: strPtr("Join the team meeting at 10 AM and discuss project updates.")},
	{ID: "14", Text: "Grocery shopping", Done: true, Description: strPtr("Buy fruits, vegetables, and other fresh produce for the week.")},
	{ID: "15", Text: "Study Go", Done: false, Archived: false, Description: nil},
	{ID: "16", Text: "Walk the dog", Done: true, Description: strPtr("Take the dog for a walk in the park and play fetch.")},
	{ID: "17", Text: "Water plants", Done: false, Archived: true, Description: strPtr("Water the indoor plants and check for any signs of pests.")},
	{ID: "18", Text: "Watch movie", Done: true, Description: nil},
	{ID: "19", Text: "Write code", Done: false, Archived: false, Description: strPtr("Work on the new feature for the app and fix any bugs. Review the code and run tests to ensure quality.")},
	{ID: "20", Text: "Organize desk", Done: true, Archived: true, Description: strPtr("Clean and organize the desk, and sort through paperwork.")},
}

func findTodoByID(todos []*model.Todo, id string) *model.Todo {
	for _, todo := range todos {
		if todo.ID == id {
			return todo
		}
	}
	return nil
}

// CreateTodo is the resolver for the createTodo field.
func (r *mutationResolver) CreateTodo(ctx context.Context, input model.CreateTodo) (*model.Todo, error) {
	id++
	todo := &model.Todo{
		ID:          fmt.Sprintf("%d", id),
		Text:        input.Text,
		Description: input.Description,
		Done:        false,
	}

	todos = append(todos, todo)

	return todo, nil
}

// UpdateTodo is the resolver for the updateTodo field.
func (r *mutationResolver) UpdateTodo(ctx context.Context, id string, input model.UpdateTodo) (*model.Todo, error) {
	todo := findTodoByID(todos, id)

	if todo == nil {
		return nil, fmt.Errorf("todo not found")
	}

	if input.Text != nil {
		todo.Text = *input.Text
	}
	todo.Description = input.Description

	return todo, nil
}

// CompleteTodo is the resolver for the completeTodo field.
func (r *mutationResolver) CompleteTodo(ctx context.Context, id string) (*model.Todo, error) {
	todo := findTodoByID(todos, id)

	if todo == nil {
		return nil, fmt.Errorf("todo not found")
	}

	todo.Done = !todo.Done

	return todo, nil
}

// ArchiveTodo is the resolver for the archiveTodo field.
func (r *mutationResolver) ArchiveTodo(ctx context.Context, id string) (*model.Todo, error) {
	todo := findTodoByID(todos, id)

	if todo == nil {
		return nil, fmt.Errorf("todo not found")
	}

	todo.Archived = !todo.Archived

	return todo, nil
}

// RemoveTodo is the resolver for the removeTodo field.
func (r *mutationResolver) RemoveTodo(ctx context.Context, id string) (*model.Todo, error) {
	todo := findTodoByID(todos, id)

	if todo == nil {
		return nil, fmt.Errorf("todo not found")
	}

	for i, t := range todos {
		if t.ID == id {
			todos = append(todos[:i], todos[i+1:]...)
			break
		}
	}

	return todo, nil
}

// Todos is the resolver for the todos field.
func (r *queryResolver) Todos(ctx context.Context, archive *bool) ([]*model.Todo, error) {
	result := []*model.Todo{}

	hasArchived := false
	if archive != nil {
		hasArchived = *archive
	}

	for _, todo := range todos {
		if todo.Archived == hasArchived {
			result = append(result, todo)
		}
	}

	return result, nil
}

// Todo is the resolver for the todo field.
func (r *queryResolver) Todo(ctx context.Context, id string) (*model.Todo, error) {
	todo := findTodoByID(todos, id)

	if todo == nil {
		return nil, fmt.Errorf("todo not found")
	}

	return todo, nil
}

// Description is the resolver for the description field.
func (r *todoResolver) Description(ctx context.Context, obj *model.Todo, truncate *bool) (*string, error) {
	if truncate != nil && *truncate && obj.Description != nil && len(*obj.Description) > 30 {
		truncatedDesc := (*obj.Description)[:30] + "..."
		return &truncatedDesc, nil
	}

	return obj.Description, nil
}

// Mutation returns MutationResolver implementation.
func (r *Resolver) Mutation() MutationResolver { return &mutationResolver{r} }

// Query returns QueryResolver implementation.
func (r *Resolver) Query() QueryResolver { return &queryResolver{r} }

// Todo returns TodoResolver implementation.
func (r *Resolver) Todo() TodoResolver { return &todoResolver{r} }

type mutationResolver struct{ *Resolver }
type queryResolver struct{ *Resolver }
type todoResolver struct{ *Resolver }
