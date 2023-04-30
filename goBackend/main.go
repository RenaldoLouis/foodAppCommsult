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
	repo repository.ProductsRepository = repository.NewProductRepository()
)

func productsHandler(c *gin.Context) {
	products, _ := repo.FindAll()

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
	products, _ := repo.Save(&data)

	c.JSON(200, gin.H{
		"products": products,
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

	r.Use(middleware.AuthMiddleware)

	r.GET("/products", productsHandler)
	r.POST("/products", saveProductsHandler)
	r.Run(":5000")
}
