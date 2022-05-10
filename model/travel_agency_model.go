package model

import (
	"database/sql"

	_ "github.com/go-sql-driver/mysql"
)

type TravelAgencyDb struct {
	Id int
	Name string
	Address string
}

type TravelAgencyModel interface {
	Add(name string, address string) (error)
	Get(id int) (*TravelAgencyDb, error)
	GetList(limit int, offset int) ([]TravelAgencyDb, error)
	Update(travelAgency TravelAgencyDb) (error)
	Delete(id int) (error)
}

type travelAgencyModelImpl struct {
	database *sql.DB
}

func InitTravelAgencyModel(db *sql.DB) TravelAgencyModel {
	return travelAgencyModelImpl { database: db }
}

func (m travelAgencyModelImpl) Add(name string, address string) (error) {
	_, err := m.database.Exec("INSERT INTO travel_agencies(name, address) VALUES (?, ?)", name, address)

	return err
}

func (m travelAgencyModelImpl) Get(id int) (*TravelAgencyDb, error) {
	rows, err := m.database.Query("SELECT * FROM travel_agencies WHERE id = ?", id)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	travelAgency := &TravelAgencyDb{}

	for rows.Next() {
		err := rows.Scan(&travelAgency.Id, &travelAgency.Name, &travelAgency.Address)
		if err != nil {
			return nil, err
		}
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return travelAgency, nil
}

func (m travelAgencyModelImpl) GetList(limit int, offset int) ([]TravelAgencyDb, error) {
	rows, err := m.database.Query("SELECT * FROM travel_agencies LIMIT ? OFFSET ?", limit, offset)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var travelAgencies []TravelAgencyDb

	for rows.Next() {
		var travelAgency TravelAgencyDb
		err := rows.Scan(&travelAgency.Id, &travelAgency.Name, &travelAgency.Address)
		
		if err != nil {
			return nil, err
		}

		travelAgencies = append(travelAgencies, travelAgency)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return travelAgencies, nil
}

func (m travelAgencyModelImpl) Update(travelAgency TravelAgencyDb) (error) {
	_, err := m.database.Exec("UPDATE travel_agencies SET name = ?, address = ? WHERE id = ?", travelAgency.Name, travelAgency.Address, travelAgency.Id)

	return err
}

func (m travelAgencyModelImpl) Delete(id int) (error) {
	_, err := m.database.Exec("DELETE FROM travel_agencies WHERE id = ?", id)

	return err
}
