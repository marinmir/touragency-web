package model

import (
	"database/sql"

	_ "github.com/go-sql-driver/mysql"
)

type TourOperatorDb struct {
	Id int
	Name string
}

type TourOperatorModel interface {
	Add(name string) (error)
	Get(id int) (*TourOperatorDb, error)
	GetList(limit int, offset int) ([]TourOperatorDb, error)
	Update(tourOperator TourOperatorDb) (error)
	Delete(id int) (error)
}

type tourOperatorModelImpl struct {
	database *sql.DB
}

func InitTourOperatorModel(db *sql.DB) TourOperatorModel {
	return tourOperatorModelImpl { database: db }
}

func (m tourOperatorModelImpl) Add(name string) (error) {
	_, err := m.database.Exec("INSERT INTO tour_operator(name) VALUES (?)", name)

	return err
}

func (m tourOperatorModelImpl) Get(id int) (*TourOperatorDb, error) {
	rows, err := m.database.Query("SELECT * FROM tour_operator WHERE id = ?", id)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	tourOperator := &TourOperatorDb{}

	for rows.Next() {
		err := rows.Scan(&tourOperator.Id, &tourOperator.Name)
		if err != nil {
			return nil, err
		}
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return tourOperator, nil
}

func (m tourOperatorModelImpl) GetList(limit int, offset int) ([]TourOperatorDb, error) {
	rows, err := m.database.Query("SELECT * FROM tour_operator LIMIT ? OFFSET ?", limit, offset)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tourOperators []TourOperatorDb

	for rows.Next() {
		var tourOperator TourOperatorDb
		err := rows.Scan(&tourOperator.Id, &tourOperator.Name)
		if err != nil {
			return nil, err
		}

		tourOperators = append(tourOperators, tourOperator)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return tourOperators, nil
}

func (m tourOperatorModelImpl) Update(tourOperator TourOperatorDb) (error) {
	_, err := m.database.Exec("UPDATE tour_operator SET name = ? WHERE id = ?", tourOperator.Name, tourOperator.Id)

	return err
}

func (m tourOperatorModelImpl) Delete(id int) (error) {
	_, err := m.database.Exec("DELETE FROM tour_operator WHERE id = ?", id)

	return err
}
