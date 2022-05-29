package model

import (
	"database/sql"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

type TourClientDb struct {
	Id int
	Name string
	Surname string
	Birthday string
}

type TourClientModel interface {
	Add(name string, surname string, birthday string) (*TourClientDb, error)
	Get(id int) (*TourClientDb, error)
	GetList(limit int, offset int) ([]TourClientDb, error)
	Update(tourClient TourClientDb) (error)
	Delete(id int) (error)
}

type tourClientModelImpl struct {
	database *sql.DB
}

func InitTourClientModel(db *sql.DB) TourClientModel {
	return tourClientModelImpl { database: db }
}

func (m tourClientModelImpl) Add(name string, surname string, birthday string) (*TourClientDb, error) {
	parsedBirthday, err := time.Parse("2006-01-02", birthday)
	if err != nil {
		return nil, err
	}
	res, err := m.database.Exec("INSERT INTO human(name, surname, birthday) VALUES (?, ?, ?)", name, surname, parsedBirthday)
	if err != nil {
		return nil, err
	}
	
	humanId, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}
	result, err := m.database.Exec("INSERT INTO tour_client(id_human) VALUES (?)", humanId)
	if err != nil {
		return nil, err
	}

	insertId, err := result.LastInsertId()

	return &TourClientDb {
		Id: int(insertId),
		Name: name,
		Surname: surname,
		Birthday: birthday,
	}, nil
}

func (m tourClientModelImpl) Get(id int) (*TourClientDb, error) {
	rows, err := m.database.Query("SELECT tour_client.id, human.name, human.surname, human.birthday FROM tour_client JOIN human on tour_client.id_human = human.id WHERE tour_client.id = ?", id)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	tourClient := &TourClientDb{}

	for rows.Next() {
		err := rows.Scan(&tourClient.Id, &tourClient.Name, &tourClient.Surname, &tourClient.Birthday)
		if err != nil {
			return nil, err
		}
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return tourClient, nil
}

func (m tourClientModelImpl) GetList(limit int, offset int) ([]TourClientDb, error) {
	rows, err := m.database.Query("SELECT tour_client.id, human.name, human.surname, human.birthday FROM tour_client JOIN human on tour_client.id_human = human.id LIMIT ? OFFSET ?", limit, offset)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tourClients []TourClientDb

	for rows.Next() {
		var tourClient TourClientDb
		err := rows.Scan(&tourClient.Id, &tourClient.Name, &tourClient.Surname, &tourClient.Birthday)
		if err != nil {
			return nil, err
		}

		tourClients = append(tourClients, tourClient)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return tourClients, nil
}

func (m tourClientModelImpl) Update(tourClient TourClientDb) (error) {
	parsedBirthday, err := time.Parse("2006-01-02", tourClient.Birthday)
	if err != nil {
		return err
	}
	_, err = m.database.Exec("UPDATE human SET name = ?, surname = ?, birthday = ? WHERE id IN (SELECT tour_client.id_human FROM tour_client WHERE tour_client.id = ?)", tourClient.Name, tourClient.Surname, parsedBirthday, tourClient.Id)

	return err
}

func (m tourClientModelImpl) Delete(id int) (error) {
	_, err := m.database.Exec("DELETE FROM human WHERE id IN (SELECT id_human FROM tour_client WHERE id = ?)", id)

	return err
}
