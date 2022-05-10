package main

import (
	"database/sql"
	
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"

	"touragency/db"
	"touragency/auth"
	"touragency/model"

	"touragency/api/v1/travel_agencies"
	"touragency/api/v1/countries"
	"touragency/api/v1/tour_operators"
	"touragency/api/v1/tour_clients"
	"touragency/api/v1/tour_managers"
	"touragency/api/v1/aviatickets"
	"touragency/api/v1/hotel_bookings"
)

func main() {
	server := echo.New()

	server.Use(middleware.Logger())

	server.POST("/login", auth.Login)

	db, err := db.InitDbConnection()
	if err != nil {
		panic("DB is not initialized, can't proceed")
	}

	initTravelAgenciesRoutes(server, db)
	initCountriesRoutes(server, db)
	initTourOperatorsRoutes(server, db)
	initTourClientsRoutes(server, db)
	initTourManagersRoutes(server, db)
	initHotelBookingsRoutes(server, db)

	server.Logger.Fatal(server.Start(":1323"))
}

func initTravelAgenciesRoutes(server *echo.Echo, database *sql.DB) {
	taModel := model.InitTravelAgencyModel(database)


	server.GET("/travel_agencies", auth.HandleAuth(func (context echo.Context) error {
		return travel_agencies.GetList(context, taModel)
	}))

	server.GET("/travel_agency", auth.HandleAuth(func (context echo.Context) error {
		return travel_agencies.Get(context, taModel)
	}))

	server.PATCH("/travel_agency", auth.HandleAuth(func (context echo.Context) error {
		return travel_agencies.Update(context, taModel)
	}))

	server.POST("/travel_agency", auth.HandleAuth(func (context echo.Context) error {
		return travel_agencies.Add(context, taModel)
	}))

	server.DELETE("/travel_agency", auth.HandleAuth(func (context echo.Context) error {
		return travel_agencies.Delete(context, taModel)
	}))
}

func initCountriesRoutes(server *echo.Echo, database *sql.DB) {
	countriesModel := model.InitCountryModel(database)

	server.GET("/countries", auth.HandleAuth(func (context echo.Context) error {
		return countries.GetList(context, countriesModel)
	}))

	server.GET("/country", auth.HandleAuth(func (context echo.Context) error {
		return countries.Get(context, countriesModel)
	}))

	server.PATCH("/country", auth.HandleAuth(func (context echo.Context) error {
		return countries.Update(context, countriesModel)
	}))

	server.POST("/country", auth.HandleAuth(func (context echo.Context) error {
		return countries.Add(context, countriesModel)
	}))

	server.DELETE("/country", auth.HandleAuth(func (context echo.Context) error {
		return countries.Delete(context, countriesModel)
	}))
}

func initTourOperatorsRoutes(server *echo.Echo, database *sql.DB) {
	tourOperatorsModel := model.InitTourOperatorModel(database)

	server.GET("/tour_operators", auth.HandleAuth(func (context echo.Context) error {
		return tour_operators.GetList(context, tourOperatorsModel)
	}))

	server.GET("/tour_operator", auth.HandleAuth(func (context echo.Context) error {
		return tour_operators.Get(context, tourOperatorsModel)
	}))

	server.PATCH("/tour_operator", auth.HandleAuth(func (context echo.Context) error {
		return tour_operators.Update(context, tourOperatorsModel)
	}))

	server.POST("/tour_operator", auth.HandleAuth(func (context echo.Context) error {
		return tour_operators.Add(context, tourOperatorsModel)
	}))

	server.DELETE("/tour_operator", auth.HandleAuth(func (context echo.Context) error {
		return tour_operators.Delete(context, tourOperatorsModel)
	}))
}

func initTourClientsRoutes(server *echo.Echo, database *sql.DB) {
	tourClientsModel := model.InitTourClientModel(database)

	server.GET("/tour_clients", auth.HandleAuth(func (context echo.Context) error {
		return tour_clients.GetList(context, tourClientsModel)
	}))

	server.GET("/tour_operator", auth.HandleAuth(func (context echo.Context) error {
		return tour_clients.Get(context, tourClientsModel)
	}))

	server.PATCH("/tour_operator", auth.HandleAuth(func (context echo.Context) error {
		return tour_clients.Update(context, tourClientsModel)
	}))

	server.POST("/tour_operator", auth.HandleAuth(func (context echo.Context) error {
		return tour_clients.Add(context, tourClientsModel)
	}))

	server.DELETE("/tour_operator", auth.HandleAuth(func (context echo.Context) error {
		return tour_clients.Delete(context, tourClientsModel)
	}))
}

func initTourManagersRoutes(server *echo.Echo, database *sql.DB) {
	tourManagersModel := model.InitTourManagerModel(database)

	server.GET("/tour_managers", auth.HandleAuth(func (context echo.Context) error {
		return tour_managers.GetList(context, tourManagersModel)
	}))

	server.GET("/tour_manager", auth.HandleAuth(func (context echo.Context) error {
		return tour_managers.Get(context, tourManagersModel)
	}))

	server.PATCH("/tour_manager", auth.HandleAuth(func (context echo.Context) error {
		return tour_managers.Update(context, tourManagersModel)
	}))

	server.POST("/tour_manager", auth.HandleAuth(func (context echo.Context) error {
		return tour_managers.Add(context, tourManagersModel)
	}))

	server.DELETE("/tour_manager", auth.HandleAuth(func (context echo.Context) error {
		return tour_managers.Delete(context, tourManagersModel)
	}))
}

func initAviaticketsRoutes(server *echo.Echo, database *sql.DB) {
	aviaticketsModel := model.InitAviaticketModel(database)

	server.GET("/aviatickets", auth.HandleAuth(func (context echo.Context) error {
		return aviatickets.GetList(context, aviaticketsModel)
	}))

	server.GET("/aviaticket", auth.HandleAuth(func (context echo.Context) error {
		return aviatickets.Get(context, aviaticketsModel)
	}))

	server.PATCH("/aviaticket", auth.HandleAuth(func (context echo.Context) error {
		return aviatickets.Update(context, aviaticketsModel)
	}))

	server.POST("/aviaticket", auth.HandleAuth(func (context echo.Context) error {
		return aviatickets.Add(context, aviaticketsModel)
	}))

	server.DELETE("/aviaticket", auth.HandleAuth(func (context echo.Context) error {
		return aviatickets.Delete(context, aviaticketsModel)
	}))
}

func initHotelBookingsRoutes(server *echo.Echo, database *sql.DB) {
	hotelBookingsModel := model.InitHotelBookingModel(database)

	server.GET("/hotel_bookings", auth.HandleAuth(func (context echo.Context) error {
		return hotel_bookings.GetList(context, hotelBookingsModel)
	}))

	server.GET("/hotel_booking", auth.HandleAuth(func (context echo.Context) error {
		return hotel_bookings.Get(context, hotelBookingsModel)
	}))

	server.PATCH("/hotel_booking", auth.HandleAuth(func (context echo.Context) error {
		return hotel_bookings.Update(context, hotelBookingsModel)
	}))

	server.POST("/hotel_booking", auth.HandleAuth(func (context echo.Context) error {
		return hotel_bookings.Add(context, hotelBookingsModel)
	}))

	server.DELETE("/hotel_booking", auth.HandleAuth(func (context echo.Context) error {
		return hotel_bookings.Delete(context, hotelBookingsModel)
	}))
}