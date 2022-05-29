package model

import (
	"database/sql"

	_ "github.com/go-sql-driver/mysql"
)

type TourDb struct {
	Id int
	Client TourClientDb
	Manager TourManagerDb
	TourOperator TourOperatorDb
	Country CountryDb
	Aviaticket AviaticketDb
	HotelBooking HotelBookingDb
}

type TourModel interface {
	Add(clientId int, managerId int, tourOperatorId int, countryId int, aviaticketId int, hotelBookingId int) (error)
	Delete(id int) (error)
	GetList(limit int, offset int) ([]TourDb, error)
}

type tourModelImpl struct {
	database *sql.DB
	tourClientsModel TourClientModel
	tourManagersModel TourManagerModel
	tourOperatorsModel TourOperatorModel
	countriesModel CountryModel
	aviaticketsModel AviaticketModel
	hotelBookingsModel HotelBookingModel
}

func InitTourModel(database *sql.DB) TourModel {

	return tourModelImpl {
		database: database,
		tourClientsModel: tourClientModelImpl{database: database},
		tourManagersModel: tourManagerModelImpl{database: database},
		tourOperatorsModel: tourOperatorModelImpl{database: database},
		countriesModel: countryModelImpl{database: database},
		aviaticketsModel: aviaticketModelImpl{database: database},
		hotelBookingsModel: hotelBookingModelImpl{database: database},
	}
}

func (m tourModelImpl) Add(clientId int, managerId int, tourOperatorId int, countryId int, aviaticketId int, hotelBookingId int) (error) {
	_, err := m.database.Exec("INSERT INTO tour(id_client, id_manager, id_tour_operator, id_country, id_aviaticket, id_hotel_booking) VALUES (?, ?, ?, ?, ?, ?)", clientId, managerId, tourOperatorId, countryId, aviaticketId, hotelBookingId)
	return err
}

func (m tourModelImpl) Delete(id int) (error) {
	_, err := m.database.Exec("DELETE FROM tour where id = ?", id)
	return err
}

func (m tourModelImpl) GetList(limit int, offset int) ([]TourDb, error) {
	return nil, nil
}
