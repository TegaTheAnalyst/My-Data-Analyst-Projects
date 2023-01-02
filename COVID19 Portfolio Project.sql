

Select *
From PortfolioProjectOne.dbo.CovidDeathsWork
order by 3,4


--Select *
--From PortfolioProjectOne.dbo.CoviddVaccination
--order by 3,4

Select Location, date, total_cases,new_cases,total_deaths,population
From PortfolioProjectOne.dbo.CovidDeathsWork
Where continent is not null
order by 1,2

--total_cases vs death_cases in nigeria
Select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectOne.dbo.CovidDeathsWork
Where location like '%nigeria%' and continent is not null
order by 1,2

--total_case vs population
--percentage of population that had covid
Select Location, date,population, total_cases,(total_cases/population)*100 as PopulationPercentageInfected
From PortfolioProjectOne.dbo.CovidDeathsWork
Where location like '%nigeria%' and continent is not null
order by 1,2

--Countries with highest infection rate compared to population
Select Location,population, MAX(total_cases) as HighestInfection ,MAX((total_cases/population))*100 as PopulationPercentageInfected
From PortfolioProjectOne.dbo.CovidDeathsWork
Where continent is not null
Group by location, population
order by PopulationPercentageInfected desc

--Countries with Highest Death per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProjectOne.dbo.CovidDeathsWork
Where continent is not null
Group by location
order by TotalDeaths desc


--continent with highest death count

Select Continent, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProjectOne.dbo.CovidDeathsWork
Where continent is not null
Group by continent
order by TotalDeaths desc


--Global cases

Select date,SUM(new_cases) as total_case, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectOne.dbo.CovidDeathsWork
Where continent is not null
Group by date
order by 1,2


--Total case

Select SUM(new_cases) as total_case, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectOne.dbo.CovidDeathsWork
Where continent is not null
order by 1,2


--Total Population vs Vaccination
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProjectOne.dbo.CovidDeathsWork dea
Join PortfolioProjectOne.dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3



--CTE

;With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
   SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProjectOne.dbo.CovidDeathsWork dea
Join PortfolioProjectOne.dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollingPeople
From PopvsVac


--TEMP TABLE

--DROP Table  if  exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)


--Insert into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--   SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--From PortfolioProjectOne.dbo.CovidDeathsWork dea
--Join PortfolioProjectOne.dbo.CovidVaccinations vac
--    On dea.location = vac.location
--	and dea.date = vac.date

--Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollingPeople
--From #PercentPopulationVaccinated

--VIEW

CREATE VIEW
PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProjectOne.dbo.CovidDeathsWork dea
Join PortfolioProjectOne.dbo.CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

