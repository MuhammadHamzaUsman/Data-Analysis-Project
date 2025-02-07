WITH skill_demand AS(
    SELECT
        skills_dim.skill_id AS skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.skill_id) as counts
    FROM skills_job_dim
    INNER JOIN job_postings_fact
        ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
), skill_salaries AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) as average_salary
    FROM skills_job_dim
    INNER JOIN job_postings_fact
        ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skill_demand.*,
    skill_salaries.average_salary
From
    skill_demand
INNER JOIN skill_salaries
    ON skill_demand.skill_id  = skill_salaries.skill_id
WHERE
    counts > 10
ORDER BY
    counts DESC,
    average_salary DESC
LIMIT 30;

SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_dim.skill_id) AS counts,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_dim.skill_id) > 10
ORDER BY
    counts DESC,
    average_salary DESC
LIMIT 30;