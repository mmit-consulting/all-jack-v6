package controller

import (
	"net/http"

	"miniapp/logger"
	"miniapp/logic"
)

type Controller struct {
	l     logger.Logger
	logic logic.Logic
}

func NewController(l logger.Logger, logic logic.Logic) Controller {
	return Controller{l: l, logic: logic}
}

// SayHello is an HTTP handler method.
// It matches: func(http.ResponseWriter, *http.Request)
func (c Controller) SayHello(w http.ResponseWriter, r *http.Request) {
	c.l.Log("In SayHello")

	userID := r.URL.Query().Get("user_id")
	message, err := c.logic.SayHello(userID)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		_, _ = w.Write([]byte(err.Error()))
		return
	}

	_, _ = w.Write([]byte(message))
}
