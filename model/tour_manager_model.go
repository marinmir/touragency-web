package model

import (
	"database/sql"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

type TourManagerDb struct {
	Id int
	TravelAgencyId int
	Name string
	Surname string
	Birthday string
}

type TourManagerModel interface {
	Add(travelAgencyId int, name string, surname string, birthday string) (error)
	Get(id int) (*TourManagerDb, error)
	GetList(limit int, offset int) ([]TourManagerDb, error)
	Update(tourManager TourManagerDb) (error)
	Delete(id int) (error)
}

type tourManagerModelImpl struct {
	database *sql.DB
}

func InitTourManagerModel(db *sql.DB) TourManagerModel {
	return tourManagerModelImpl { database: db }
}

func (m tourManagerModelImpl) Add(travelAgencyId int,name string, surname string, birthday string) (error) {
	parsedBirthday, err := time.Parse("2006-01-02", birthday)
	if err != nil {
		return err
	}
	res, err := m.database.Exec("INSERT INTO human(name, surname, birthday) VALUES (?, ?, ?)", name, surname, parsedBirthday)
	if err != nil {
		return err
	}
	
	humanId, err := res.LastInsertId()
	if err != nil {
		return err
	}
	_, err = m.database.Exec("INSERT INTO tourmanager(id_human, id_travel_agency) VALUES (?, ?)", humanId, travelAgencyId)

	return err
}

func (m tourManagerModelImpl) Get(id int) (*TourManagerDb, error) {
	rows, err := m.database.Query("SELECT tourmanager.id, tourmanager.id_travel_agency, human.name, human.surname, human.birthday FROM tourmanager JOIN human on tourmanager.id_human = human.id WHERE tourmanager.id = ?", id)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	tourmanager := &TourManagerDb{}

	for rows.Next() {
		err := rows.Scan(&tourmanager.Id, &tourmanager.TravelAgencyId, &tourmanager.Name, &tourmanager.Surname, &tourmanager.Birthday)
		if err != nil {
			return nil, err
		}
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return tourmanager, nil
}

func (m tourManagerModelImpl) GetList(limit int, offset int) ([]TourManagerDb, error) {
	rows, err := m.database.Query("SELECT tourmanager.id, tourmanager.id_travel_agency, human.name, human.surname, human.birthday FROM tourmanager JOIN human on tourmanager.id_human = human.id LIMIT ? OFFSET ?", limit, offset)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tourmanagers []TourManagerDb

	for rows.Next() {
		var tourmanager TourManagerDb
		err := rows.Scan(&tourmanager.Id, &tourmanager.TravelAgencyId, &tourmanager.Name, &tourmanager.Surname, &tourmanager.Birthday)
		if err != nil {
			return nil, err
		}

		tourmanagers = append(tourmanagers, tourmanager)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return tourmanagers, nil
}

func (m tourManagerModelImpl) Update(tourmanager TourManagerDb) (error) {
	parsedBirthday, err := time.Parse("2006-01-02", tourmanager.Birthday)
	if err != nil {
		return err
	}
	_, err = m.database.Exec("UPDATE human SET name = ?, surname = ?, birthday = ? WHERE id IN (SELECT tour_client.id_human FROM tour_client WHERE tour_client.id = ?)", tourmanager.Name, tourmanager.Surname, parsedBirthday, tourmanager.Id)

	if err != nil {
		return err
	}

	_, err = m.database.Exec("UPDATE tourmanager SET id_travel_agency = ? WHERE id = ?", tourmanager.TravelAgencyId, tourmanager.Id)

	return err
}

func (m tourManagerModelImpl) Delete(id int) (error) {
	_, err := m.database.Exec("DELETE FROM human WHERE id IN (SELECT id_human FROM tourmanager WHERE id = ?)", id)

	return err
}
