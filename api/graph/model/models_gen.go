// Code generated by github.com/99designs/gqlgen, DO NOT EDIT.

package model

type CreateTodo struct {
	Text        string  `json:"text"`
	Description *string `json:"description,omitempty"`
}

type Mutation struct {
}

type Query struct {
}

type Todo struct {
	ID          string  `json:"id"`
	Text        string  `json:"text"`
	Done        bool    `json:"done"`
	Archived    bool    `json:"archived"`
	Description *string `json:"description,omitempty"`
}

type UpdateTodo struct {
	Text        *string `json:"text,omitempty"`
	Description *string `json:"description,omitempty"`
}
