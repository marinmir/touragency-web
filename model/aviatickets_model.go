package model

import (
	"database/sql"
	"database/sql/driver"
	"errors"

	_ "github.com/go-sql-driver/mysql"
)

const (
	Business TicketClass = "business"
	Econom TicketClass = "econom"
)

type TicketClass string

func (tc *TicketClass) Scan(value interface{}) error {
	asBytes, ok := value.([]byte)
	if !ok {
		return errors.New("Can't convert TicketClass to []byte")
	}
	*tc = TicketClass(string(asBytes))
	return nil
}

func (tc TicketClass) Value() (driver.Value, error) {
	return string(tc), nil
}

type AviaticketDb struct {
	Id int
	Price float32
	OneWay bool
	Class TicketClass
}

type AviaticketModel interface {
	Add(price float32, oneWay bool, class TicketClass) (error)
	Get(id int) (*AviaticketDb, error)
	GetList(limit int, offset int) ([]AviaticketDb, error)
	Update(aviaticket AviaticketDb) (error)
	Delete(id int) (error)
}

type aviaticketModelImpl struct {
	database *sql.DB
}

func InitAviaticketModel(db *sql.DB) AviaticketModel {
	return aviaticketModelImpl { database: db }
}

func (m aviaticketModelImpl) Add(price float32, oneWay bool, class TicketClass) (error) {
	_, err := m.database.Exec("INSERT INTO aviatickets(price, one_way, ticket_class) VALUES (?, ?, ?)", price, oneWay, class)

	return err
}

func (m aviaticketModelImpl) Get(id int) (*AviaticketDb, error) {
	rows, err := m.database.Query("SELECT * FROM aviatickets WHERE id = ?", id)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	aviaticket := &AviaticketDb{}

	for rows.Next() {
		err := rows.Scan(&aviaticket.Id, &aviaticket.Price, &aviaticket.OneWay, &aviaticket.Class)
		if err != nil {
			return nil, err
		}
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return aviaticket, nil
}

func (m aviaticketModelImpl) GetList(limit int, offset int) ([]AviaticketDb, error) {
	rows, err := m.database.Query("SELECT * FROM aviatickets LIMIT ? OFFSET ?", limit, offset)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var aviatickets []AviaticketDb

	for rows.Next() {
		var aviaticket AviaticketDb
		err := rows.Scan(&aviaticket.Id, &aviaticket.Price, &aviaticket.OneWay, &aviaticket.Class)
		if err != nil {
			return nil, err
		}

		aviatickets = append(aviatickets, aviaticket)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return aviatickets, nil
}

func (m aviaticketModelImpl) Update(aviaticket AviaticketDb) (error) {
	_, err := m.database.Exec("UPDATE aviatickets SET price = ?, one_way = ?, ticket_class = ? WHERE id = ?", aviaticket.Price, aviaticket.OneWay, aviaticket.Class, aviaticket.Id)

	return err
}

func (m aviaticketModelImpl) Delete(id int) (error) {
	_, err := m.database.Exec("DELETE FROM aviatickets WHERE id = ?", id)

	return err
}
