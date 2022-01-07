--select * 
--from PortfolioProject..covidVaccination$
--order by 3,4

select * 
from PortfolioProject..['covid death$']
where continent is not null
order by 3,4

select location, date, total_cases, new_cases_smoothed, total_deaths, population
from PortfolioProject..['covid death$']
order by 1,2

--total cases versus total deaths
--shows the likelihood of dying if you contract covid.
select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..['covid death$']
where location ='Nigeria'
order by 1,2


--looking at total cases vs Population
select location, date,population, total_cases, (total_cases/population)*100 as DeathPercentage
from PortfolioProject..['covid death$']
where location ='Nigeria'
order by 1,2


--countries with highest infection compared to population
select Location,population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as percentPopulationInfected
from PortfolioProject..['covid death$']
--where location ='Nigeria'
group by Location, population
order by percentPopulationInfected DESC


-- COUNTRIES with the highest death count per population
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..['covid death$']
--where location ='Nigeria'
where continent is not null
group by location
order by TotalDeathCount DESC


-- continent with the highest death rate
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..['covid death$']
--where location ='Nigeria'
where continent is not null
group by continent
order by TotalDeathCount DESC
 

 --global numbers
select sum(new_cases_per_million)as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases_per_million) *100 as DeathPercentage
from PortfolioProject..['covid death$']
--where location ='Nigeria'
where continent is not null
order by 1,2


--use CTE
with PopvsVac(continent,locatiom, date, population, new_vaccinations,RollingPeopleVaccinated)
as
(
--looking at total vaccination against population
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER(Partition by dea.Location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..['covid death$'] as dea
join PortfolioProject..covidVaccination$ as vac
on dea.location = vac.location
and dea.date = vac.date
--where vac.new_vaccinations is not null
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3
)

select *, (RollingPeopleVaccinated/Population)*100 from PopvsVac


--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar(255),
Date Datetime, 
Population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER(Partition by dea.Location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..['covid death$'] as dea
join PortfolioProject..covidVaccination$ as vac
on dea.location = vac.location
and dea.date = vac.date
--where vac.new_vaccinations is not null
--where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- creating view to store data for later visualizations
DROP VIEW IF exists [PercentPopulationVaccinated]
create View PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER(Partition by dea.Location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..['covid death$'] as dea
join PortfolioProject..covidVaccination$ as vac
on dea.location = vac.location
and dea.date = vac.date
--where vac.new_vaccinations is not null
where dea.continent is not null 

select * from PercentPopulationVaccinated

