# SQL – Covid 19 Data Exploration
![image](https://github.com/Anshu9894/Covid-data-analysis/assets/102878435/39791e2e-04db-4b18-b011-7ac71b80a955)
## Data Source :
https://ourworldindata.org/covid-deaths
## Skills used:
Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
## Variables Definitions:
**total_deaths**: Total deaths attributed to COVID-19. Counts can include probable deaths, where reported.

**new_deaths**:New deaths attributed to COVID-19. Counts can include probable deaths, where reported. In rare cases where our source reports a negative daily change due to a data correction, we set this metric to NA.

**total_cases:** Total confirmed cases of COVID-19. Counts can include probable cases, where reported.

**new_cases**: New confirmed cases of COVID-19. Counts can include probable cases, where reported. In rare cases where our source reports a negative daily change due to a data correction, we set this metric to NA.

### Loading the data to have a comprehensive picture
```
SELECT *
 FROM CovidDeaths$
 WHERE continent is not null
 order by 3,4;
```
![image](https://github.com/Anshu9894/Covid-data-analysis/assets/102878435/88ac7628-5b79-44fc-94ab-7fe02235ef98)

### Selecting specific data that we are using
```
Select Location, date, total_cases, total_deaths, population
from CovidDeaths$
where continent is not null
order by 1,2;
```
