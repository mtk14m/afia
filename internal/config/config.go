package config

import "os"

type Config struct {
	Port string
	VLLMAddr string
	LogLevel string
}

func Load() Config{
	return Config{
		Port: getEnv("PORT", "8080"),
		VLLAddr: getEnv("VLLM_ADDR", "http://localhost:8080"),
		LogLevel: getEnv("LOG_LEVEL", "info"),
	}
}

func getEnv(key, fallback string) string{
	if v := os.GetEnv(key); v != "" {
		return v
	}
	return fallback
}

