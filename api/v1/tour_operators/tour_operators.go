package tour_operators

import (
	"net/http"
	"encoding/json"

	"github.com/labstack/echo/v4"
	"touragency/model"
)

type TourOperator struct {
	Id int `json:"id"`
	Name string `json:"name"`
}

type TourOperatorsResponse struct {
	TourOperators []TourOperator `json:"tour_operators"`
}

type getTourOperatorsParams struct {
	Offset int `query:"offset"`
	Limit int `query:"limit"`
}

type getTourOperatorParams struct {
	Id int `query:"id"`
}

type addTourOperatorParams struct {
	Name string `json:"name"`
}

type deleteTourOperatorParams struct {
	Id int `query:"id"`
}

func GetList(context echo.Context, tourOperatorsModel model.TourOperatorModel) error {
	queryParams := new(getTourOperatorsParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	if queryParams.Limit < 0 || queryParams.Offset < 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Limit or offset cannot be null!")
	}

	tourOperators, err := tourOperatorsModel.GetList(queryParams.Limit, queryParams.Offset)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	var result []TourOperator

	for _, tourOperator := range tourOperators {
		var toItem = TourOperator { Id: tourOperator.Id, Name: tourOperator.Name }
		result = append(result, toItem)
	}

	return context.JSON(http.StatusOK, TourOperatorsResponse { TourOperators: result })
}

func Get(context echo.Context, tourOperatorsModel model.TourOperatorModel) error {
	queryParams := new(getTourOperatorParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	tourOperator, err := tourOperatorsModel.Get(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.JSON(http.StatusOK, tourOperator)
}

func Add(context echo.Context, tourOperatorsModel model.TourOperatorModel) error {
	queryParams := new(addTourOperatorParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := tourOperatorsModel.Add(queryParams.Name)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusCreated)
}

func Update(context echo.Context, tourOperatorsModel model.TourOperatorModel) error {
	var tourOperator TourOperator

	err := json.NewDecoder(context.Request().Body).Decode(&tourOperator)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err = tourOperatorsModel.Update(model.TourOperatorDb { Id: tourOperator.Id, Name: tourOperator.Name })
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}

func Delete(context echo.Context, tourOperatorsModel model.TourOperatorModel) error {
	queryParams := new(deleteTourOperatorParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := tourOperatorsModel.Delete(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}
