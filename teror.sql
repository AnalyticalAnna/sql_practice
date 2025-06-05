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

-- Úkol 2.8
-- Kolik událostí se stalo ve třetím a čtvrtém měsíci a počet mrtvých teroristů není NULL?
select count (*)
from teror
where nkillter is not null and imonth between 3 and 4
;

-- Úkol 2.9
-- Vypiš první 3 města seřazena abecedně, kde bylo zabito 30 až 100 teroristů nebo zabito 500 až 1000 lidí. Vypiš i sloupečky nkillter a nkill.

select distinct city, nkillter, nkill
from teror
where nkillter between 30 and 100 or nkill between 500 and 1000
order by city
limit 3
;

/*

Úkol 2.10
Vypiš všechny útoky z roku 2014, ke kterým se přihlásil Islámský stát ('Islamic State of Iraq and the Levant (ISIL)'). Vypiš sloupečky IYEAR, IMONTH, IDAY, GNAME COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND a na konec přidej sloupeček EVENTIMPACT, který bude obsahovat:

'Massacre' pro útoky s víc než 1000 obětí
'Bloodbath' pro útoky s 501 - 1000 obětmi
'Carnage' pro ůtoky s 251 - 500 obětmi
'Blodshed' pro útoky se 100 - 250 obětmi
'Slaugter' pro útoky s 1 - 100 obětmi
a 'N/A' pro všechny ostatní útoky.

*/

select IYEAR, IMONTH, IDAY, GNAME, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND, 
case 
when nkill <= 100 then 'Slaughter' --pro útoky s 1 - 100 obětmi
when nkill <= 250 then 'Bloodshed' --pro útoky se 100 - 250 obětmi
when nkill <= 500 then 'Carnage' --pro ůtoky s 251 - 500 obětmi
when nkill <= 1000 then 'Bloodbath' --pro útoky s 501 - 1000 obětmi
when nkill > 1000 then 'Massacre'
else 'N/A' 
end as EVENTIMPACT
from teror
;

-- Úkol 2.11
-- Vypiš všechny útoky, které se staly v Německu, Rakousku, Švýcarsku, Francii a Itálii, s alespoň jednou mrtvou osobou. U Německa, Rakouska, Švýcarska nahraď region_txt za ‘DACH’, u zbytku nech původní region. Vypiš sloupečky IYEAR, IMONTH, IDAY, COUNTRY_TXT, REGION_TXT, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND. Výstup seřaď podle počtu raněných sestupně.

select IYEAR, IMONTH, IDAY, COUNTRY_TXT,
case 
when country_txt in ('Germany', 'Austria', 'Switzerland') then 'DACH'
else region_txt
end as region_txt
, PROVSTATE, CITY, NKILL, NKILLTER, NWOUND
from teror
where country_txt in ('Germany', 'Austria', 'Switzerland', 'France', 'Italy') and nkill >= 1
order by nwound desc
-- Bylo by lepší udělat nový sloupec s jiným názvem - například region_txt_new, ale zadání znělo takto
;

-- Úkol 3.1. Počet mrtvých a raněných po letech a měsících
-- Zjisti počet mrtvých a raněných po letech a měsících. (NKILL, NWOUND, NKILLTER)

select sum (NKILL) as sum_killed, sum (NWOUND) as sum_wound, sum (NKILLTER) as sum_killed_terrorists, iyear, imonth
from teror
group by iyear, imonth
order by iyear, imonth
;

-- Úkol 3.2. Počet mrtvých a raněných v západní Evropě po letech a měsících
-- Zjisti počet mrtvých a raněných v západní Evropě po letech a měsících. 

select nkill, nwound
from teror
where region_txt = 'Western Europe'
;

-- Úkol 3.3. Počet útoků po zemích. Seřaď je podle počtu útoků sestupně
-- Zjisti počet útoků po zemích. Seřaď je podle počtu útoků sestupně.

select country_txt, count (eventid) as pocet_utoku
from teror
group by country_txt
order by pocet_utoku desc
;

-- Úkol 3.5. Incendiary útoky
-- Kolik která organizace spáchala útoků zápalnými zbraněmi (weaptype1_txt = 'Incendiary')? Kolik při nich celkem zabila lidí? Kolik zemřelo teroristů? Kolik lidí bylo zraněno? (NKILL, NKILLTER, NWOUND).

select gname, count (eventid) as pocet_utoku, sum (nkill) as pocet_zabitych, sum (nkillter) as pocet_zabitych_teroristu, sum (nwound) as pocet_zranenych
from teror
where weaptype1_txt = 'Incendiary'
group by gname
order by pocet_utoku desc
;

-- Úkol 3.6. Incendiary útoky s alespoň 10 zraněnými
-- Stejně jako v minulém úkolu chceme vědět, kolik která organizace spáchala útoků zápalnými zbraněmi (weaptype1_txt = 'Incendiary'), kolik při nich celkem zemřelo lidí, kolik zemřelo teroristů a kolik lidí bylo zraněno (NKILL, NKILLTER, NWOUND). Rozdíl je v tom, že chceme vidět jen organizace, jejichž celkový počet obětí během útoků zápalnými zbraněmi je větší než 10. Zároveň berte v potaz pouze útoky, při kterých bylo zraněno 50 a více osob a u kterých bylo zjištěno jméno útočící teroristické organizace (nechceme tam vidět organizaci Unknown).

select gname, count (eventid) as pocet_utoku, sum (nkill) as pocet_zabitych, sum (nkillter) as pocet_zabitych_teroristu, sum (nwound) as pocet_zranenych
from teror
where weaptype1_txt = 'Incendiary' and gname != 'Unknown'
group by gname
having sum (nkill) > 10 and  sum (nwound) >= 50
order by pocet_utoku desc
;
