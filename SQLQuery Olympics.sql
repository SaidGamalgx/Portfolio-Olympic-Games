

/*   120 years of Olympic history: athletes and results*/

select * from athlete_events

select * from noc_regions

/*no of Regions in the dataset */

select count(distinct region) as TotalRegion 

from noc_regions
/* So they are 207 Countries that participated */




/* List is the total number of females and males by gender?*/


select Sex ,count(*) as totalNo
from athlete_events
Group by sex
Order by 2;

/*271*/


/* the total number of females and males by city . a query that also computes the male to female gender ratio in each city */

select 

City,Sex, Count(*) As totalNo, sum (case when Sex ='M' then 1 else 0 end)as male,
sum(case when Sex = 'F' then 1 else 0 end) as female,
sum (case when Sex ='M' then 1 else 0 end)/sum(case when Sex = 'F' then 1 else 0 end)
from athlete_events

group by City ,Sex
order by 4 desc, 5 desc



/* NO of Males vs females who won medales */





select Medal,SUM(case when Sex ='M' then 1 else 0 end ) as medalByMale,sum(case when Sex='F' then 1 else 0 end ) as medalByFemale
from athlete_events

where Medal= 'Gold'
group by Medal

select Medal,SUM(case when Sex ='M' then 1 else 0 end ) as medalByMale,sum(case when Sex='F' then 1 else 0 end ) as medalByFemale
from athlete_events

where Medal = 'Silver'
group by Medal



select Medal,SUM(case when Sex ='M' then 1 else 0 end ) as medalByMale,sum(case when Sex='F' then 1 else 0 end ) as medalByFemale
from athlete_events

where Medal= 'Bronze'
group by Medal


/*No. of Gold Medals from each ccountry  top 5 countries*/

select top 5
medal , COUNT(*) as NoofGold,region
from athlete_events a inner join noc_regions n on  a.NOC = n.NOC
where medal ='Gold'
group by region,medal
order by 2 desc


/* Age distribution of the participantsالتوزيع العمري للمشاركين */

select 
case when age < 20 then '0-20' 
when age between 20 and 30 then '20-30'
when age between  30 and 40 then  '30-40'
when age between 40 and 50 then '40-50'
when age between  50 and 60 then  '50-60'
when age between 40 and 50 then '60-70'
when age between  70 and 80 then  '70-80'
when age > 80 then  'above 80' end as age_range,age,count(age)as cnt


from athlete_events
group by age
order by age_range


/*Gold Medals from Athletes that are beyond the age of 60*/

select Sport,Medal,count(*) as numberofGolds

from athlete_events
where Medal= 'Gold' and age > 60
group by Sport,Medal;


/*List the country that has the highest number of  participants by the season (2-level ordering)*/

select top 10 
Team ,Season,count(*) as Participants 
from athlete_events

group by Team ,Season
order by Participants desc,Season


 /* Country that has won the highest number of medals and in wich year */

 select Team , count(Medal) as total , year 
 from athlete_events

 where Medal in ('Gold','Silver','Bronze')
 group by Team,Year
 Order by total desc;




 /* Medal Attained in Rion Olympics 2016*/

 select top 20 
 Team, year,Count(Medal) as NoofGoldMedals
 from athlete_events
 where Medal='Gold' and Year=2016
 group by Team,Year
 order by 3 desc


 /* Total no .of female Athelets in each olympics */


 select Sex,count(*) as FemaleAthelets,YEAR
 from athlete_events

 where sex ='F' and Season ='Summer'
 group by year ,Sex
 order by 3;


 /*no . of athletes in summer season vs winter season */

 select Season, sum(case when Season ='Summer' then 1 else 0 end ) as summersport, sum(case when Season='Winter' then 1 else 0 end ) as WinterSport
 from athlete_events

 where year >= 1986
 group by Season

 /*City that is most suitable for multiple games ti be played?*/

 select top 10
 City,count(*) as totalgamesplayed
 from athlete_events
 group by City
 order by 2 desc;


 /*List thr top 10 Most popular sports events for women ?*/

 select top 10 
 Event,count(*) as PopularSports


 from athlete_events

 where Sex='F'
 group by Event
 order by 2 Desc



  /*List thr top 10 Most popular sports events for Man ?*/


  select top 10 
 Event,count(*) as PopularSports


 from athlete_events

 where Sex='M'
 group by Event
 order by 2 Desc

/*The number of Participants in each sport and event where it held . the Participants should be sorted by their hight and weight?*/


select top 20
Sport,Event,count(*) as Participants,region,Height,Weight

from athlete_events a 
inner join noc_regions n  on a.NOC=n.NOC
group by Sport,Event,region,Height,Weight
order by 3 desc ,4 desc,5 desc,6 desc


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  SELECT
         [ID]
        ,[Name] AS 'Competitor Name' -- Renamed Column
        ,CASE WHEN SEX = 'M' THEN 'Male' ELSE 'Female' END AS Sex -- Better name for filters and visualisations
        ,[Age]
		,CASE	WHEN [Age] < 18 THEN 'Under 18'
				WHEN [Age] BETWEEN 18 AND 25 THEN '18-25'
				WHEN [Age] BETWEEN 25 AND 30 THEN '25-30'
				WHEN [Age] > 30 THEN 'Over 30'
		 END AS [Age Grouping]
        ,[Height]
        ,[Weight]
        ,[NOC] AS 'Nation Code' -- Explained abbreviation
 --       ,CHARINDEX(' ', Games)-1 AS 'Example 1'
 --       ,CHARINDEX(' ', REVERSE(Games))-1 AS 'Example 2'
        ,LEFT(Games, CHARINDEX(' ', Games) - 1) AS 'Year' -- Split column to isolate Year, based on space
--        ,RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) AS 'Season' -- Split column to isolate Season, based on space
--        ,[Games]
--        ,[City] -- Commented out as it is not necessary for the analysis
        ,[Sport]
        ,[Event]
        ,CASE WHEN Medal = 'NA' THEN 'Not Registered' ELSE Medal END AS Medal -- Replaced NA with Not Registered
  FROM athlete_events
  WHERE RIGHT(Games,CHARINDEX(' ', REVERSE(Games))-1) = 'Summer' -- Where Clause to isolate Summer Season