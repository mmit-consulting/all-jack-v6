package logger

// Logger is owned by consumer side
type Logger interface {
	Log(message string)
}

// Adapter lets a plain function behave like a logger.
type Adapter func(message string)

func (a Adapter) Log(message string){
	a(message)
}
