package main

import (
	"net/http"

	"miniapp/controller"
	"miniapp/logger"
	"miniapp/logic"
	"miniapp/store"
)

func main() {
	// --- Choose concrete implementations (only here) ---
	// Option A: use struct logger
	l := logger.Stdout{}
	// Option B: use function adapter (uncomment to try)
	// l := logger.Adapter(func(msg string) { fmt.Println(msg) })

	ds := store.NewSimpleDataStore()

	appLogic := logic.NewSimpleLogic(l, ds)
	c := controller.NewController(l, appLogic)

	// --- HTTP wiring ---
	http.HandleFunc("/hello", c.SayHello)

	// Start server
	_ = http.ListenAndServe(":8080", nil)
}
