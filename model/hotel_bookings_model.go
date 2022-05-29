package model

import (
	"database/sql"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

type HotelBookingDb struct {
	Id int
	DateStart string
	DateEnd string
	Price float32
}

type HotelBookingModel interface {
	Add(dateStart string, dateEnd string, price float32) (*HotelBookingDb, error)
	Get(id int) (*HotelBookingDb, error)
	GetList(limit int, offset int) ([]HotelBookingDb, error)
	Update(tourClient HotelBookingDb) (error)
	Delete(id int) (error)
}

type hotelBookingModelImpl struct {
	database *sql.DB
}

const (
	dateTemplate string = "2006-01-02"
)

func InitHotelBookingModel(db *sql.DB) HotelBookingModel {
	return hotelBookingModelImpl { database: db }
}

func (m hotelBookingModelImpl) Add(dateStart string, dateEnd string, price float32) (*HotelBookingDb, error) {
	parsedDateStart, err := time.Parse(dateTemplate, dateStart)
	if err != nil {
		return nil, err
	}

	parsedDateEnd, err := time.Parse(dateTemplate, dateEnd)
	if err != nil {
		return nil, err
	}

	res, err := m.database.Exec("INSERT INTO hotel_bookings(date_start, date_end, price) VALUES (?, ?, ?)", parsedDateStart, parsedDateEnd, price)
	if err != nil {
		return nil, err
	}

	insertId, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}

	return &HotelBookingDb {
		Id: int(insertId),
		DateStart: dateStart,
		DateEnd: dateEnd,
		Price: price,
	}, nil
}

func (m hotelBookingModelImpl) Get(id int) (*HotelBookingDb, error) {
	rows, err := m.database.Query("SELECT * FROM hotel_bookings WHERE id = ?", id)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	hotelBooking := &HotelBookingDb{}

	for rows.Next() {
		err := rows.Scan(&hotelBooking.Id, &hotelBooking.DateStart, &hotelBooking.DateEnd, &hotelBooking.Price)
		if err != nil {
			return nil, err
		}
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return hotelBooking, nil
}

func (m hotelBookingModelImpl) GetList(limit int, offset int) ([]HotelBookingDb, error) {
	rows, err := m.database.Query("SELECT * FROM hotel_bookings LIMIT ? OFFSET ?", limit, offset)

	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var hotelBookings []HotelBookingDb

	for rows.Next() {
		var hotelBooking HotelBookingDb
		err := rows.Scan(&hotelBooking.Id, &hotelBooking.DateStart, &hotelBooking.DateEnd, &hotelBooking.Price)
		if err != nil {
			return nil, err
		}

		hotelBookings = append(hotelBookings, hotelBooking)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return hotelBookings, nil
}

func (m hotelBookingModelImpl) Update(hotelBooking HotelBookingDb) (error) {
	parsedDateStart, err := time.Parse(dateTemplate, hotelBooking.DateStart)
	if err != nil {
		return err
	}

	parsedDateEnd, err := time.Parse(dateTemplate, hotelBooking.DateEnd)
	if err != nil {
		return err
	}

	_, err = m.database.Exec("UPDATE hotel_bookings SET date_start = ?, date_end = ?, price = ? WHERE id = ?", parsedDateStart, parsedDateEnd, hotelBooking.Price, hotelBooking.Id)

	return err
}

func (m hotelBookingModelImpl) Delete(id int) (error) {
	_, err := m.database.Exec("DELETE FROM hotel_bookings WHERE id = ?", id)

	return err
}
