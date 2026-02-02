package store

// DataStore is the dependency that logic needs
// Interface is intentionally small.
type DataStore interface{
	UserNameForID (userID string )(string, bool)
}