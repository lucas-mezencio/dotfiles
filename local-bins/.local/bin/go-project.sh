#!/bin/env bash

PROJECT=$1
PROJECT_DIR=~/Projects/"$PROJECT"

mkdir -p "$PROJECT_DIR"

cd $PROJECT_DIR

mkdir -p cmd/foo/
touch cmd/foo/main.go
echo "package main" >> cmd/foo/main.go

mkdir -p pkg/config/
touch pkg/config/config.go
echo "package config" >> pkg/config/config.go

mkdir -p pkg/logger/
touch pkg/logger/logger.go
echo "package logger" >> pkg/logger/logger.go

mkdir -p internal/domain/
touch internal/domain/domain_entity.go
echo "package domain" >> internal/domain/domain_entity.go

mkdir -p internal/usecase/
touch internal/usecase/entity_uc.go
echo "package usecase" >> internal/usecase/entity_uc.go

mkdir -p internal/infra/database/
touch internal/infra/database/db.go
echo "package database" >> internal/infra/database/db.go

mkdir -p internal/infra/gin/
touch internal/infra/gin/server.go
echo "package gin" >> internal/infra/gin/server.go

go mod init "$PROJECT"
