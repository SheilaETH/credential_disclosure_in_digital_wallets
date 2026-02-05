# Artifacts for Credential Disclosure in (EU) Digital Identity Wallets: Compliance, Privacy Risks and Practical Mitigations

### LLM use declaration

The code was written with support from GitHub Copilot

### Repository Structure

This repository contains:
- **Dockerfile**: Used to build and run MongoDB with pre-loaded data
- **restore.sh**: Script to restore the database archives into MongoDB
- **Three archive files**: `data_survey_user.archive`, `data_survey_expert.archive`, `data_user_study.archive` - compressed MongoDB database backups
- **Three Jupyter notebooks**: For data processing and to generate the charts for the paper
- **Auxiliary data and results**: Pre-generated output files and supplementary data

### System Requirements

Before proceeding, ensure you have the following installed on your system:

- **Docker** (version 1.44 or higher)
- **Python** (version 3.7 or higher)
- **Jupyter Notebook** or **Jupyter Lab**
- **mongosh** (MongoDB shell)

You can verify Docker version by running:
```bash
docker version
```

### Installing Python Dependencies

The notebooks require the following Python packages. Install them using pip:

```bash
pip install pymongo numpy pandas scipy seaborn statsmodels matplotlib
```

### Mongo DB Setup Instructions

#### 1. Build the Docker Image

```bash
docker build -t results-db .
```

**Troubleshooting**: If you encounter an error like `client version 1.42 is too old. Minimum supported API version is 1.44`, run:
```bash
DOCKER_API_VERSION=1.XX docker build -t results-db .
```
Replace `XX` with your Docker API version (check with `docker version`).

#### 2. Run the Container

```bash
docker run -d \
  --name results-db \
  -p 27017:27017 \
  results-db
```

The container will automatically:
- Start MongoDB 8.2.4
- Restore all data from the three archive files (`data_survey_user.archive`, `data_survey_expert.archive`, `data_user_study.archive`) using the `restore.sh` script
- Create a root user with the following credentials:
  - Username: `root`
  - Password: `example`

#### 3. Connect to MongoDB

You can verify that MongoDB is running and accessible by connecting to it using the MongoDB shell. This is useful for troubleshooting connectivity issues:

```bash
mongosh "mongodb://root:example@localhost:27017/admin"
```

If the connection succeeds, you should see a MongoDB prompt. This confirms that the database is properly set up and accessible for the Jupyter notebooks.

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

### Running Jupyter Notebooks

Navigate to the project directory and start Jupyter using:

```bash
jupyter notebook
```

Or if you prefer Jupyter Lab:

```bash
jupyter lab
```

This will open Jupyter in your default web browser. Navigate to one of the notebook files to begin. Make sure you have installed all Python dependencies (see "Installing Python Dependencies" section above) before running the notebooks.

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

1) `read_in_data.ipynb` - Reads data from MongoDB and generates 11 data files (stored in the `data` folder)
2) `generate_tables.ipynb` - Processes data files to generate 30 CSV tables in the `tables` folder (and one chart)
3) `generate_figures.ipynb` - Creates the 30 charts for the paper in the `charts` folder

The `data`, `tables`, and `charts` folders contain pre-generated outputs. If you want to regenerate all outputs from scratch the notebooks must be run in order: `read_in_data.ipynb` -> `generate_tables.ipynb` -> `generate_figures.ipynb`

**Important**: The `files` and `aggregate_demographics_data` folders contains data required to run the other notebooks. It must be present. Do not modify or delete these files.

**Important**: Run the code from the root folder (not from parent or child directories).

#### Files

There are 6 folders with files, 3 of which are generated from the code:

1) **`aggregate_demographics_data`** - Aggregated demographic overview and the responses split by demographic category. **Cannot be generated** as promised in the consent form demographic response data is not published to protect participant anonymity.

2) **`charts`** - Contains the charts used in the paper. Can be generated by running `generate_tables.ipynb` -> `generate_figures.ipynb`(`read_in_data.ipynb` -> `generate_tables.ipynb` -> `generate_figures.ipynb` if starting from empty data folder)

3) **`data`** - generated data from the DB data to make results easier to read and analyze. Can be generated with `read_in_data.ipynb`

4) **`files`** - Auxiliary data required to run the notebooks (cannot be generated, must be present):
    - Manual evaluation of which credential x website pairs have a good use-case
    - Website, credential, scenario data which was used for the survey and user study (e.g., website size, scenario details, credential names)
    - Manual excel evaluations of data
5) **`survey_material`** - material used for the survey/user study generation:
    - `credentials.docx` - list of all credentials and their attributes
    - `expert_websites.xlsx` - list of all websites used for the expert survey with their traffic size (based on Cloudflare Radar in May 2025), HQs, and descriptions
    - `questions_survey_expert.docx` - list of all questions and response possibilities for the expert survey
    - `questions_survey_user.docx` - list of all questions and response possibilities for the user survey
    - `questions_user_study.docx` - list of all questions and response possibilities for the user study
    - `user_study_scenarios.xlsx` - list of all scenarios evaluated in the user study
    - `user_websites.xlsx` - list of all websites used for the user survey with their traffic size (based on Cloudflare Radar in May 2025), HQs, and descriptions

6) **`tables`** - generated tables from raw data. Can be generated with `generate_tables.ipynb` (`read_in_data.ipynb` -> `generate_tables.ipynb` if starting from empty data folder)

### Limitations to Open Science Disclosure

As promised to our participants in the consent form, we do not publish the full demographics responses of our participants to protect the anonymity of our participants. Thus, it is not possible to generate the aggregate_demographics_data from the database.

Furthermore, as promised to our participants in the consent form, we have removed all free text responses from the dataset to protect the anonymity of our participants.