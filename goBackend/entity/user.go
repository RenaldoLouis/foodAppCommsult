package entity

type User struct {
	UID  string `json:"UID"`
	Role string `json:"Role"`
}

type UserListResponse struct {
	EmailVerified bool   `json:"EmailVerified"`
	Disabled      bool   `json:"Disabled"`
	Name          string `json:"Name"`
	Role          string `json:"Role"`
	Email         string `json:"Email"`
}
