package tours

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"touragency/model"
	"touragency/api/v1/aviatickets"
	"touragency/api/v1/countries"
	"touragency/api/v1/hotel_bookings"
	"touragency/api/v1/tour_clients"
	"touragency/api/v1/tour_managers"
	"touragency/api/v1/tour_operators"
)

type Tour struct {
	Id int `json:"id"`
	Aviaticket aviatickets.Aviaticket `json:"aviaticket"`
	Country countries.Country `json:"country"`
	HotelBooking hotel_bookings.HotelBooking `json:"hotel_booking"`
	TourClient tour_clients.TourClient `json:"tour_client"`
	TourManager tour_managers.TourManager `json:"tour_manager"`
	TourOperator tour_operators.TourOperator `json:"tour_operator"`
}

type addTourParams struct {
	ClientId int `query:"id_client" json:"id_client" form:"id_client"`
	ManagerId int `query:"id_manager" json:"id_manager" form:"id_manager"`
	TourOperatorId int `query:"id_tour_operator" json:"id_tour_operator" form:"id_tour_operator"`
	CountryId int `query:"id_country" json:"id_country" form:"id_country"`
	HotelBookingId int `query:"id_hotel_booking" json:"id_hotel_booking" form:"id_hotel_booking"`
	AviaticketId int `query:"id_aviaticket" json:"id_aviaticket" form:"id_aviaticket"`
}

type deleteTourParams struct {
	Id int `query:"id"`
}

func Add(context echo.Context, toursModel model.TourModel) error {
	queryParams := new(addTourParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := toursModel.Add(queryParams.ClientId, queryParams.ManagerId, queryParams.TourOperatorId, queryParams.CountryId, queryParams.AviaticketId, queryParams.HotelBookingId)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusCreated)
}

func Delete(context echo.Context, toursModel model.TourModel) error {
	queryParams := new(deleteTourParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := toursModel.Delete(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}
