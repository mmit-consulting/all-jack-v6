package logic

import (
	"errors"
	"fmt"

	"miniapp/logger"
	"miniapp/store"
)

type SimpleLogic struct {
	l  logger.Logger
	ds store.DataStore
}

func NewSimpleLogic(l logger.Logger, ds store.DataStore) SimpleLogic {
	return SimpleLogic{l: l, ds: ds}
}

func (sl SimpleLogic) SayHello(userID string) (string, error) {
	sl.l.Log("in SayHello for " + userID)

	name, ok := sl.ds.UserNameForID(userID)
	if !ok {
		return "", errors.New("unknown user")
	}
	return fmt.Sprintf("Hello, %s", name), nil
}

// Extra method not required by controller interface (logic.Logic)
// but still available on SimpleLogic for other callers.
func (sl SimpleLogic) SayGoodbye(userID string) (string, error) {
	sl.l.Log("in SayGoodbye for " + userID)

	name, ok := sl.ds.UserNameForID(userID)
	if !ok {
		return "", errors.New("unknown user")
	}
	return fmt.Sprintf("Goodbye, %s", name), nil
}
