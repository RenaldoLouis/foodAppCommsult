package entity

type Product struct {
	Description string `json:"Description"`
	Id          int64  `json:"Id"`
	Name        string `json:"Name"`
	Price       int64  `json:"Price"`
}
