-- https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv
-- Data Cleaning

SELECT *
FROM layoffs
;

-- 1. Remove duplicates
-- 2. Standardize data
-- 3. Null values or blank values
-- 4. Remove unnecessary rows and columns

CREATE TABLE layoffs_staging
LIKE layoffs
;

SELECT *
FROM layoffs_staging
;

INSERT layoffs_staging
SELECT *
FROM layoffs
;



-- 1. Remove duplicates
SELECT *
FROM layoffs_staging
;

SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
ORDER BY row_num DESC
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1
;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper'
;

-- Creating a staging 2 database to delete the duplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
;

-- Identifying the duplicates
SELECT *
FROM layoffs_staging2
WHERE row_num > 1
;

-- Deletion of said duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1
;



-- 2. Standardize data --
-- Removing white space from company names
SELECT company, TRIM(company)
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET company = TRIM(company)
;

-- Matching all industry names
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1
;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'
;

-- Changing all crypto companies to "crypto" as the industry
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
;

-- location cleaning
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1
;

SELECT DISTINCT country
FROM layoffs_staging2
WHERE country LIKE 'United States%'
;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1
;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'
;

-- Changing date to date column
SELECT `date`, str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y')
;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE
;

SELECT *
FROM layoffs_staging2
;



-- 3. Null values or blank values --
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS null
AND percentage_laid_off IS null
;

SELECT *
FROM layoffs_staging2
WHERE industry IS null OR industry = ''
;

-- Populating null industry using a self join
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'
;

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company AND t1.location = t2.location
WHERE (t1.industry is null OR t1.industry = '') AND t2.industry is not null
;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''
;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry is null AND t2.industry is not null
;



-- 4. Remove unnecessary rows and columns
-- Companies with no total laid off or percent laid off information
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is null AND percentage_laid_off is null
;

DELETE
FROM layoffs_staging2
WHERE total_laid_off is null AND percentage_laid_off is null
;

-- Getting rid of the row_num column
SELECT *
FROM layoffs_staging2
;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num
;