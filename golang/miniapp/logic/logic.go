package logic

// Logic is what the controller needs.
// It only includes SayHello (not SayGoodbye), by design.
type Logic interface {
	SayHello(userID string) (string, error)
}
