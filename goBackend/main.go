package main

import (
	"go_backend/config"
	"go_backend/entity"
	"go_backend/middleware"
	"go_backend/repository"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

var (
	productRepo repository.ProductsRepository = repository.NewProductRepository()
	userRepo    repository.UsersRepository    = repository.NewUsersRepository()
)

func productsHandler(c *gin.Context) {
	products, _ := productRepo.FindAll()

	c.JSON(200, gin.H{
		"products": products,
	})
}

func saveProductsHandler(c *gin.Context) {
	var data entity.Product
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}
	products, _ := productRepo.Save(&data)

	c.JSON(200, gin.H{
		"products": products,
	})
}

func userRoleHandler(c *gin.Context) {
	var data entity.User
	if err := c.ShouldBindJSON(&data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}
	userRepo.SetUserRole(&data)
	c.JSON(200, gin.H{
		"message": "succes set User Role",
	})
}

func getListOfUser(c *gin.Context) {
	// var data entity.User
	// if err := c.ShouldBindJSON(&data); err != nil {
	// 	c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
	// 	return
	// }
	users, _ := userRepo.GetListOfUsers(c)
	c.JSON(200, gin.H{
		"products": users,
	})
}

func main() {
	r := gin.Default()
	r.Use(cors.Default())

	// configure firebase
	firebaseAuth := config.SetupFirebase()

	// create configure database instance
	// db := config.CreateDatabase()

	// set db to gin context with a middleware to all incoming request
	r.Use(func(c *gin.Context) {
		// c.Set("db", db)
		c.Set("firebaseAuth", firebaseAuth)
	})

	r.POST("/userRole", userRoleHandler)

	// r.Use(middleware.AuthMiddleware)
	authRoutes := r.Group("/").Use(middleware.AuthMiddleware)
	authRoutes.GET("/products", productsHandler)
	authRoutes.POST("/products", saveProductsHandler)
	authRoutes.GET("/users", getListOfUser)
	r.Run(":5001")
}
