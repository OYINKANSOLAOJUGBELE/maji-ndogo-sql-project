# Maji Ndogo Water Crisis Analysis

## Project Overview

This repository contains SQL analysis scripts for the Maji Ndogo water crisis project - a comprehensive data-driven initiative to address water access and quality issues affecting millions of people in Maji Ndogo. The project analyzes a database of 60,000+ survey records collected by field engineers, scientists, and analysts.

**Project Leadership:**
- **President Aziza Naledi** - Project Sponsor
- **Chidi Kunto** - Senior Data Analyst & Mentor

## Background

Maji Ndogo faces a critical water crisis affecting millions of citizens. This analysis aims to:
- Identify water sources requiring urgent intervention
- Assess water quality and contamination levels
- Understand service delivery bottlenecks (queue times)
- Correct data integrity issues for accurate decision-making

## Database Structure

### Tables
- **location** - Geographic information (address, province, town, location type)
- **visits** - Visit logs with timestamps, queue times, and employee assignments
- **water_source** - Water source types and people served
- **water_quality** - Quality scores from field surveyors (1-10 scale)
- **well_pollution** - Contamination test results (biological and chemical)
- **employee** - Staff information
- **data_dictionary** - Built-in documentation for all columns

### Key Relationships
- `source_id` links visits to water_source table
- `location_id` links visits to location table
- `assigned_employee_id` links visits to employee table

## Water Source Types

1. **River** - Open water source with highest contamination risk
2. **Well** - Closed underground source (may be contaminated)
3. **Shared Tap** - Public taps serving 2,700-3,900+ people
4. **Tap in Home** - Ideal solution, serves ~6 people per household
5. **Broken Tap in Home** - Infrastructure exists but non-functional

## Analysis Workflow

### 1. Data Exploration
```sql
-- View all tables in database
SHOW TABLES;

-- Preview data structure
SELECT * FROM location LIMIT 5;
```

### 2. Water Source Analysis
```sql
-- Identify all water source types
SELECT DISTINCT type_of_water_source
FROM water_source;
```

### 3. Queue Time Investigation
```sql
-- Find extreme wait times (>500 minutes = 8+ hours)
SELECT *
FROM visits
WHERE time_in_queue > 500;

-- Link queue times to source types
SELECT v.record_id, v.time_in_queue, ws.type_of_water_source
FROM visits v
JOIN water_source ws ON v.source_id = ws.source_id
WHERE v.time_in_queue > 500;
```

**Key Finding:** Shared taps have extreme queue times, with people waiting 8+ hours for water.

### 4. Water Quality Assessment
```sql
-- Identify potential data quality issues
-- (Home taps with perfect scores visited multiple times)
SELECT wq.*, ws.type_of_water_source
FROM water_quality wq
JOIN water_source ws ON wq.source_id = ws.source_id
WHERE wq.subjective_quality_score = 10
  AND ws.type_of_water_source = 'tap_in_home'
  AND wq.visit_count > 1;
```

**Issue Detected:** 218 records indicate incorrect second visits to home taps.

### 5. Pollution Data Correction

#### Issue Identified
Wells marked as "Clean" despite biological contamination >0.01 CFU/mL.

**Root Cause:** Data entry personnel used description field text instead of actual measurements.

#### Incorrect Patterns Found
- "Clean Bacteria: E. coli"
- "Clean Bacteria: Giardia Lamblia"

#### Correction Process
```sql
-- Update incorrect descriptions
UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

UPDATE well_pollution
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

-- Correct results based on biological measurements
UPDATE well_pollution
SET results = 'Contaminated: Biological'
WHERE biological > 0.01
  AND results = 'Clean';
```

## Critical Findings

### 🚨 Public Health Risks
- **38 wells** incorrectly classified as clean despite contamination
- Biological contamination threshold: >0.01 CFU/mL

### ⏰ Service Delivery Issues
- People waiting **8+ hours** at shared taps
- Extreme queue times identified at multiple locations

### 📊 Data Quality Issues
- 218 erroneous second visits to home taps
- Misclassification due to description field confusion
- Required systematic data correction

## Best Practices Demonstrated

1. **Comment Before Coding** - Document intended changes before writing SQL
2. **Test on Copies** - Use `CREATE TABLE AS` to create test tables
3. **Verify Changes** - Run SELECT queries to confirm corrections
4. **Safe Updates** - Only apply changes to production after verification
5. **Clean Up** - Drop temporary tables after successful updates

## Technical Notes

### Contamination Standards
- **Biological**: >0.01 CFU/mL indicates contamination
- **Chemical**: Measured in parts per million (ppm)

### Data Aggregation
- Home tap records aggregate ~160 households into single records
- Reduces database from ~1 million to manageable size
- `number_of_people_served` represents combined household populations

### Quality Score Scale
- **1** - Terrible water quality
- **10** - Clean, safe water source
- Shared taps rated lower due to queue times and access issues

## Files in Repository

- `Maji_Ndogo_SQL_Solutions.sql` - Complete SQL analysis script
- `Maji_Ndogo_Part_1_Slides.pdf` - Project documentation and context
- `README.md` - This file

## Usage

1. Load the Maji Ndogo database in MySQL
2. Run scripts in sequential order
3. Review query results for insights
4. Use findings to prioritize infrastructure improvements

## Next Steps

- Appoint auditor to verify flagged records
- Calculate average queue times by source type
- Identify geographic clusters of contamination
- Develop infrastructure improvement priorities
- Create intervention plans for contaminated wells

## Impact

This analysis directly supports decision-making to:
- Improve water access for millions of people
- Address public health risks from contaminated sources
- Optimize resource allocation for infrastructure repairs
- Reduce extreme wait times at shared taps

---

**Database:** MySQL  
**Dataset Size:** 60,000+ records  
**Analysis Type:** Water infrastructure and quality assessment  
**Status:** Initial analysis complete, data corrections applied
