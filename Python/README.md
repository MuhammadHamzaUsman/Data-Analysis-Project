# **Data Job Market Analysis**  

This repository provides insights into data-related job roles, skill demand, trends, salary analysis, and optimal skills using Python. Most of analysis in performed for U.S because of data available.  

---

## **1. Exploratory Data Analysis (EDA)**  

### **First Question Asked:**  
*What are the top-locations and platforms in the Data Science industry in U.S?*  

### **Skills Used:**  
- Data Cleaning & Transformation  
- Data Visualization  

### **Methodology:**  
- Load and clean the dataset  
- Filter jobs by country and role  
- Identify Top location and platforms  

### **Code Snippets:**  

#### **Load dataset and clean salary data**  
```python
# importing relevant libraries
import pandas as pd
import matplotlib.pyplot as plt
from ast import literal_eval
import seaborn as sns

# loading data set
df = pd.read_csv("C:\\Users\\Dell\\Documents\\VSCODE\\Python\\Data Analysis\\Data\\data_jobs.csv")

# data cleaning
df.job_posted_date = pd.to_datetime(df.job_posted_date)
df['job_skills'] = df['job_skills'].apply(lambda x : literal_eval(x) if pd.notna(x) else x)
```

#### **Find and visualize top-locations**  
```python
# Extracting counts of location
df_vis = df_filtered["job_location"].value_counts().head(10).to_frame()

# Visualizing
sns.barplot(
    data = df_vis,
    x = df_vis.index,
    y = df_vis["count"],
    hue = df_vis["count"],
    palette = "dark:seagreen_r",
    legend = False
)
plt.xlabel("")
plt.xticks(rotation = 45, horizontalalignment = "right")
plt.ylabel("Job Counts")
plt.title("Top 10 Job Locations")
plt.show()
```
![Top Locations](https://github.com/user-attachments/assets/a9d42242-a3b2-4492-b56f-f46866793468)



### **Results:**  
- **Top-Locations :** Remote jobs are on rise.  
- **Salary differences:** LinkedIn maintains a lead in job finding. 
- **Degree Requirment:** 28% of recuiters dont have degree requirment.  

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
#skill count and job count
df_exploded = df_filtered[["job_title_short", "job_skills"]].explode("job_skills")
df_skill_count = df_exploded.groupby(["job_title_short", "job_skills"]).agg("size").to_frame()
df_skill_count = df_skill_count.rename(columns = {0 : "counts"})
df_skill_count["counts"] = df_skill_count["counts"].apply(lambda x :  x * 1.0)
df_job_counts = df_filtered.groupby("job_title_short").agg("size")
```

#### **Visualizing top skills for Data Jobs**  
```python
investigate_roles = ["Data Analyst", "Data Engineer", "Data Scientist", "Software Engineer"]
fig, ax = plt.subplots(len(investigate_roles), 1)

for i,role in enumerate(investigate_roles) :
    sns.barplot(
        data = df_skill_percent[df_skill_percent["job_title_short"] == role].head(),
        x = "percent",
        y = "job_skills",
        orient = "h",
        hue = "percent",
        palette = "dark:seagreen_r",
        legend = False,
        ax = ax[i]
    )
    ax[i].set_title(role)
    ax[i].set_ylabel("")
    ax[i].set_xlabel("")
    ax[i].set_xlim(0, 100)

    if i < len(investigate_roles)  - 1 :
        ax[i].set_xticks([])

    ax[i].xaxis.set_major_formatter(plt.FuncFormatter(lambda value, pos : f"{value}%"))
    
    for number, value in enumerate(df_skill_percent[df_skill_percent["job_title_short"] == role].head()["percent"]) :
        ax[i].text(value, number, f"{round(value, 0)}%", va = "center")

fig.set_size_inches(7.5, 9.5)
fig.suptitle("Chances of Skill Appearing in Job Posting")
plt.tight_layout()
plt.show()
```
![Top Skills](https://github.com/user-attachments/assets/5d4c4de1-7a81-4608-adb7-99102e0070b9)


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
# calaculating monthly counts for each skills
df_exploded = df_short.explode("job_skills")
df_monthly_counts = df_exploded.pivot_table(
                    index = "job_posted_month",
                    columns = "job_skills",
                    aggfunc = "size",
                    fill_value = 0
                )
```

#### **Find and plot top 7 trending skills**  
```python
#plotting percent dataframe
fig, ax = plt.subplots(1)
sns.lineplot(
    data = df_monthly_percent,
    dashes = False,
    palette = "rocket",
    ax = ax
)

#formatting
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda y, pos: f"{int(y)}%"))
ax.set_xlabel("2023")
ax.set_ylabel("Chance of Apperance")
fig.suptitle("Chances of Job Appearing over Year")
fig.set_size_inches(10, 5)
plt.legend(bbox_to_anchor = (1.05, 1.0), loc = "upper left")
plt.tight_layout()
plt.show()
```

![Skills Trend Over 2023](https://github.com/user-attachments/assets/64b2e35f-ace3-43ba-88ce-95668b0d0c12)


### **Results:**  
- **Consistently in demand:** Python, SQL, and cloud computing.  
- **Growing skills:** AI/ML, Spark, and Kubernetes.  
- **Less Demand:** SAS and older BI tools.  

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

#Extracting only roles of interest
df_jobs = df[(df["job_title_short"].isin(roles_interest)) & (df["job_country"] == country)][["job_title_short", "salary_year_avg"]].dropna(subset = "salary_year_avg")

#Calculating median salary
df_median_salary = df_jobs.groupby("job_title_short")["salary_year_avg"].median().sort_values(ascending = False)

print(df_median_salary)
```
![Pay Ranges](https://github.com/user-attachments/assets/2d94e855-5bd0-43c3-87fb-4832641225ae)


#### **Find top-paying skills**  
```python
#Extracting median saalry and count of all skills
df_DA = df[(df["job_title_short"] == role) & (df["job_country"] == country)][["job_skills", "salary_year_avg"]].dropna(subset = ["salary_year_avg"])
df_explode = df_DA.explode("job_skills")
df_skills = df_explode.groupby("job_skills").agg(
    count = ("job_skills", "size"),
    median = ("salary_year_avg", "median")
)
```
![Skills Pay](https://github.com/user-attachments/assets/47cf940c-bbff-4127-90ad-6bfa0bbf67c5)


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
#filtering data
df_filtered = df[(df["job_title_short"] == role) & (df["job_country"] == country)][["job_skills", "salary_year_avg", "job_type_skills"]].copy()
df_filtered = df_filtered.dropna(subset = ["salary_year_avg", "job_skills"])

#Grouping by skills to calculate median and chance
df_explode = df_filtered.explode("job_skills")
total_skills = len(df_filtered)
df_skills = df_explode.groupby("job_skills").agg(
    count = ("job_skills", "size"),
    median = ("salary_year_avg", "median")
)
df_skills["percent"] = (df_skills["count"] / total_skills) * 100

#Extracting top skills
df_skills = df_skills.sort_values(by = "percent", ascending = False).head(top)
```

#### **Visualize most optimal skills**  
```python
#plotting
sns.scatterplot(
    data = df_skills,
    x = "percent",
    y = "median",
    hue = "technology"
)

#plotting texts
texts = []
for skill in df_skills.index :
    texts.append(plt.text(x = df_skills.loc[skill, "percent"], y = df_skills.loc[skill, "median"], s = skill))
adjust_text(texts, arrowprops = dict(arrowstyle = "->", color = "gray", lw = 1))

#formatting
plt.legend().set_title("Technology")
ax = plt.gca()
ax.yaxis.set_major_formatter(plt.FuncFormatter(lambda y, pos: f"${int(y/1000)}K"))
ax.xaxis.set_major_formatter(plt.FuncFormatter(lambda x, pos: f"{int(x)}%"))
plt.xlabel("Chance of Appearing in Job Postings")
plt.ylabel("Median Salary($USD)")
plt.title("Most Optimal Skill for Data Analyst in U.S.A")
plt.tight_layout()
plt.show()
```
![Skills vs Pay](https://github.com/user-attachments/assets/12fda83f-ccbe-4dec-b56e-1af97a2b0bd1)


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
