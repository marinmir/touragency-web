package db

import (
	"database/sql"

	_ "github.com/go-sql-driver/mysql"
)

func InitDbConnection() (*sql.DB, error) {
	db, err := sql.Open("mysql", "marina:q1w2e3@tcp(touragency_db:3306)/touragency_db?charset=utf8mb4&collation=utf8mb4_unicode_ci")
	
	if err != nil {
		return nil, err
	}

	return db, nil
}