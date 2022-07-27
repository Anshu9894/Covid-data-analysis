/*Covid 19 Data Exploration*/
 
 /*Loading the data to have a comprehensive picture*/
 SELECT *
 FROM Portfolio_Project.coviddeaths
 WHERE continent is not null
 order by 3,4;

-- Selecting specific data that we are using
Select Location, date, total_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2;

-- Comparing Total cases vs Total Deaths
-- Shows the probaility of dying in a country

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS 'Death Probability'
from coviddeaths
where continent is not null
order by 1,2;

-- Showing the probability for United states
Select Location, date, total_cases, (total_deaths/total_cases)*100 AS 'US Death Probability'
from coviddeaths
where continent is not null
and location like '%states%'
order by 1,2;

-- Total cases vs Population
-- Shows the proportion of the population affected with Covid
Select Location, avg(population), AVG(total_cases), (avg(total_cases/population)*100) as 'Population infected'
from coviddeaths
where location like '%states%'
GROUP BY Location;

-- Countries with Highest Infection rate compared to population
Select Location, Population, MAX(total_cases) AS 'Highest Infection Count', MAX((total_cases/population))*100 AS 'PERCENT POPULATION INFECTED'
FROM coviddeaths
GROUP BY Location, population
order by 'PERCENT POPULATION INFECTED' DESC;

-- Countries with Highest Death count per
Select Continent, Location, MAX(total_deaths) AS 'TOTAL DEATH COUNT'
FROM coviddeaths
WHERE Continent is not null
group by Continent,Location;

-- BREAKING THINGS DOWN BY CONTINENT

-- SHOWING CONTINENTS WITH HIGHEST DEATH COUNT PER POPULATION
SELECT CONTINENT, MAX(total_deaths) as TOTAL_DEATH_COUNT
FROM coviddeaths
WHERE continent is not null
Group by continent
order by total_death_count desc;

-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as death_percentage
FROM coviddeaths
where continent is not null
order by 1,2;

-- TOTAL POPULATION VS VACCINATIONS
-- SHOWS PERCENTAGE OF POPULATION THAT HAS RECEIVED AT LEAST ONE COVID VACCINE
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over ( partition by location order by location) as Rolling_people_vaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
     ON dea.location = vac.location
     and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3;

-- Using CTE to perform calculation on Partition by in previous query
WITH PopulationvsVaccination(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
	   SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
      ON dea.location = vac.location
      and dea.date = vac.date
where dea.continent is not null
)
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PopulationvsVaccination;

-- Using temp table perform calculation on Partition By in previous query
DROP TABLE if exists Percentpopulationvaccinated;
CREATE table Percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVapercentpopulationvaccinatedccinated numeric
);
Insert into Percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(VAC.new_vaccinations) over (partition by dea.location, dea.date) as RollingPeopleVaccinated
FROM coviddeaths dea
JOIN covidvaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date;
    
Select *, (Rollingpeoplevaccinated/population)*100
FROM Percentpopulationvaccinated;

-- creating view to store data for later visualization
create view Percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null;



