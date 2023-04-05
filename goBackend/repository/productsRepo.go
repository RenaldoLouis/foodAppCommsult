package repository

import (
	"context"
	"fmt"
	"go_backend/entity"
	"log"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/option"
)

type ProductsRepository interface {
	Save(product *entity.Product) (*entity.Product, error)
	FindAll() ([]entity.Product, error)
}

type repo struct {
}

const (
	projectId      string = "commsulteat"
	collectionname string = "products"
)

func NewProductRepository() ProductsRepository {
	return &repo{}
}

func (*repo) Save(product *entity.Product) (*entity.Product, error) {
	ctx := context.Background()
	client, err := firestore.NewClient(ctx, projectId, option.WithCredentialsFile("E:/Work/foodAppCommsult/goBackend/commsulteat-firebase-adminsdk-ogpvz-2d2c8944eb.json"))

	if err != nil {
		log.Fatalf("Failed to create a Firestore Client: %v", err)
		return nil, err
	}

	defer client.Close()
	_, _, err = client.Collection(collectionname).Add(ctx, map[string]interface{}{
		"Description": product.Description,
		"Id":          product.Id,
		"Name":        product.Name,
		"Price":       product.Price,
	})

	if err != nil {
		log.Fatalf("Failed adding new post %v", err)
		return nil, err
	}
	return product, nil
}

func (*repo) FindAll() ([]entity.Product, error) {
	ctx := context.Background()
	client, err := firestore.NewClient(ctx, projectId, option.WithCredentialsFile("E:/Work/foodAppCommsult/goBackend/commsulteat-firebase-adminsdk-ogpvz-2d2c8944eb.json"))

	if err != nil {
		log.Fatalf("Failed to create a Firestore Client: %v", err)
		return nil, err
	}

	defer client.Close()
	var products []entity.Product

	collectionRef := client.Collection(collectionname)

	iterator, err := collectionRef.Documents(ctx).GetAll()
	if err != nil {
		log.Fatalf("Failed to get documents from collection: %v", err)
	}

	for _, doc := range iterator {
		data := doc.Data()
		fmt.Println("Document data:", data)
		product := entity.Product{
			Description: doc.Data()["Description"].(string),
			Id:          doc.Data()["Id"].(int64),
			Name:        doc.Data()["Name"].(string),
			Price:       doc.Data()["Price"].(int64),
		}
		products = append(products, product)
	}
	return products, nil
}
