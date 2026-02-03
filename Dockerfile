FROM mongo:8.2.4

ENV MONGO_INITDB_ROOT_USERNAME=root
ENV MONGO_INITDB_ROOT_PASSWORD=example

COPY data_survey_user.archive /docker-entrypoint-initdb.d/data_survey_user.archive
COPY data_survey_expert.archive /docker-entrypoint-initdb.d/data_survey_expert.archive
COPY data_user_study.archive /docker-entrypoint-initdb.d/data_user_study.archive
COPY restore.sh /docker-entrypoint-initdb.d/restore.sh

RUN chmod +x /docker-entrypoint-initdb.d/restore.sh
