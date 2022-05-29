package tour_managers

import (
	"net/http"
	"encoding/json"

	"github.com/labstack/echo/v4"
	"touragency/model"
)

type TourManager struct {
	Id int `json:"id"`
	TravelAgencyId int `json:"id_travel_agency"`
	TravelAgency string `json:"travel_agency"`
	Name string `json:"name"`
	Surname string `json:"surname"`
	Birthday string `json:"birthday"`
}

type TourManagersResponse struct {
	Managers []TourManager `json:"managers"`
}

type getTourManagersParams struct {
	Offset int `query:"offset"`
	Limit int `query:"limit"`
}

type getTourManagerParams struct {
	Id int `query:"id"`
}

type addTourManagerParams struct {
	TravelAgencyId int `json:"id_travel_agency" form:"id_travel_agency" query:"id_travel_agency"`
	Name string `json:"name" form:"name" query:"name"`
	Surname string `json:"surname" form:"surname" query:"surname"`
	Birthday string `json:"birthday" form:"birthday" query:"birthday"`
}

type deleteTourManagerParams struct {
	Id int `query:"id"`
}

func GetList(context echo.Context, tourManagersModel model.TourManagerModel, travelAgenciesModel model.TravelAgencyModel) error {
	queryParams := new(getTourManagersParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	if queryParams.Limit < 0 || queryParams.Offset < 0 {
		return echo.NewHTTPError(http.StatusBadRequest, "Limit or offset cannot be null!")
	}

	tourManagers, err := tourManagersModel.GetList(queryParams.Limit, queryParams.Offset)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	var result []TourManager

	for _, manager := range tourManagers {
		travelAgency, _ := travelAgenciesModel.Get(manager.TravelAgencyId)
		var managerItem = TourManager { 
			Id: manager.Id, 
			TravelAgencyId: manager.TravelAgencyId, 
			TravelAgency: travelAgency.Name, 
			Name: manager.Name, 
			Surname: manager.Surname, 
			Birthday: manager.Birthday, 
		}
		result = append(result, managerItem)
	}

	return context.JSON(http.StatusOK, TourManagersResponse {
		Managers: result,
	})
}

func Get(context echo.Context, tourManagersModel model.TourManagerModel, travelAgenciesModel model.TravelAgencyModel) error {
	queryParams := new(getTourManagerParams)

	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	tourManager, err := tourManagersModel.Get(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}
	travelAgency, err := travelAgenciesModel.Get(tourManager.TravelAgencyId)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.JSON(http.StatusOK, TourManager {
		Id: tourManager.Id,
		TravelAgencyId: tourManager.TravelAgencyId,
		TravelAgency: travelAgency.Name,
		Name: tourManager.Name,
		Surname: tourManager.Surname,
		Birthday: tourManager.Birthday,
	})
}

func Add(context echo.Context, tourManagersModel model.TourManagerModel) error {
	queryParams := new(addTourManagerParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := tourManagersModel.Add(queryParams.TravelAgencyId, queryParams.Name, queryParams.Surname, queryParams.Birthday)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusCreated)
}

func Update(context echo.Context, tourManagersModel model.TourManagerModel) error {
	var tourmanager TourManager

	err := json.NewDecoder(context.Request().Body).Decode(&tourmanager)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err = tourManagersModel.Update(model.TourManagerDb { Id: tourmanager.Id, TravelAgencyId: tourmanager.TravelAgencyId, Name: tourmanager.Name, Surname: tourmanager.Surname, Birthday: tourmanager.Birthday })
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}

func Delete(context echo.Context, tourManagersModel model.TourManagerModel) error {
	queryParams := new(deleteTourManagerParams)
	if err := context.Bind(queryParams); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	err := tourManagersModel.Delete(queryParams.Id)
	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return context.NoContent(http.StatusNoContent)
}
