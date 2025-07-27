# Makefile

# Load environment variables from .env
include .env
export $(shell sed 's/=.*//' .env)

run:
	@echo "Running relayer with env vars from .env"
	./openzeppelin-relayer

