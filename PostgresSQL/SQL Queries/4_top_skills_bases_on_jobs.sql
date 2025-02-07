SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) as average_salary
FROM skills_job_dim
INNER JOIN job_postings_fact
    ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
ORDER BY
    average_salary DESC
Limit 25