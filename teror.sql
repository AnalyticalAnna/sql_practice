/*
______________________________________________________________________________________________________________________
Zdroj dat: https://www.start.umd.edu/data-tools/GTD
Zadání úkolů: https://kodim.cz/czechitas/da-data-sql/sql/vyuka/cviceni-02/02-01
______________________________________________________________________________________________________________________
*/

-- Úkol 2.1
-- Vyber z tabulky TEROR útoky v Německu, kde zemřel alespoň jeden terorista.

;
select eventid, country_txt, nkillter
from teror
where country_txt = 'Germany'
and nkillter >= 1
;

-- Úkol 2.2
-- Zobraz jen sloupečky GNAME, COUNTRY_TXT, NKILL a všechny řádky (seřazené podle počtu mrtvých sestupně), na kterých je víc než 340 mrtvých (počet mrtvých je ve sloupci NKILL), sloupečky přejmenuj na ORGANIZACE, ZEME, POCET_MRTVYCH.

select gname as organizace, country_txt as zeme, nkill as pocet_mrtvych
from teror
where nkill > 340
order by nkill desc
;

-- 2.3
-- Zobraz sloupečky IYEAR, IMONTH, IDAY, GNAME, CITY, ATTACKTYPE1_TXT, TARGTYPE1_TXT, WEAPTYPE1_TXT, WEAPDETAIL, NKILL, NWOUND a vyber jen útoky, které se staly v Czech Republic v letech 2015, 2016 a 2017. Všechna data seřaď chronologicky sestupně.

select IYEAR, IMONTH, IDAY, GNAME, CITY, ATTACKTYPE1_TXT, TARGTYPE1_TXT, WEAPTYPE1_TXT, WEAPDETAIL, NKILL, NWOUND 
from teror
where country_txt = 'Czech Republic' and iyear in (2015, 2016, 2017)
;

-- 2.4
-- Vypiš všechny organizace, které na jakémkoliv místě v názvu obsahují výraz „anti“ a výraz „extremists“.
select gname
from teror
where gname ilike '%anti%' and gname ilike '%extremists'
;

-- Úkol 2.5
-- Z IYEAR, IMONTH a IDAY vytvořte sloupeček datum a vypište tohle datum a pak datum o tři měsíce později a klidně i o tři dny a tři měsíce.
;
select case when iday < 10 then ('0') || iday::text
else iday : text
end as den
from teror
;
select case when imonth < 10 then ('0') || imonth::text
else imonth : text
end as month
from teror
;

-- vytvoření sloupečku "datum"
select to_date(
case when iday < 10 then '0' || iday::text else iday::text end || '-' || 
case when imonth < 10 then '0' || imonth::text else imonth::text end || '-' || 
iyear::text, 'dd-mm-yyyy'
) as datum
from teror
;

-- vytvoření sloupečku datum o 3 měsíce později
select to_date(
case when iday < 10 then '0' || iday::text else iday::text end || '-' || 
case when imonth < 10 then '0' || imonth::text else imonth::text end || '-' || 
iyear::text, 'dd-mm-yyyy'
) as datum,
dateadd (month, 3, datum) as mesic_plus_3
from teror
;

-- Úkol 2.6
-- Vypiš všechny druhy útoků ATTACKTYPE1_TXT.
select distinct ATTACKTYPE1_TXT
from teror
;

-- Úkol 2.7
-- Vypiš všechny útoky v Německu v roce 2015, vypiš sloupečky IYEAR, IMONTH, IDAY, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND. Ve sloupečku COUNTRY_TXT bude všude hodnota ‘Německo’

select IYEAR, IMONTH, IDAY, 'Německo' as COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND, 
from teror
where country_txt = 'Germany' and iyear = 2015
;
