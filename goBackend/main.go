package main

import (
	"go_backend/repository"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

var (
	repo repository.ProductsRepository = repository.NewProductRepository()
)

func productsHandler(c *gin.Context) {
	// products := []entity.Product{
	// 	entity.Product{100, "BassTune Headset 2.0", 200, "A headphone with a inbuilt high-quality microphone"},
	// 	entity.Product{101, "Fastlane Toy Car", 100, "A toy car that comes with a free HD camera"},
	// 	entity.Product{102, "ATV Gear Mouse", 75, "A high-quality mouse for office work and gaming"},
	// }

	products, _ := repo.FindAll()

	c.JSON(200, gin.H{
		"products": products,
	})
}
func main() {
	r := gin.Default()
	r.Use(cors.Default())
	r.GET("/products", productsHandler)
	r.Run(":5000")
}
