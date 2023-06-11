// api/artist.go
package api

// User : Model for user
type User struct {
	ID    uint   `json:"id" gorm:"primary_key"`
	Name  string `json:"name"`
	Email string `json:"email" gorm:"unique;not null"`
}

// CreateUserInput : struct for create art post request
type CreateUserInput struct {
	Name  string `json:"name" binding:"required"`
	Email string `json:"email" binding:"required"`
}

// // FindUsers : Controller for getting all users
// func FindUsers(c *gin.Context) {
// 	db := c.MustGet("db").(*gorm.DB)
// 	var user []User
// 	db.Find(&user)
// 	c.JSON(http.StatusOK, gin.H{"data": user})
// }

// // CreateUsers : controller for creating new users
// func CreateUsers(c *gin.Context) {
// 	db := c.MustGet("db").(*gorm.DB)
// 	// Validate input
// 	var input CreateUserInput
// 	if err := c.ShouldBindJSON(&input); err != nil {
// 		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
// 		return
// 	}
// 	// Create artist
// 	artist := User{Name: input.Name, Email: input.Email}
// 	db.Create(&artist)
// 	c.JSON(http.StatusOK, gin.H{"data": artist})
// }
