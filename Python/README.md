# **Data Job Market Analysis**  

This repository provides insights into data-related job roles, skill demand, trends, salary analysis, and optimal skills using Python.  

---

## **1. Exploratory Data Analysis (EDA)**  

### **First Question Asked:**  
*What are the top-paying roles in the Data Science industry?*  

### **Skills Used:**  
- Data Cleaning & Transformation  
- Data Visualization  

### **Methodology:**  
- Load and clean the dataset  
- Filter jobs by country and role  
- Identify high-paying roles  

### **Code Snippets:**  

#### **Load dataset and clean salary data**  
```python
import pandas as pd
import matplotlib.pyplot as plt

# Load dataset
df = pd.read_csv("data_jobs.csv")

# Convert job_posted_date to datetime
df["job_posted_date"] = pd.to_datetime(df["job_posted_date"])

# Drop rows with missing salary values
df = df.dropna(subset=["salary_year_avg"])
```

#### **Find and visualize top-paying roles**  
```python
top_roles = df.groupby("job_title_short")["salary_year_avg"].median().sort_values(ascending=False)

# Plot top roles
top_roles.plot(kind="bar", figsize=(10,5), title="Median Salary by Role")
plt.ylabel("Median Salary ($)")
plt.show()
```

### **Results:**  
- **Top-paying roles:** Senior Data Scientist, Data Engineer, and AI Engineer.  
- **Salary differences:** Senior roles pay significantly higher than entry-level ones.  
- **Location impact:** US-based roles generally pay more.  

---

## **2. Skill Demand Analysis**  

### **First Question Asked:**  
*What are the most in-demand skills for different data-related roles?*  

### **Skills Used:**  
- Data Aggregation  
- Skill Frequency Calculation  

### **Methodology:**  
- Extract skill data from job postings  
- Count skill occurrences by role  
- Calculate skill demand percentage  

### **Code Snippets:**  

#### **Extract and count skill occurrences**  
```python
from ast import literal_eval

# Convert job_skills from string to list
df["job_skills"] = df["job_skills"].apply(lambda x: literal_eval(x) if pd.notna(x) else x)

# Explode job_skills to count occurrences
df_exploded = df.explode("job_skills")
df_skill_count = df_exploded.groupby("job_skills").size().reset_index(name="count")
```

#### **Find top skills for Data Analysts**  
```python
df_skill_count["percentage"] = (df_skill_count["count"] / df_skill_count["count"].sum()) * 100
df_skill_count.sort_values(by="count", ascending=False).head(10)
```

### **Results:**  
- **Top skills overall:** Python, SQL, Tableau, AWS, and Power BI.  
- **By role:**  
  - Data Scientists: Python, ML, TensorFlow.  
  - Data Engineers: SQL, Spark, Cloud Services.  
  - Data Analysts: Excel, SQL, Power BI.  

---

## **3. Skill Trend Analysis**  

### **First Question Asked:**  
*How are the top 7 skills trending over time?*  

### **Skills Used:**  
- Time-Series Analysis  
- Skill Trend Visualization  

### **Methodology:**  
- Aggregate skill counts monthly  
- Normalize data by job postings  
- Visualize trends over time  

### **Code Snippets:**  

#### **Prepare data for time-series analysis**  
```python
df["job_posted_month"] = df["job_posted_date"].dt.to_period("M")
df_exploded = df.explode("job_skills")
df_monthly_counts = df_exploded.groupby(["job_posted_month", "job_skills"]).size().unstack(fill_value=0)
```

#### **Find and plot top 7 trending skills**  
```python
top_skills = df_monthly_counts.sum().sort_values(ascending=False).head(7).index
df_monthly_counts[top_skills].plot(figsize=(12,6), title="Top 7 Skill Trends Over Time")
plt.show()
```

### **Results:**  
- **Consistently in demand:** Python, SQL, and cloud computing.  
- **Growing skills:** AI/ML, Spark, and Kubernetes.  
- **Declining:** SAS and older BI tools.  

---

## **4. Salary Analysis**  

### **First Question Asked:**  
*How do salaries vary across data-related roles and skills?*  

### **Skills Used:**  
- Median Salary Calculation  
- Salary Comparison  

### **Methodology:**  
- Extract salary data  
- Compute median salaries for roles and skills  
- Compare salary trends  

### **Code Snippets:**  

#### **Calculate median salary for roles**  
```python
roles_interest = ["Data Analyst", "Data Engineer", "Data Scientist",
                  "Senior Data Analyst", "Senior Data Engineer", "Senior Data Scientist"]

df_jobs = df[df["job_title_short"].isin(roles_interest)]
df_median_salary = df_jobs.groupby("job_title_short")["salary_year_avg"].median().sort_values(ascending=False)

print(df_median_salary)
```

#### **Find top-paying skills**  
```python
df_exploded = df_jobs.explode("job_skills")
df_skill_salary = df_exploded.groupby("job_skills")["salary_year_avg"].median().sort_values(ascending=False).head(10)
print(df_skill_salary)
```

### **Results:**  
- **Highest paying skills:** Machine Learning, Deep Learning, Cloud Technologies (AWS, Azure).  
- **Median salaries:**  
  - Senior Data Scientists: **$130,000 - $150,000**  
  - Data Engineers: **$100,000 - $120,000**  
  - Data Analysts: **$70,000 - $90,000**  

---

## **5. Optimal Skills Analysis**  

### **First Question Asked:**  
*What are the most optimal skills in terms of salary and job availability?*  

### **Skills Used:**  
- Data Grouping & Aggregation  
- Optimal Skill Visualization  

### **Methodology:**  
- Group skills by median salary and job posting likelihood  
- Classify skills into categories  
- Visualize optimal skills  

### **Code Snippets:**  

#### **Group skills by median salary and percentage occurrence**  
```python
df_explode = df.explode("job_skills")
df_skills = df_explode.groupby("job_skills").agg(
    count=("job_skills", "size"),
    median_salary=("salary_year_avg", "median")
)
df_skills["percent"] = (df_skills["count"] / len(df)) * 100
df_skills.sort_values(by="percent", ascending=False).head(12)
```

#### **Visualize most optimal skills**  
```python
import seaborn as sns
from adjustText import adjust_text

plt.figure(figsize=(12,6))
sns.scatterplot(data=df_skills, x="percent", y="median_salary", s=100)

# Add text labels
texts = [plt.text(row["percent"], row["median_salary"], row.name, fontsize=9) for _, row in df_skills.iterrows()]
adjust_text(texts)

plt.xlabel("Percentage of Job Postings (%)")
plt.ylabel("Median Salary ($)")
plt.title("Most Optimal Skills: Demand vs. Salary")
plt.grid(True)
plt.show()
```

### **Results:**  
- **Most in-demand skills:** SQL, Excel, and Python appeared in the highest job postings.  
- **Highest-paying skills:** Cloud platforms (AWS, GCP), Machine Learning, and Big Data tools had the highest salaries.  
- **Optimal skills (High demand & high salary):** SQL, Python, and AWS.  

---

## **Conclusion**  

- **High-demand skills:** Python, SQL, and cloud computing.  
- **Senior roles** earn significantly more than junior roles.  
- **Emerging technologies** like AI/ML and cloud platforms drive salary growth.  

This analysis provides **data-driven insights** to help job seekers and employers make informed decisions.  
