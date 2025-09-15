-- Total number of table in my Database.
SHOW Tables;

-- First five records from the tables.
SELECT *
FROM location
LIMIT 5;

SELECT *
FROM visits
LIMIT 5;

SELECT *
FROM water_source
LIMIT 5;

SELECT *
FROM employee
LIMIT 5;

SELECT *
FROM data_dictionary
LIMIT 5;

SELECT *
FROM global_water_access
LIMIT 5;

SELECT *
FROM visits
LIMIT 5;

SELECT *
FROM water_quality
LIMIT 5;

SELECT *
FROM well_pollution
LIMIT 5;

-- Unique type of water source
SELECT *
FROM water_source;
SELECT 
	DISTINCT type_of_water_source
FROM water_source;

-- Where time in queue is qreater than 500 mins.
SELECT *
FROM visits
WHERE time_in_queue > 500;

-- Types of water source where they queued for 500 mins.
SELECT *
FROM water_source
WHERE source_id IN 
('SoRu35083224',
'SoKo33124224',
'KiRu26095224',
'SoRu38776224',
'HaRu19601224',
'SoRu38869224',
'AmRu14089224',
'SoRu37635224',
'SoRu36096224',
'AkKi00881224',
'HaRu17137224');

-- Access water quality to find the subjective quality is 10 and visit count is 2.
SELECT *
FROM water_quality
WHERE subjective_quality_score = 10
AND visit_count = 2;
 
 -- Retrieve the first 5 rows of well pollution.alter
 SELECT *
 FROM well_pollution
 LIMIT 5;
 
-- Check pollution issues where the results is 'clean' but biological column is > 0.01.
SELECT *
FROM well_pollution
WHERE results = 'clean' AND biological > 0.01;

 -- Fix 'clean' with additional charaters after it in the description column.
SELECT *
FROM well_pollution
WHERE description LIKE  'Clean_%';

-- Create Table to perform an update.
CREATE TABLE well_pollution_update_table
SELECT *
FROM well_pollution;

-- Updated to safe mode.
SET SQL_SAFE_UPDATES = 0;

-- Update  query "Clean Bacteria: E. coli" to "Bacteria: E. coli"
UPDATE well_pollution_update_table
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

-- Update 'Clean Bacteria: E. coli' to 'Bacteria: Giardia Lamblia'
UPDATE well_pollution_update_table
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

-- Fix results column from 'clean' to 'Contaminated: Biological' and the biological column is > 0.01.
UPDATE well_pollution_update_table
SET results = 'Contaminated: Biological'
WHERE biological > 0.01
AND results = 'Clean';






