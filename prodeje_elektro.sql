1. Na jaké kategorii produktů máme největší obrat? A zajímalo by mě i jestli se to v jednotlivých
měsících mění.
- Vytvořím si spojenou tabulku, cena bude odpovídat počtům kusů v daná části objednávky.
- Podívám se na součet zisku po kategoriích v čase po měsících a pak za jednotlivé kategorie
za celé období.
Odpověď: Televize (1205680).
Pozn. V datech není uvedena měna, budou to asi koruny.
--Vytvoření spojené dočasné tabulky, dopočítání ceny za počet
kusů v částech objednávky.
CREATE OR REPLACE TEMPORARY TABLE JOINED_DATA_PRODEJE AS
SELECT DP.*, P.CATEGORY, (P.PRICE * DP.QUANTITY) AS
PRICE_QUANTITY
FROM DATA_PRODEJE AS DP
LEFT JOIN PRODUCTS AS P
ON DP.PRODUCT_NAME = P.PRODUCT_NAME
;
--Přetypování sloupce DATE ba formát datum (není nutné, pokud
se formát natypuje správně během načtení dat).
CREATE OR REPLACE TEMPORARY TABLE JOINED_DATA_PRODEJE AS
SELECT TRANSACTION_ID,
TO_DATE(DATE, &#39;DD.MM.YYYY&#39;) AS DATE,
PRODUCT_NAME, QUANTITY, CATEGORY, PRICE_QUANTITY
FROM JOINED_DATA_PRODEJE
;
-- Pohled po měsících.
SELECT CATEGORY,DATE_TRUNC(&#39;MONTH&#39;, DATE) AS MESIC,
SUM(PRICE_QUANTITY) AS CELKOVY_OBAR_MESIC
FROM JOINED_DATA_PRODEJE
GROUP BY MESIC, CATEGORY
ORDER BY MESIC,CELKOVY_OBAR_MESIC DESC
;
--V každém měsíci ukáže jen nejzastoupenější kategorii.
SELECT CATEGORY,
DATE_TRUNC(&#39;MONTH&#39;, DATE) AS MESIC,
SUM(PRICE_QUANTITY) AS CELKOVY_OBRAT_MESIC
FROM JOINED_DATA_PRODEJE
GROUP BY MESIC, CATEGORY
QUALIFY ROW_NUMBER() OVER (PARTITION BY MESIC ORDER BY
SUM(PRICE_QUANTITY) DESC) = 1

;
-- Obrat za celkové období podle kategorií.
SELECT CATEGORY, SUM(PRICE_QUANTITY) AS OBRAT
FROM JOINED_DATA_PRODEJE
GROUP BY CATEGORY
ORDER BY OBRAT DESC
LIMIT 1
;

2. Který den v týdnu je nejsilnější na počet objednávek?
- Dle hodnot datumů odvodím den v týnu, pak se na data podívám podle dnů v týdnu a
vypočítám k nim počet objednávek.
Odpověď: Sobota (13 objednávek).
--Úprava tabulky – přidání nového sloupce pro dny v týdnu.
ALTER TABLE JOINED_DATA_PRODEJE
ADD COLUMN DAY_NAME STRING;
--Přidání hodnot do sloupce.
UPDATE JOINED_DATA_PRODEJE
SET day_name = TO_CHAR(DATE, &#39;DY&#39;);
--Vypočítání objednávek podle dnů v týdnu a výběr nejčastější
hodnoty.
SELECT DAY_NAME, COUNT (DISTINCT TRANSACTION_ID) AS
POCET_OBJEDNAVEK
FROM JOINED_DATA_PRODEJE
GROUP BY DAY_NAME
ORDER BY POCET_OBJEDNAVEK DESC
LIMIT 1
;

3. Která kategorie se prodává nejčastěji spolu s produkty z kategorie Televize (resp. jsou spolu
v jedné objednávce)?
- Nejprve se podívám, ve kterých objednávkách byla televize, pak se podívám, jaké v těchto
objednávkách byly kategorie kromě televize a kolikrát se vyskytly.
- Odpověď: Audio (13x).
-- Podívám se na objednávky, které obsahují televizi, z nich se
pak podívám, jaké další kategorie a kolikrát jsou zastoupeny a
vyberu jen tu nejčastější.
SELECT CATEGORY, COUNT(*) AS FREQUENCY
FROM JOINED_DATA_PRODEJE
WHERE TRANSACTION_ID IN (
SELECT DISTINCT TRANSACTION_ID
FROM JOINED_DATA_PRODEJE
WHERE category = &#39;Televize&#39;
)
AND CATEGORY &lt;&gt; &#39;Televize&#39;

GROUP BY CATEGORY
ORDER BY FREQUENCY DESC
LIMIT 1;
