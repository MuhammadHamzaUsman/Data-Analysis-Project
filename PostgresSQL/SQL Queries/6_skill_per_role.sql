SELECT
    skills,
    COUNT(skill_id) AS skill_total,
    COUNT(job_postings_fact.job_id) AS job_total,
    skill_total \ job_total AS skillperjob
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.skill_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills