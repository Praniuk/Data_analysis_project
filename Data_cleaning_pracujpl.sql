create database projekt;
use projekt;
set autocommit = 0;
commit;
select * from pracuj;


-- podzielenie lokalizacji na miasta i województwa, usunięcie okazjonalnych informacji o powiatach w nawiasach
alter table pracuj
rename column Location to City;
alter table pracuj
	add column Region text after City;
update pracuj
set Region = substring_index(City,',',-1),
	City = substring_index(City,',',1);
update pracuj
set City = substring_index(City,'(',1);

-- sprawdzamy kolumnę miast, zmieniamy wartość "abroad", poprawiamy województwa
select City, count(*) from pracuj
group by City
order by count(*) desc;

update pracuj
set City  = 'Za granicą'
where City = 'abroad';

update pracuj
set Region = trim(Region);
update pracuj
set Region = concat(ucase(left(Region, 1)), substring(Region, 2));


update pracuj
set Region = replace(Region, 'Masovian', 'Mazowieckie'),
Region = replace(Region, 'Lesser Poland', 'Małopolskie'),
Region = replace(Region, 'Pomeranian', 'Pomorskie'),
Region = replace(Region, 'Greater Poland', 'Wielkopolska'),
Region = replace(Region, 'Silesian', 'Śląskie'),
Region = replace(Region, 'Lower Silesia', 'Dolnośląskie'),
Region = replace(Region, 'Kuyavia-Pomerania', 'Kujawsko-pomorskie'),
Region = replace(Region, 'Opole', 'Opolskie'),
Region = replace(Region, 'Lublin', 'Lubelskie'),
Region = replace(Region, 'Lubusz', 'Lubuskie'),
Region = replace(Region, 'Abroad', 'Za granicą'),
Region = replace(Region, 'Zagranica', 'Za granicą'),
Region = replace(Region, 'West Pomeranian', 'Zachodniopomorskie'),
Region = replace(Region, 'Subcarpathia', 'Podkarpackie'),
Region = replace(Region, 'West Pomorskie', 'Zachodniopomorskie'),
Region = replace(Region, 'Łódź', 'Łódzkie'),
Region = replace(Region, 'Wielkopolska', 'Wielkopolskie');

select distinct Region from pracuj;

-- poprawienie literówki
alter table pracuj
rename column Specializaion to Specialization;

-- usunięcie niepotrzebnego tekstu w specjalizacji
update pracuj set Specialization = substr(Specialization,locate(':',Specialization) + 1)
where locate(':',Specialization) > 0;

-- sprawdzamy pola ze specjalizacją
update pracuj set Specialization = trim(Specialization);
select Specialization from pracuj
where Specialization != '';

-- sprawdzamy ile jest pól z wieloma specjalizacjami
select distinct Specialization from pracuj
where Specialization like '%,%';

-- pola te stanowią niecałe 10% naszej bazy, ponadto zazwyczaj pierwsza specjalizacja jest tą wiodącą, więc możemy przyjąć że zachowujemy tylko pierwszą po przecinku
update pracuj
set Specialization = substring_index(Specialization,',',1);

-- sprawdzamy ile jest pól z wieloma pozycjami
select distinct Position_level from pracuj
where Position_level like '%,%';

-- 13 pozycji a więc bardzo mało, spokojnie możemy zachować tylko pierwszą po przecinku
update pracuj
set Position_level = substring_index(Position_level,',',1);

-- teraz standaryzujemy
select distinct Position_level from pracuj; 

update pracuj set Position_level = 'Senior' where Position_level like '%Senior%';
update pracuj set Position_level = 'Mid' where Position_level like '%Mid%';
update pracuj set Position_level = 'Junior' where Position_level like '%Junior%';
update pracuj set Position_level = 'Expert' where Position_level like '%ekspert%' or Position_level like '%expert%'; 
update pracuj set Position_level = 'Manager' where Position_level like '%manager%' or Position_level like '%menadżer%' or Position_level like '%menedżer%'; 
update pracuj set Position_level = 'Dyrektor' where Position_level like '%director%' or Position_level like '%dyrektor%' or Position_level like '%kierownik%'; ; 
update pracuj set Position_level = 'Paktykant/Stażysta' where Position_level like '%praktykant%' or Position_level like '%trainee%';
update pracuj set Position_level = 'Asystent' where Position_level like '%asystent%' or Position_level like '%assistant%';
update pracuj set Position_level = 'Pracownik fizyczny' where Position_level like '%fizyczny%' or Position_level like '%blue%'; 

-- pola z wieloma typami umów
select distinct Contract_type from pracuj
where Contract_type like '%,%';

-- mniej niż 1%, można założyć pierwszy typ
update pracuj
set Contract_type = substring_index(Contract_type,',',1);

-- standaryzacja danych
update pracuj set Contract_type = 'Kontrakt B2B' where Contract_type like '%B2B%';
update pracuj set Contract_type = 'Umowa o pracę' where Contract_type like '%pracę%' or Contract_type like '%employment%';
update pracuj set Contract_type = 'Umowa zlecenie' where Contract_type like '%zlecenie%' or Contract_type like '%mandate%';
update pracuj set Contract_type = 'Umowa o dzieło' where Contract_type like '%dzieło%' or Contract_type like '%specific%';
update pracuj set Contract_type = 'Umowa o staż/praktyki' where Contract_type like '%staż%' or Contract_type like '%intern%';
update pracuj set Contract_type = 'Umowa na zastępstwo' where Contract_type like '%zastępstwo%';
update pracuj set Contract_type = 'Umowa o pracę tymczasową' where Contract_type like '%tymczas%' or Contract_type like '%temporary%';
update pracuj set Contract_type = 'Umowa agencyjna' where Contract_type like '%agency%';

-- sprawdzamy liczbę pól z wieloma wymiarami pracy
select distinct Work_schedule from pracuj
where Work_schedule like '%,%';

update pracuj
set Work_schedule = substring_index(Work_schedule,',',1);

-- standaryzacja
update pracuj set Work_schedule = 'Pełny etat' where Work_schedule like '%pełny%' or Work_schedule like '%full%';
update pracuj set Work_schedule = 'Część etatu' where Work_schedule like '%part%' or  Work_schedule like '%część%';
update pracuj set Work_schedule = 'Praca dodatkowa/tymczasowa' where Work_schedule like '%ymczas%' or  Work_schedule like '%temporary%';

-- kolumna trybu pracy
select distinct Work_modes from pracuj
where Work_modes like '%,%';

update pracuj
set Work_modes = substring_index(Work_modes,',',1);
update pracuj set Work_modes = 'Praca hybrydowa' where Work_modes like '%hybr%';
update pracuj set Work_modes = 'Praca stacjonarna' where Work_modes like '%stacjo%' or Work_modes like '%full%';
update pracuj set Work_modes = 'Praca zdalna' where Work_modes like '%zdalna%' or Work_modes like '%home%';
update pracuj set Work_modes = 'Praca moblina' where Work_modes like '%mobil%';

-- wyczyszczoną tabelę kopiujemy, i na skopiowanej będziemy przeprowadzać analizę
create table pracuj_clean as select * from pracuj;
select * from pracuj_clean;