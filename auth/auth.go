package auth

import (
	"net/http"
	"time"
	"errors"
	"strconv"
	"strings"
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/twinj/uuid"
	"github.com/labstack/echo/v4"

	"touragency/cache"
)

type User struct {
	ID uint64       `json:"id"`
 	Username string `json:"username"`
 	Password string `json:"password"`
}

type UserNetwork struct {
 	Username string `json:"username"`
 	Password string `json:"password"`
}

type TokenDetails struct {
  AccessToken  string
  RefreshToken string
  AccessUuid   string
  RefreshUuid  string
  AtExpires    int64
  RtExpires    int64
}

type LoginResponse struct {
	AccessToken string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

var testUser = User{
 	ID:          1,
 	Username: "marina",
 	Password: "q1w2e3",
}

var accessSecret = "IoWJp2YT+Rp77bXW/glrpWZmeQJdFCU87+STvEQQz8Q=" // generated with 'openssl rand 32 | base64'
var refreshSecret = "Iq6Pq529fqtYuNL8RJI2Vh66Ptv7M1Q1DyWpfkX4/ro="
var cacheTokenKey = "access_token"

func HandleAuth(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		err := isTokenValid(c)

		if err != nil {
			return echo.NewHTTPError(http.StatusUnauthorized, err.Error())
		}

		return next(c)
	}
}

func Login(context echo.Context) error {
	u := new(UserNetwork)

	if err := context.Bind(u); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	if u.Username != testUser.Username || u.Password != testUser.Password {
		return echo.NewHTTPError(http.StatusUnauthorized, "No such user in database!")
	}

	tokenDetails, err := createToken(testUser.ID)

	if err != nil {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, err.Error())
	}

	err = saveAuth(testUser.ID, tokenDetails)
	if err != nil {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, err.Error())
	}

	tokens := LoginResponse {
		AccessToken: tokenDetails.AccessToken,
		RefreshToken: tokenDetails.RefreshToken,
	}

	return context.JSON(http.StatusOK, tokens)
}

func createToken(userId uint64) (*TokenDetails, error) {
	tokenDetais := &TokenDetails{}
	tokenDetais.AtExpires = time.Now().Add(time.Minute * 15).Unix()
	tokenDetais.AccessUuid = uuid.NewV4().String()

	tokenDetais.RtExpires = time.Now().Add(time.Hour * 24 * 7).Unix()
	tokenDetais.RefreshUuid = uuid.NewV4().String()

	var err error
	atClaims := jwt.MapClaims{}
	atClaims["authorized"] = true
	atClaims["access_uuid"] = tokenDetais.AccessUuid
	atClaims["user_id"] = userId
	atClaims["exp"] = tokenDetais.AtExpires
	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, atClaims)
	tokenDetais.AccessToken, err = accessToken.SignedString([]byte(accessSecret))
	if err != nil {
		return nil, err
	}

	rtClaims := jwt.MapClaims{}
	rtClaims["refresh_uuid"] = tokenDetais.RefreshUuid
	rtClaims["user_id"] = userId
	rtClaims["exp"] = tokenDetais.RtExpires
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, rtClaims)
	tokenDetais.RefreshToken, err = refreshToken.SignedString([]byte(refreshSecret))
	if err != nil {
		return nil, err
	}

	return tokenDetais, nil
}

func saveAuth(userId uint64, tokenDetails *TokenDetails) error {
	//accessTime := time.Unix(tokenDetails.AtExpires, 0)
	//refreshTime := time.Unix(tokenDetails.RtExpires, 0)
	//now := time.Now()

	err := cache.SetString(strconv.Itoa(int(userId)), cacheTokenKey, tokenDetails.AccessToken)

	if err != nil {
		return err
	}

	return nil
}

func extractToken(c echo.Context) string {
	bearerToken := c.Request().Header.Get("Authorization")
	strArr := strings.Split(bearerToken, " ")
	if len(strArr) == 2 {
		return strArr[1]
	}
	return ""
}

func verifyToken(c echo.Context) (*jwt.Token, error) {
	tokenString := extractToken(c)

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface {}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(accessSecret), nil
	})

	if err != nil {
		return nil, err
	}
	
	return token, nil
}

func isTokenValid(c echo.Context) error {
	token, err := verifyToken(c)
	if err != nil {
		return err
	}
	if _, ok := token.Claims.(jwt.Claims); !ok && !token.Valid {
		return err
	}

	userId := getUserIdFromToken(token)

	if userId == 0 {
		return errors.New("Can't obtain user id from token")
	}

	value, err := cache.GetString(strconv.Itoa(int(userId)), cacheTokenKey)

	if err != nil {
		return err
	}

	if value != token.Raw {
		return errors.New("Token is invalid")
	}

	return nil
}

func getUserIdFromToken(token *jwt.Token) (uint64) {
	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		return uint64(claims["user_id"].(float64))
	} else {
		return 0
	}
}
