---1.

SELECT SUM(new_cases) as totalCases, SUM(CAST( new_deaths as int)) as totalDeaths, SUM(CAST(new_deaths as int))/SUM(new_Cases)*100 as DeathPercent
From CovidCasesPortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Text Chart --

---2.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidCasesPortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- Bar Graph --

---3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidCasesPortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Geographical Map (Longitudes , Latitudes) --


--- 4.

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidCasesPortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

-- Line Chart --

--- And this is my url to the Dashboard i created ----
---- https://public.tableau.com/app/profile/lakshme./viz/CovidCasesPortfolioProject1RefAlextheAnalyst/Dashboard1?publish=yes ----


