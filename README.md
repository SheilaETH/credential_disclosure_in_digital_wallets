# Artifacts for Credential Disclosure in (EU) Digital Identity Wallets: Compliance, Privacy Risks and Practical Mitigations

### LLM use declaration

The code was written with support from GitHub Copilot

### Mongo DB Setup Instructions

#### 1. Build the Docker Image

```bash
docker build -t results-db .
```

#### 2. Run the Container

```bash
docker run -d \
  --name results-db \
  -p 27017:27017 \
  results-db
```

The container will automatically:
- Start MongoDB 8.2.4
- Restore all data from `data.archive` using the `restore.sh` script
- Create a root user with the following credentials:
  - Username: `root`
  - Password: `example`

#### 3. Connect to MongoDB

You can connect to the running MongoDB instance using:

```
mongodb://root:example@localhost:27017/admin
```

Or using the MongoDB shell:

```bash
mongosh "mongodb://root:example@localhost:27017/admin"
```

### Stopping and Cleaning Up

Stop the container:
```bash
docker stop results-db
```

Remove the container:
```bash
docker rm results-db
```

Remove the image:
```bash
docker rmi results-db
```

### Databases and Collections

The `data.archive` file contains 3 databases:

#### 1. `expert_survey_clean_data`

Contains expert survey data from cybersecurity, policy, law, and ethics experts with the following collections:

- **`cleaned_expert_survey_cybersecurity_ids`**: IDs of cybersecurity expert participants
  - Format: `{'_id': ObjectId(), 'survey_id': <id>}`
- **`cleaned_expert_survey_policy_ids`**: IDs of policy expert participants
  - Format: `{'_id': ObjectId(), 'survey_id': <id>}`
- **`cleaned_expert_survey_law_ids`**: IDs of law expert participants
  - Format: `{'_id': ObjectId(), 'survey_id': <id>}`
- **`cleaned_expert_survey_ethics_ids`**: IDs of ethics expert participants
  - Format: `{'_id': ObjectId(), 'survey_id': <id>}`
- **`cleaned_expert_survey_responses`**: Survey responses with form data
  - Each document has fields: `id`, `form`, and `values`
  - **Form: `websiteCredentialsOpinions`**: Array of expert opinions
    - Each item contains:
      - `website`: Website name
      - `necessaryCredentials`: Array of credential IDs 
      - `permissibleCredentials`: Array of credential IDs 
#### 2. `user_survey_clean_data`

Contains user survey data about credential sharing preferences with the following collections:

- **`cleaned_user_survey_ids`**: IDs of all valid participants in the user survey
  - Format: `{'_id': ObjectId(), 'survey_id': <id>}`
- **`cleaned_user_survey_responses`**: Survey responses with multiple forms
  - Each document has fields: `id`, `form`, and `values`
  - **Form: `preSurvey`**: Demographic and background information
    - Contains question-answer pairs 
  - **Form: `selectPersonalCredentials`**: Personal credentials selection
    - Array of credentials that participants possess
  - **Form: `credentialTasks`**: Credential sharing comfort levels
    - Each item contains:
      - `credential`: Credential ID
      - `comfort`: Comfort level rating 
      - `discomfort`: Discomfort level rating 
      - `frequency`: Frequency of use rating
  - **Form: `websiteCredentialsOpinions`**: User opinions on website-credential pairs
    - Each item contains:
      - `website`: Website name
      - `necessaryCredentials`: Array of credential IDs
      - `permissibleCredentials`: Array of credential IDs

#### 3. `user_study_clean_data`

Contains user study data from controlled experiments with the following collections:

- **`cleaned_user_study_ids`**: Participant IDs
  - Format: `{'_id': ObjectId(), 'study_id': <id>}`
- **`cleaned_user_study_responses`**: Study responses with multiple forms
  - Each document has fields: `id`, `form`, and `values` (plus additional metadata)
  - **Form: `preSurvey`**: Demographic and background information
    - Contains question-answer pairs 
  - **Form: `scenarioAnswers`**: Decision responses for study scenarios
    - Additional fields: `scenarioGroup`, `group`, `expertType`, `badResponseRate`
    - Each item in `values` array contains:
      - `website`: Scenario identifier
      - `decision`: User's decision ('yes' or 'no')
      - `scenarioGroup`: which set a user belonged to
      - `group`: which study group a user belonged to
      - `badResponseRate`: how often a user saw bad Credential Assistant outputs
      - `expertType`: if the user saw expert types
  - **Form: `postSurvey`**: Post-study questionnaire
    - Contains question-answer pairs

### Files and Python Notebooks

#### Python Notebooks

There are 3 python notebooks:

1) `read_in_data.ipynb` reads the data in the MongoDB and generates the 15 files in the data folder uses auxiliary data from the files folder
2) `generate_tables.ipynb` uses the data in the data, aggregate_demographics_data, and files folders to generate the 30 tables in the tables folder (and one chart in the charts folder)
3) `generate_figures.ipynb` uses the data in the aggregate_demographics_data, tables, and files folders to generate 30 of the charts in the charts folders

The data in the data, tables, and charts folders are pre-loaded. If you want to run the code on empty data, tables, and charts folders, the code must be run in order `read_in_data.ipynb` -> `generate_tables.ipynb` -> `generate_figures.ipynb`

**The data in the files folder is not generated and must be present.**
**The code must be run from the folder it is in (not from a parent folder or child folder)**

#### Files

There are 5 folder with files, 3 of which are generated from the code:

1) `aggregate_demographics_data` contains the aggregated demographic breakdown of responses and the number of participants in each demographic category. (Cannot be generated as we do not provide the demographics responses as promised in our consent form)
2) `charts` charts for the paper. Can be generated with `generate_tables.ipynb` -> `generate_figures.ipynb` (`read_in_data.ipynb` -> `generate_tables.ipynb` -> `generate_figures.ipynb` if starting from empty data)
3) `data` generated data from the DB data to make results easier to read and analyze. Can be generated with `read_in_data.ipynb`
4) `files` auxiliary files needed for the code:
    - Manual evaluation of which credential x website pairs have a good use-case
    - Website, credential, scenario data which was used for the survey and user study (e.g., website size, scenario details, credential names)
    - Manual excel evaluations of data
5) `survey_material` material used for the survey/user study generation:
    - `credentials.docx` list of all credentials and their attributes
    - `expert_websites.xlsx` list of all websites used for the expert survey with their traffic size (based on Cloudflare Radar in May 2025), HQs, and descriptions
    - `questions_survey_expert.docx` list of all questions and response possibilities for the expert survey
    - `questions_survey_user.docx` list of all questions and response possibilities for the user survey
    - `questions_user_study.docx` list of all questions and response possibilities for the user study
    - `user_study_scenarios.xlsx` list of all scenarios evaluated in the user study
    - `user_websites.xlsx` list of all websites used for the user survey with their traffic size (based on Cloudflare Radar in May 2025), HQs, and descriptions
6) `tables` generated tables from raw data. Can be generated with `read_in_data.ipynb` (`read_in_data.ipynb` -> `generate_tables.ipynb` if starting from empty data)

### Limitations to Open Science Disclosure

As promised to our participants in the consent form, we do not publish the full demographics responses of our participants to protect the anonymity of our participants. Thus, it is not possible to generate the aggregate_demographics_data from the database.

Furthermore, as promised to our participants in the consent form, we have removed all free text responses from the dataset to protect the anonymity of our participants.