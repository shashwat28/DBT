select 
CHANNEL,
--1. Standardize multiple date formats
TRY_CAST("DATE" as DATE) as DATE,
--This will break down the dates further, deriving various components and then binding it together again based on required custom date format
-- CONCAT(YEAR(TRY_CAST("DATE" as DATE)),'-',MONTH(TRY_CAST("DATE" as DATE)),'-',DAY(TRY_CAST("DATE" as DATE)))::DATE 
DIVISION,
--2. From SKU column extract first 3 characters as new column “BRAND”. Existing brands are CFG, CSI, MOE. If extracted column has any value other than the 3 brands then store it as NULL
case when substr(SKU,0,3) in ('CFG','CSI','MOE') then substr(SKU,0,3) else NULL end as BRAND, 
--3. From SKU column after brand till next space is the product. Extract it to new column named “PRODUCT”. For example if SKU value is “CFG40124 40124 CHROME HAND HELD”, then PRODUCT value is 40124
substr(SKU,4,position(' ',SKU,1)-4) as PRODUCT,
--4. Handle POS_UNITS to be integers
TRY_CAST(POS_UNITS as INTEGER) as POS_UNITS,
PARTNER,
SALES_ORG,
--5. Handle SALES_ to be float and rename the column to be “SALES”
TRY_CAST(SALES_ as FLOAT) as SALES,
--6. Handle UNITS_ON_HAND to be integer
TRY_CAST(UNITS_ON_HAND as INTEGER) as UNITS_ON_HAND,
--This will give only the interger part of string ignoring varchar and any punctuations alongwith whitespaces instead of handling it as NULLS.
-- REGEXP_SUBSTR(UNITS_ON_HAND,'\\d+',1,1)::INTEGER as UNITS_ON_HAND,
STORE
from BRONZE.POS.CUSTOMER_POS