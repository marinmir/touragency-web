package aviatickets

import (
	"net/http"
	"encoding/json"

	"github.com/labstack/echo/v4"
	"touragency/model"
)

type Aviaticket struct {
	Id int `json:"id"`
	Price int `json:"price"`
	OneWay bool `json:"one_way"`
	TicketClass string `json:"ticket_class"`
}

type getAviaticketsParams struct {
	Offset int `query:"offset"`
	Limit int `query:"limit"`
}

type getAviaticketParams struct {
	Id int `query:"id"`
}

type addAviaticketParams struct {
	Price int `query:"price"`
	OneWay bool `query:"one_way"`
	TicketClass string `query:"ticket_class"`
}

type deleteAviaticketParams struct {
	Id int `query:"id"`
}

func GetList(context echo.Context, aviaticketsModel model.AviaticketModel) error {
	queryParams := new(getAviaticketsParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	if queryParams.Limit < 0 || queryParams.Offset < 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Limit or offset cannot be null!")
	}

	aviatickets, err := aviaticketsModel.GetList(queryParams.Limit, queryParams.Offset)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	var result []Aviaticket

	for _, a := range aviatickets {
		var aItem = Aviaticket { Id: a.Id, Price: int(a.Price * 100), OneWay: a.OneWay, TicketClass: string(a.Class) }
		result = append(result, aItem)
	}

	return context.JSON(http.StatusOK, result)
}

func Get(context echo.Context, aviaticketsModel model.AviaticketModel) error {
	queryParams := new(getAviaticketParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	aviaticket, err := aviaticketsModel.Get(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.JSON(http.StatusOK, aviaticket)
}

func Add(context echo.Context, aviaticketsModel model.AviaticketModel) error {
	queryParams := new(addAviaticketParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := aviaticketsModel.Add(float32(queryParams.Price) / 100, queryParams.OneWay, model.TicketClass(queryParams.TicketClass))
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusCreated)
}

func Update(context echo.Context, aviaticketsModel model.AviaticketModel) error {
	var aviaticket Aviaticket

	err := json.NewDecoder(context.Request().Body).Decode(&aviaticket)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err = aviaticketsModel.Update(model.AviaticketDb { Id: aviaticket.Id, Price: float32(aviaticket.Price) / 100, OneWay: aviaticket.OneWay, Class: model.TicketClass(aviaticket.TicketClass) })
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}

func Delete(context echo.Context, aviaticketsModel model.AviaticketModel) error {
	queryParams := new(deleteAviaticketParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := aviaticketsModel.Delete(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}
