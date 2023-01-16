select *
from Covid ..coviddeath
order by 3,4

select *
from Covid ..Vaccines

order by 3,4


------- select data that we are going to use 

select location,date,total_cases,new_cases,total_deaths,population
from Covid ..coviddeath

order by 1,2

 --looking at total cases vs total deaths 
 --shows likelihood of dying

select 

location,date, total_cases,total_deaths , (total_cases/total_deaths )*100 as Percentpopulationinfected

from Covid ..CovidDeath

where location like '%States%' 
order by 1,2


-- looking at total cases vs population 
-- shows what % of population got Covid 
--- max (total cases ) as highstcount    and max ( total cases/population) to see the max of each column  must be grouped by Location and population 
select 

location,date, population, total_cases, (population /total_cases)*100 as Percentpopulationinfected

from Covid ..CovidDeath

where location like '%States%' 

order by Percentpopulationinfected desc



-- max % infected 

select 

 location,population,  max (total_cases) as Highinfectioncount , max ((total_cases/population))*100 as Percenpopulationinfected
from Covid..CovidDeath

Group By location,population
Order By Percenpopulationinfected desc


------------------------------------------------------

select 

 location,population, date, max (total_cases) as Highinfectioncount , max ((total_cases/population))*100 as Percenpopulationinfected
from Covid..CovidDeath

Group By location,population,date
Order By Percenpopulationinfected desc

 
-- showing countries with Highest Death Count per population 


select 
location, max(total_deaths) as totalDeathCount

   from Covid..CovidDeath

--where location like '%States%' 

where continent is not null                 /* here i used is not null to stop grouping the */
Group by location
Order by totalDeathCount desc

-- break things down by continent 



select 
continent, max(total_deaths) as totalDeathCount

   from Covid..CovidDeath

--where location like '%States%' 

where continent is not null                 
Group by continent
Order by totalDeathCount desc




--- showing the continent with highest death count per population 


select 
continent, max(total_deaths) as totalDeathCount

   from Covid..CovidDeath

--where location like '%States%' 

where continent is not null                 
Group by continent
Order by totalDeathCount desc


------ Global NUmbers

select

SUM (new_cases)as total_cases  ,SUM(new_deaths)as total_deaths , sum(new_deaths)/sum(new_cases)*100 as DeathPercentage

from Covid ..CovidDeath

--where location like '%States%' 

where  continent is not null
--Group by date
order by 1,2



--European Union is  part of Europe

select location,sum(new_deaths) as totaldeathcount
from Covid..CovidDeath
where continent is null
and location not in ('world','European Union','International')
Group by location
order by totaldeathcount

-- Join

select *
from Covid ..CovidDeath dead
Join  Covid..Vaccines vac on dead.location=vac.location
and dead.date=vac.date

-- Looking at Total population vs vaccinations 

select dead.continent,dead.location,dead.date ,dead.population
,vac.new_vaccinations , sum( vac.new_vaccinations ) over (partition by dead.location order by dead.location ,dead.date) as RollingPepoleVaccinated
--,(RollingPepoleVaccinated/population)*100
from Covid ..CovidDeath dead
Join  Covid..Vaccines vac on dead.location=vac.location
and dead.date=vac.date

where dead.continent is not null
order by 2,3

-- use CTE


with  PopvsVac (continent,location,date,population,new_vaccinations,RollingPepoleVaccinated)

as 
(
select dead.continent,dead.location,dead.date ,dead.population
,vac.new_vaccinations , sum( vac.new_vaccinations ) over (partition by dead.location order by dead.location ,dead.date) as RollingPepoleVaccinated
--,(RollingPepoleVaccinated/population)*100
from Covid ..CovidDeath dead
Join  Covid..Vaccines vac on dead.location=vac.location
and dead.date=vac.date

where dead.continent is not null
--order by 2,3

)
select *, (RollingPepoleVaccinated/population)*100
from PopvsVac




--Temp Table 
Drop Table if exists #PerecntPopulationVaccinated
Create table #PerecntPopulationVaccinated

(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPepoleVaccinated numeric
)

insert into  #PerecntPopulationVaccinated

select dead.continent,dead.location,dead.date ,dead.population
,vac.new_vaccinations , sum( vac.new_vaccinations ) over (partition by dead.location order by dead.location ,dead.date) as RollingPepoleVaccinated
--,(RollingPepoleVaccinated/population)*100
from Covid ..CovidDeath dead
Join  Covid..Vaccines vac on dead.location=vac.location
and dead.date=vac.date

--where dead.continent is not null
--order by 2,3


select *, (RollingPepoleVaccinated/population)*100
from #PerecntPopulationVaccinated



--- Creating View to store Data for later visualizations 


Create view PerecntPopulationVaccinated as 

select dead.continent,dead.location,dead.date ,dead.population
,vac.new_vaccinations , sum( vac.new_vaccinations ) over (partition by dead.location order by dead.location ,dead.date) as RollingPepoleVaccinated
--,(RollingPepoleVaccinated/population)*100
from Covid ..CovidDeath dead
Join  Covid..Vaccines vac on dead.location=vac.location
and dead.date=vac.date

where dead.continent is not null
--order by 2,3



select * 

from PerecntPopulationVaccinated 
where new_vaccinations is not null order by 2,3