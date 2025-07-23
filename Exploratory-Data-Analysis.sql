-- https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv
-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2
;

-- adding company workforce column to show total employees in the company after the lay off --
SELECT total_laid_off, percentage_laid_off, total_laid_off/percentage_laid_off as 'company_workforce'
FROM layoffs_staging2
;

ALTER TABLE layoffs_staging2
ADD company_workforce INT
;

UPDATE layoffs_staging2
SET company_workforce = (total_laid_off/NULLIF(percentage_laid_off,0)) * (1-percentage_laid_off)
;


-- --General exercises--

# basic exercises
SELECT * 
FROM layoffs_staging2
ORDER BY company
;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2
;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2
;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;

# order by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;

# order by total laid off
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC
;

# average percentage laid off by stage
SELECT stage, avg(percentage_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC
;

# rolling sum of layoffs
SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) is not null -- cannot use the alias
GROUP BY `month`
ORDER BY 1 asc
;

WITH rolling_total as(
SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) is not null -- cannot use the alias
GROUP BY `month`
ORDER BY 1 asc
)
SELECT `month`,  total_off,
 SUM(total_off) OVER(order by `month`) as rolling_total
FROM rolling_total
;

# checking the companies to see how many they were laying off per year
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;

SELECT company, SUM(total_laid_off), YEAR(`date`)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 2 DESC
;

WITH company_year (company, years, total_laid_off) as (
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
company_year_rank as (
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off desc) as ranking
FROM company_year
WHERE years is not null
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5
;




