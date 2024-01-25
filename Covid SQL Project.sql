USE [SQL Project]

SELECT * FROM CovidDeaths 
WHERE continent IS NOT NULL
ORDER BY 3,4


SELECT * FROM CovidVaccinations
ORDER BY 3,4


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2


SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%india%'
ORDER BY 1,2




SELECT location, date,population, total_cases, (total_cases/population)*100 AS InfectedPercentage
FROM CovidDeaths
WHERE location LIKE '%india%'
ORDER BY 1,2


SELECT location, population, MAX(total_cases) as HighestInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY HighestInfected DESC



SELECT location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


--Lets break things down by Continent

SELECT continent, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC






DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)




Insert into #PercentPopulationVaccinated
Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(CONVERT(int,V.new_vaccinations)) OVER (Partition by D.Location Order by D.location, D.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths D
Join CovidVaccinations V
	On D.location = V.location
	and D.date = V.date


Select *, (RollingPeopleVaccinated/Population)*100 AS PercentageVaccinated
From #PercentPopulationVaccinated