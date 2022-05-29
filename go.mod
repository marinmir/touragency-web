module touragency

go 1.17

require (
	github.com/labstack/echo/v4 v4.7.2
	touragency/auth v0.0.0-00010101000000-000000000000
)

replace touragency/db => ./db

replace touragency/cache => ./cache

replace touragency/auth => ./auth

replace touragency/model => ./model

replace touragency/api/v1/travel_agencies => ./api/v1/travel_agencies

replace touragency/api/v1/countries => ./api/v1/countries

replace touragency/api/v1/tour_operators => ./api/v1/tour_operators

replace touragency/api/v1/tour_clients => ./api/v1/tour_clients

replace touragency/api/v1/tour_managers => ./api/v1/tour_managers

replace touragency/api/v1/aviatickets => ./api/v1/aviatickets

replace touragency/api/v1/hotel_bookings => ./api/v1/hotel_bookings

replace touragency/api/v1/tours => ./api/v1/tours

require (
	github.com/dgrijalva/jwt-go v3.2.0+incompatible // indirect
	github.com/go-sql-driver/mysql v1.6.0 // indirect
	github.com/golang-jwt/jwt v3.2.2+incompatible // indirect
	github.com/gomodule/redigo v1.8.8 // indirect
	github.com/labstack/gommon v0.3.1 // indirect
	github.com/mattn/go-colorable v0.1.11 // indirect
	github.com/mattn/go-isatty v0.0.14 // indirect
	github.com/myesui/uuid v1.0.0 // indirect
	github.com/twinj/uuid v1.0.0 // indirect
	github.com/valyala/bytebufferpool v1.0.0 // indirect
	github.com/valyala/fasttemplate v1.2.1 // indirect
	golang.org/x/crypto v0.0.0-20210817164053-32db794688a5 // indirect
	golang.org/x/net v0.0.0-20211015210444-4f30a5c0130f // indirect
	golang.org/x/sys v0.0.0-20211103235746-7861aae1554b // indirect
	golang.org/x/text v0.3.7 // indirect
	golang.org/x/time v0.0.0-20201208040808-7e3f01d25324 // indirect
	gopkg.in/stretchr/testify.v1 v1.2.2 // indirect
	touragency/api/v1/aviatickets v0.0.0-00010101000000-000000000000 // indirect
	touragency/api/v1/countries v0.0.0-00010101000000-000000000000 // indirect
	touragency/api/v1/hotel_bookings v0.0.0-00010101000000-000000000000 // indirect
	touragency/api/v1/tour_clients v0.0.0-00010101000000-000000000000 // indirect
	touragency/api/v1/tour_managers v0.0.0-00010101000000-000000000000 // indirect
	touragency/api/v1/tour_operators v0.0.0-00010101000000-000000000000 // indirect
	touragency/api/v1/tours v0.0.0-00010101000000-000000000000 // indirect
	touragency/api/v1/travel_agencies v0.0.0-00010101000000-000000000000 // indirect
	touragency/cache v0.0.0-00010101000000-000000000000 // indirect
	touragency/db v0.0.0-00010101000000-000000000000 // indirect
	touragency/model v0.0.0-00010101000000-000000000000 // indirect
)
