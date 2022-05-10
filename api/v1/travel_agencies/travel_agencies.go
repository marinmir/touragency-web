package travel_agencies

import (
	"net/http"
	"encoding/json"

	"github.com/labstack/echo/v4"
	"touragency/model"
)

type TravelAgency struct {
	Id int `json:"id"`
	Name string `json:"name"`
	Address string `json:"address"`
}

type getTravelAgenciesParams struct {
	Offset int `query:"offset"`
	Limit int `query:"limit"`
}

type getTravelAgencyParams struct {
	Id int `query:"id"`
}

type addTravelAgencyParams struct {
	Name string `query:"name"`
	Address string `query:"name"`
}

type deleteTravelAgencyParams struct {
	Id int `query:"id"`
}

func GetList(context echo.Context, travelAgenciesModel model.TravelAgencyModel) error {
	queryParams := new(getTravelAgenciesParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	if queryParams.Limit < 0 || queryParams.Offset < 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Limit or offset cannot be null!")
	}

	travelAgencies, err := travelAgenciesModel.GetList(queryParams.Limit, queryParams.Offset)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	var result []TravelAgency

	for _, ta := range travelAgencies {
		var taItem = TravelAgency { Id: ta.Id, Name: ta.Name, Address: ta.Address }
		result = append(result, taItem)
	}

	return context.JSON(http.StatusOK, result)
}

func Get(context echo.Context, travelAgenciesModel model.TravelAgencyModel) error {
	queryParams := new(getTravelAgencyParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	travelAgency, err := travelAgenciesModel.Get(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.JSON(http.StatusOK, travelAgency)
}

func Add(context echo.Context, travelAgenciesModel model.TravelAgencyModel) error {
	queryParams := new(addTravelAgencyParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := travelAgenciesModel.Add(queryParams.Name, queryParams.Address)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusCreated)
}

func Update(context echo.Context, travelAgenciesModel model.TravelAgencyModel) error {
	var travelAgency TravelAgency

	err := json.NewDecoder(context.Request().Body).Decode(&travelAgency)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err = travelAgenciesModel.Update(model.TravelAgencyDb { Id: travelAgency.Id, Name: travelAgency.Name, Address: travelAgency.Address })
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}

func Delete(context echo.Context, travelAgenciesModel model.TravelAgencyModel) error {
	queryParams := new(deleteTravelAgencyParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := travelAgenciesModel.Delete(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}
