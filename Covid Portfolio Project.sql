--Select *
--From dbo.CovidDeaths$
--where continent is not null
--order by 3, 4

--Select *
--From dbo.CovidVaccinations$
--order by 3, 4

--Select location, date, total_cases, new_cases, total_deaths, population
--From dbo.CovidDeaths$
--order by 1,2

--Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From dbo.CovidDeaths$
--where location like '%states%'
--order by 1,2

--Select location, date, total_cases, population, (total_cases/population)*100 as CasesPerPopulace
--from CovidDeaths$
--where location like '%states%'
--order by 1,2

--Select location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as InfectedPopulation
--from CovidDeaths$
----where location like '%states%'
--Group by continent, location, population
--order by InfectedPopulation desc


--Select location, Max(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths$
--where continent is not null
--group by continent, location
--order by TotalDeathCount desc

--Select location, Max(cast(total_deaths as int)) as TotalDeathCount, (Max(cast(total_deaths as int))/population)*100 as PercentDead
--from CovidDeaths$
--where continent is not null
--group by continent, location, population
--order by PercentDead desc

--Select location, Max(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths$
--where continent is null
--group by location
--order by TotalDeathCount desc

--Select date, Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, (Sum(cast(new_deaths as int))/Sum(new_cases)) as deathpercentage
--from CovidDeaths$
--where continent is not null
--group by date
--order by 1,2

--Select death.continent, death.location, death.date, death.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as int)) over (Partition by death.location order by death.location, death.date) as TotalVaccinationsDone
--from CovidDeaths$ death
--join CovidVaccinations$ vac
--	on death.location = vac.location
--	and death.date = vac.date
--where death.continent is not null
--order by 2,3

--With PopVsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
--as
--(
--Select death.continent, death.location, death.date, death.population, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as int)) over (Partition by death.location order by death.location, death.date) as RollingPeopleVaccinated
--from PortfolioProject1.dbo.CovidDeaths$ death
--join PortfolioProject1.dbo.CovidVaccinations$ vac
--	on death.location = vac.location
--	and death.date = vac.date
--where death.continent is not null
--)

--Select*, (RollingPeopleVaccinated/Population)*100 as PercentOfPeopleVaccinated
--From PopVsVac

--DROP Table if exists #PercentPopulationVaccinated
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
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From PortfolioProject1.dbo.CovidDeaths$ dea
--Join PortfolioProject1.dbo.CovidVaccinations$ vac
--	On dea.location = vac.location
--	and dea.date = vac.date
----where dea.continent is not null 
----order by 2,3

--Select *, (RollingPeopleVaccinated/Population)*100
--From #PercentPopulationVaccinated

--Create View PercentPopulationVaccinated as
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From PortfolioProject1.dbo.CovidDeaths$ dea
--Join PortfolioProject1.dbo.CovidVaccinations$ vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 

--Create View PercentDeadByCountry as
--Select date, Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, (Sum(cast(new_deaths as int))/Sum(new_cases)) as deathpercentage
--from PortfolioProject1.dbo.CovidDeaths$
--where continent is not null
--group by date


--Create View InfectedPopulation as
--Select location, population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as InfectedPopulation
--from PortfolioProject1.dbo.CovidDeaths$
----where location like '%states%'
--Group by continent, location, population