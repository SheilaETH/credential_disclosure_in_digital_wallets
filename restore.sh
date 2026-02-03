#!/bin/bash
set -e

echo "Restoring data_survey_user..."
mongorestore --gzip --archive=/docker-entrypoint-initdb.d/data_survey_user.archive \
  --username="$MONGO_INITDB_ROOT_USERNAME" \
  --password="$MONGO_INITDB_ROOT_PASSWORD" \
  --authenticationDatabase=admin

echo "Restoring data_survey_expert..."
mongorestore --gzip --archive=/docker-entrypoint-initdb.d/data_survey_expert.archive \
  --username="$MONGO_INITDB_ROOT_USERNAME" \
  --password="$MONGO_INITDB_ROOT_PASSWORD" \
  --authenticationDatabase=admin

echo "Restoring data_user_study..."
mongorestore --gzip --archive=/docker-entrypoint-initdb.d/data_user_study.archive \
  --username="$MONGO_INITDB_ROOT_USERNAME" \
  --password="$MONGO_INITDB_ROOT_PASSWORD" \
  --authenticationDatabase=admin

echo "Restore completed"
