package store

type SimpleDataStore struct {
	userData map[string]string
}

func NewSimpleDataStore() SimpleDataStore {
	return SimpleDataStore{
		userData: map[string]string{
			"1": "Fred",
			"2": "Mary",
			"3": "Pat",
		},
	}
}

func (s SimpleDataStore) UserNameForID(userID string) (string, bool) {
	name, ok := s.userData[userID]
	return name, ok
}
