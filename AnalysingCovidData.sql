--SELECT *
--	FROM CovidCasesPortfolioProject.dbo.CovidDeaths
--  Where continent is not null
--    ORDER BY 3,4  ---i.e by location and date

--- or u can just rightclick on that table name (file) and select top 1000 rows to view

--SELECT *
--	FROM CovidCasesPortfolioProject..CovidVaccinations  --- .dbo. or .. (2 dots) is the same syntax
--  Where continent is not null
--    ORDER BY 3,4 ---(Sorted by these 2 columns)

--- We will select the data i.e. the columns we are going to be using :

--SELECT Location, Continent, date, total_cases, new_cases, total_deaths, population
--FROM CovidCasesPortfolioProject..CovidDeaths
--  Where continent is not null
--order by 1,2

---1. Exploring the case of Total Deaths against Total Cases registered
--- Shows likelihood of dying if one contracts covid in their country

--SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercent
--FROM CovidCasesPortfolioProject..CovidDeaths
--WHERE Location like '%India%' and continent is not null
--order by 1,2

---2.Looking at Total Cases vs Population
--- Shows what percent of population is affected by covid (got covid)..

--SELECT Location, Continent, date,population, total_cases,total_deaths,(total_cases/population)*100 AS InfectedPopulationPercent
--FROM CovidCasesPortfolioProject..CovidDeaths
-----WHERE Location like '%India%' and continent is not null
--order by 1,2

---3.Looking at countries with Highest infection rate compared to population

--SELECT Location, population, MAX(total_cases) AS HighestInfectedCount, /*total_deaths,*/ MAX((total_cases/population))*100 AS InfectedPopulationPercent
--FROM CovidCasesPortfolioProject..CovidDeaths
-----WHERE Location like '%India%' and continent is not null
--Group by location, population 
--order by 4 DESC
---this group by is required for when aggregate functions are used otherwise gives an error : Msg 8120, Level 16, State 1, Line 35
---Column 'CovidCasesPortfolioProject..CovidDeaths.total_cases' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.

---219 values as o/p or result if it it includes 'Worl huh

---4. Showing Countries with the highest Death count per population

--SELECT Location, population, MAX(cast(total_deaths as int)) AS HighestDeathCount
--FROM CovidCasesPortfolioProject..CovidDeaths
--Where continent is not null ---WHERE Location like '%India%'
--Group by location, population 
--order by 3 desc

---5. Breaking things down by Continent
---   Showing Continents with the highest death count per population

--SELECT continent, MAX(cast(total_deaths as int)) AS HighestDeathCount
--FROM CovidCasesPortfolioProject..CovidDeaths
--Where continent is not null ---WHERE Location like '%India%'
--Group by continent
--order by HighestDeathCount desc

---is not accurate as continents are more than 6 and North America should include count more than that of Canada and so fact check ..query check:

--SELECT location, MAX(cast(total_deaths as int)) AS HighestDeathCount
--FROM CovidCasesPortfolioProject..CovidDeaths
--Where continent is null 
--Group by location
--order by HighestDeathCount desc

---6. Drill Down Effect:
---		Breaking things down to Global numbers:

--Select date, SUM(new_cases) as sumtotal_cases, SUM(cast( new_deaths as int)) as sumtotal_deaths, SUM( CAST( New_deaths as int))/SUM(New_cases)*100 as death_percent
--From CovidCasesPortfolioProject..CovidDeaths
--where continent is not null
--Group by date
--order by 1,2

--Select SUM(new_cases) as sumtotal_cases, SUM(cast( new_deaths as int)) as sumtotal_deaths, SUM( CAST( New_deaths as int))/SUM(New_cases)*100 as death_percent
--From CovidCasesPortfolioProject..CovidDeaths
--where continent is not null
----Group by date
--order by 1,2

---7. Looking at Total Population vs Vaccinations
---		Checking how many people in this world and different parts of the world got vaccinated;

--SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations
--FROM CovidCasesPortfolioProject..CovidDeaths Dea
--Join CovidCasesPortfolioProject..CovidVaccinations Vac
--	On Dea.location = Vac.location
--	and Dea.date = Vac.date
--   where Dea.continent is not null
--order by 2,3  ---/order by 1,2,3

---note: there's also total_vaccinations not just new_vaccinations per day... what's the difference btw tho ?!

---  ***  Partition by use case ahead : A window function *** ---

--SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, Vac.new_vaccinations)) OVER (Partition by Dea.Location Order by Dea.location, Dea.date) as RollingCountVaccinationsPerLocationandDate
--FROM CovidCasesPortfolioProject..CovidDeaths Dea
--Join CovidCasesPortfolioProject..CovidVaccinations Vac
--	On Dea.location = Vac.location
--	and Dea.date = Vac.date
--   where Dea.continent is not null
--order by 2,3 
      
	  ---// here, we use convert instead of cast function, works the same

---8. Since we cannot calculate on a newly created column with an existing column, CTE or temptables come into picture : ---

--SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, Vac.new_vaccinations)) OVER (Partition by Dea.Location Order by Dea.location, Dea.date) as RollingCountVaccinationsPerLocationandDate
--FROM CovidCasesPortfolioProject..CovidDeaths Dea
--Join CovidCasesPortfolioProject..CovidVaccinations Vac
--	On Dea.location = Vac.location
--	and Dea.date = Vac.date
--   where Dea.continent is not null
--order by 2,3 

-- Use CTE

--With PopVsVac (Continent, location, date, population,New_Vaccinations, RollingCountVaccinationsperLocationandDate)
--as
--(
--SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, Vac.new_vaccinations)) OVER (Partition by Dea.Location Order by Dea.location, Dea.date) as RollingCountVaccinationsPerLocationandDate
----.. (RollingCountV.../Population)*100
--FROM CovidCasesPortfolioProject..CovidDeaths Dea
--Join CovidCasesPortfolioProject..CovidVaccinations Vac
--	On Dea.location = Vac.location
--	and Dea.date = Vac.date
--   where Dea.continent is not null
--)
--Select * , (RollingCountVaccinationsperLocationandDate/Population) *100 as RollingPercent
--From PopVsVac

---note : the number of columns in the cte should be same as the number of columns in the table columns given, otherwise we get an error---
--- The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, unless TOP, OFFSET or FOR XML is also specified.

--- 9.
--- TEMP TABLE
--- since ofc u are creating a table albeit a temp, u need to define / mention data types as well

--DROP TABLE IF EXISTS #PercentPopulationVaccinated  ---required if u do alterations
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingCountVaccinationsperLocationandDate numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, Vac.new_vaccinations)) OVER (Partition by Dea.Location Order by Dea.location, Dea.date) as RollingCountVaccinationsPerLocationandDate
----.. (RollingCountV.../Population)*100
--FROM CovidCasesPortfolioProject..CovidDeaths Dea
--Join CovidCasesPortfolioProject..CovidVaccinations Vac
--	On Dea.location = Vac.location
--	and Dea.date = Vac.date
----- where Dea.continent is not null

--   Select * , (RollingCountVaccinationsperLocationandDate/Population) *100 as RollingPercent
--	From #PercentPopulationVaccinated

--- 10.
--- Creating "View" to store data for Visualizing later

--USE CovidCasesPortfolioProject
--GO

--CREATE VIEW PercentPopulationVaccinatedView as 
--SELECT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, SUM(convert(int, Vac.new_vaccinations)) OVER (Partition by Dea.Location Order by Dea.location, Dea.date) as RollingCountVaccinationsPerLocationandDate
--FROM CovidCasesPortfolioProject..CovidDeaths Dea
--Join CovidCasesPortfolioProject..CovidVaccinations Vac
--	On Dea.location = Vac.location
--	and Dea.date = Vac.date
--   where Dea.continent is not null

--- select * from dbo.PercentPopulationVaccinated
 select * from PercentPopulationVaccinatedView
  







