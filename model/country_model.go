package model

import (
	"database/sql"

	_ "github.com/go-sql-driver/mysql"
)

type CountryDb struct {
	Id int
	Name string
}

type CountryModel interface {
	Add(name string) (error)
	Get(id int) (*CountryDb, error)
	GetList(limit int, offset int) ([]CountryDb, error)
	Update(country CountryDb) (error)
	Delete(id int) (error)
}

type countryModelImpl struct {
	database *sql.DB
}

func InitCountryModel(db *sql.DB) CountryModel {
	return countryModelImpl { database: db }
}

func (m countryModelImpl) Add(name string) (error) {
	_, err := m.database.Exec("INSERT INTO countries(name) VALUES (?)", name)

	return err
}

func (m countryModelImpl) Get(id int) (*CountryDb, error) {
	rows, err := m.database.Query("SELECT * FROM countries WHERE id = ?", id)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	country := &CountryDb{}

	for rows.Next() {
		err := rows.Scan(&country.Id, &country.Name)
		if err != nil {
			return nil, err
		}
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return country, nil
}

func (m countryModelImpl) GetList(limit int, offset int) ([]CountryDb, error) {
	rows, err := m.database.Query("SELECT * FROM countries LIMIT ? OFFSET ?", limit, offset)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var countries []CountryDb

	for rows.Next() {
		var country CountryDb
		err := rows.Scan(&country.Id, &country.Name)
		if err != nil {
			return nil, err
		}

		countries = append(countries, country)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return countries, nil
}

func (m countryModelImpl) Update(country CountryDb) (error) {
	_, err := m.database.Exec("UPDATE countries SET name = ? WHERE id = ?", country.Name, country.Id)

	return err
}

func (m countryModelImpl) Delete(id int) (error) {
	_, err := m.database.Exec("DELETE FROM countries WHERE id = ?", id)

	return err
}
