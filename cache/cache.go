package cache

import (
	"github.com/gomodule/redigo/redis"
)

func GetString(obj string, key string) (string, error) {
	redisConn, err := redis.Dial("tcp", "dbredis:6379")
	if err != nil {
		return "", err
	}
	defer redisConn.Close()

	var value string
	value, err = redis.String(redisConn.Do("HGET", obj, key))

	return value, err
}

func GetInt64(obj string, key string) (int64, error) {
	redisConn, err := redis.Dial("tcp", "dbredis:6379")
	if err != nil {
		return 0, err
	}
	defer redisConn.Close()

	var value int64
	value, err = redis.Int64(redisConn.Do("HGET", obj, key))

	return value, err
}

func SetString(obj string, key string, value string) error {
	redisConn, err := redis.Dial("tcp", "dbredis:6379")

	if err != nil {
		return err
	}
	defer redisConn.Close()

	_, err = redisConn.Do("HMSET", obj, key, value)

	return err
}

func SetInt64(obj string, key string, value int64) error {
	redisConn, err := redis.Dial("tcp", "dbredis:6379")

	if err != nil {
		return err
	}
	defer redisConn.Close()

	_, err = redisConn.Do("HMSET", obj, key, value)

	return err
}
