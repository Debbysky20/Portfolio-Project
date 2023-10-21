SELECT *
FROM PortfolioProject..[dbo.CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..['Covid vaccination$']
--ORDER BY 3,4


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..[dbo.CovidDeaths]
ORDER BY 1,2

-- Looking at the Total Cases vs Total death
-- Showing Likelihood of dyingif you contact Covid in your Country
SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
FROM PortfolioProject..[dbo.CovidDeaths]
WHERE location LIKE '%africa%' AND continent IS NOT NULL
ORDER BY 1,2

-- Total Cases vs Population
-- Percentage of population that got Covid
SELECT location, date, population, total_cases,  (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentagePopulationInfected
FROM PortfolioProject..[dbo.CovidDeaths]
--WHERE location LIKE '%africa%' 
 and continent IS NOT NULL
ORDER BY 1,2


-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((CONVERT(float, total_cases)) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentagePopulationInfected
FROM PortfolioProject..[dbo.CovidDeaths]
--WHERE location LIKE '%africa%' and continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC;


-- Countries with the Highest Death Rate per Population

SELECT location, MAX(CONVERT(int, total_deaths)) AS TotalDeathCount
FROM PortfolioProject..[dbo.CovidDeaths]
--WHERE location LIKE '%africa%' 
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- LET'S BREAK THINGS DOWN BY CONTINENT


-- Showing Continent with the Highest Death Rate per Population

SELECT continent, MAX(CONVERT(int, total_deaths)) AS TotalDeathCount
FROM PortfolioProject..[dbo.CovidDeaths]
--WHERE location LIKE '%africa%' 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;



-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths) / SUM(new_cases) * 100 AS Deathpercentage
FROM PortfolioProject..[dbo.CovidDeaths]
--WHERE location LIKE '%africa%' 
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


--LOOKING AT TOTAL POPULATION VS VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..[dbo.CovidDeaths] dea
JOIN PortfolioProject..['Covid vaccination$'] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..[dbo.CovidDeaths] dea
JOIN PortfolioProject..['Covid vaccination$'] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 1,2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- TEMP TABLE

Drop Table if exist #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..[dbo.CovidDeaths] dea
JOIN PortfolioProject..['Covid vaccination$'] vac
	ON dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 1,2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM  #PercentagePopulationVaccinated


--Create View to Store Data for later visualizations

Create View PercentagePopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..[dbo.CovidDeaths] dea
JOIN PortfolioProject..['Covid vaccination$'] vac
	ON dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 1,2,3

SELECT *
FROM PercentagePopulationVaccinated;