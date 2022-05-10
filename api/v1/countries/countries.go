package countries

import (
	"net/http"
	"encoding/json"

	"github.com/labstack/echo/v4"
	"touragency/model"
)

type Country struct {
	Id int `json:"id"`
	Name string `json:"name"`
}

type getCountriesParams struct {
	Offset int `query:"offset"`
	Limit int `query:"limit"`
}

type getCountryParams struct {
	Id int `query:"id"`
}

type addCountryParams struct {
	Name string `query:"name"`
}

type deleteCountryParams struct {
	Id int `query:"id"`
}

func GetList(context echo.Context, countriesModel model.CountryModel) error {
	queryParams := new(getCountriesParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	if queryParams.Limit < 0 || queryParams.Offset < 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Limit or offset cannot be null!")
	}

	countries, err := countriesModel.GetList(queryParams.Limit, queryParams.Offset)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	var result []Country

	for _, c := range countries {
		var cItem = Country { Id: c.Id, Name: c.Name }
		result = append(result, cItem)
	}

	return context.JSON(http.StatusOK, result)
}

func Get(context echo.Context, countriesModel model.CountryModel) error {
	queryParams := new(getCountryParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	country, err := countriesModel.Get(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.JSON(http.StatusOK, country)
}

func Add(context echo.Context, countriesModel model.CountryModel) error {
	queryParams := new(addCountryParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := countriesModel.Add(queryParams.Name)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusCreated)
}

func Update(context echo.Context, countriesModel model.CountryModel) error {
	var country Country

	err := json.NewDecoder(context.Request().Body).Decode(&country)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err = countriesModel.Update(model.CountryDb { Id: country.Id, Name: country.Name })
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}

func Delete(context echo.Context, countriesModel model.CountryModel) error {
	queryParams := new(deleteCountryParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := countriesModel.Delete(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}
