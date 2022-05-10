package tour_clients

import (
	"net/http"
	"encoding/json"

	"github.com/labstack/echo/v4"
	"touragency/model"
)

type TourClient struct {
	Id int `json:"id"`
	Name string `json:"name"`
	Surname string `json:"surname"`
	Birthday string `json:"birthday"`
}

type getTourClientsParams struct {
	Offset int `query:"offset"`
	Limit int `query:"limit"`
}

type getTourClientParams struct {
	Id int `query:"id"`
}

type addTourClientParams struct {
	Name string `query:"name"`
	Surname string `query:"surname"`
	Birthday string `query:"birthday"`
}

type deleteTourClientParams struct {
	Id int `query:"id"`
}

func GetList(context echo.Context, tourClientsModel model.TourClientModel) error {
	queryParams := new(getTourClientsParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	if queryParams.Limit < 0 || queryParams.Offset < 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Limit or offset cannot be null!")
	}

	tourClients, err := tourClientsModel.GetList(queryParams.Limit, queryParams.Offset)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	var result []TourClient

	for _, client := range tourClients {
		var clientItem = TourClient { Id: client.Id, Name: client.Name, Surname: client.Surname, Birthday: client.Birthday }
		result = append(result, clientItem)
	}

	return context.JSON(http.StatusOK, result)
}

func Get(context echo.Context, tourClientsModel model.TourClientModel) error {
	queryParams := new(getTourClientParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	tourClient, err := tourClientsModel.Get(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.JSON(http.StatusOK, tourClient)
}

func Add(context echo.Context, tourClientsModel model.TourClientModel) error {
	queryParams := new(addTourClientParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := tourClientsModel.Add(queryParams.Name, queryParams.Surname, queryParams.Birthday)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusCreated)
}

func Update(context echo.Context, tourClientsModel model.TourClientModel) error {
	var tourClient TourClient

	err := json.NewDecoder(context.Request().Body).Decode(&tourClient)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err = tourClientsModel.Update(model.TourClientDb { Id: tourClient.Id, Name: tourClient.Name, Surname: tourClient.Surname, Birthday: tourClient.Birthday })
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}

func Delete(context echo.Context, tourClientsModel model.TourClientModel) error {
	queryParams := new(deleteTourClientParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := tourClientsModel.Delete(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}
