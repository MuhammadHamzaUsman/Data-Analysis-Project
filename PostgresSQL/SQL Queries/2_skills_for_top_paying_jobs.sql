SELECT 
    top_10_jobs.*,
    skills_dim.skills AS name
FROM (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        company_dim.name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
) AS top_10_jobs
INNER JOIN skills_job_dim
    ON top_10_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    On skills_job_dim.skill_id = skills_dim.skill_id;

WITH top_ten_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        company_dim.name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_ten_jobs.*,
    skills_dim.skills AS name
From 
    skills_job_dim
INNER JOIN top_ten_jobs
    ON skills_job_dim.job_id = top_ten_jobs.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id