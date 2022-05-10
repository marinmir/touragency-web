package hotel_bookings

import (
	"net/http"
	"encoding/json"

	"github.com/labstack/echo/v4"
	"touragency/model"
)

type HotelBooking struct {
	Id int `json:"id"`
	DateStart string `json:"date_start"`
	DateEnd string `json:"date_end"`
	Price int `json:"price"`
}

type getHotelBookingsParams struct {
	Offset int `query:"offset"`
	Limit int `query:"limit"`
}

type getHotelBookingParams struct {
	Id int `query:"id"`
}

type addHotelBookingParams struct {
	DateStart string `query:"date_start"`
	DateEnd string `query:"date_end"`
	Price int `query:"price"`
}

type deleteHotelBookingParams struct {
	Id int `query:"id"`
}

func GetList(context echo.Context, hotelBookingsModel model.HotelBookingModel) error {
	queryParams := new(getHotelBookingsParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	if queryParams.Limit < 0 || queryParams.Offset < 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Limit or offset cannot be null!")
	}

	hotelBookings, err := hotelBookingsModel.GetList(queryParams.Limit, queryParams.Offset)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	var result []HotelBooking

	for _, hb := range hotelBookings {
		var hbItem = HotelBooking { Id: hb.Id, DateStart: hb.DateStart, DateEnd: hb.DateEnd, Price: int(hb.Price * 100) }
		result = append(result, hbItem)
	}

	return context.JSON(http.StatusOK, result)
}

func Get(context echo.Context, hotelBookingsModel model.HotelBookingModel) error {
	queryParams := new(getHotelBookingParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	hotelBooking, err := hotelBookingsModel.Get(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.JSON(http.StatusOK, hotelBooking)
}

func Add(context echo.Context, hotelBookingsModel model.HotelBookingModel) error {
	queryParams := new(addHotelBookingParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := hotelBookingsModel.Add(queryParams.DateStart, queryParams.DateEnd, float32(queryParams.Price) / 100)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusCreated)
}

func Update(context echo.Context, hotelBookingsModel model.HotelBookingModel) error {
	var hotelBooking HotelBooking

	err := json.NewDecoder(context.Request().Body).Decode(&hotelBooking)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err = hotelBookingsModel.Update(model.HotelBookingDb { Id: hotelBooking.Id, DateStart: hotelBooking.DateStart, DateEnd: hotelBooking.DateEnd, Price: float32(hotelBooking.Price) / 100 })
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}

func Delete(context echo.Context, hotelBookingsModel model.HotelBookingModel) error {
	queryParams := new(deleteHotelBookingParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := hotelBookingsModel.Delete(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}
