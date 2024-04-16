use projekt;
select* from pracuj;

-- 5 najbardziej pożądanych specjalizacji
Select Specialization, count(*) 
from pracuj
where Specialization != ''
group by Specialization
order by count(Specialization) desc
limit 5;

-- rozkład wymiaru pracy w % (w tym ogłoszenia bez info)
select Work_schedule, round((count(*)/(select count(*) from pracuj)) * 100,1) as 'Count_in_%'
from pracuj
group by Work_schedule;

-- rozkład typów umowy w %
select Contract_type, round((count(*)/(select count(*) from pracuj)) * 100,1) as 'Count_in_%'
from pracuj
group by Contract_type;


-- podział na poziomy stanowisk
select Position_level, count(*)
from pracuj
group by Position_level
order by count(Position_level) desc;

-- największy popyt na juniorow
select Specialization, count(*)
from pracuj
where Position_level like'%Junior%' and Specialization != ''
group by Specialization
order by count(Specialization) desc
limit 10;

# analiza ogłoszeń dotyczących data science lub BI:

-- lokalizacje z największą ilością ogłoszeń
select City, count(*)
from pracuj
where Specialization like '%Data%' or Specialization like '%business%'
group by City
order by count(City) desc
limit 10;

-- podział na poziomy stanowisk
select Position_level, count(*)
from pracuj
where Specialization like '%Data%' or Specialization like '%business%'
group by Position_level;

-- podział na wymiar pracy w %
select Work_schedule, round((count(*)/(select count(*) from pracuj where Specialization like '%Data%' or Specialization like '%business%')) * 100,1) as 'Count_in_%'
from pracuj
where Specialization like '%Data%' or Specialization like '%business%'
group by Work_schedule;

-- rozkład typów umowy w %
select Contract_type, round((count(*)/(select count(*) from pracuj where Specialization like '%Data%' or Specialization like '%business%')) * 100,1) as 'Count_in_%'
from pracuj
where Specialization like '%Data%' or Specialization like '%business%'
group by Contract_type;

-- rozkład trybu pracy w %
select Work_modes, round((count(*)/(select count(*) from pracuj where Specialization like '%Data%' or Specialization like '%business%')) * 100,1) as 'Count_in_%'
from pracuj
where Specialization like '%Data%' or Specialization like '%business%'
group by Work_modes;

