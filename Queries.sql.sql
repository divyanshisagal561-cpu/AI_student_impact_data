-- This query shows all student records
SELECT *
FROM ai_impact;
-- This query shows only stu_id, category, and ai_hours
SELECT stu_id, category, ai_hours
FROM ai_impact;
-- This query shows all students from the STEM category
SELECT *
FROM ai_impact
WHERE category = "STEM" ;
-- This query shows students whose prompt_skill is 'Advanced'
SELECT *
FROM ai_impact 
WHERE prompt_skill = "Advanced" ;
-- This query shows students with dependence greater than 5
SELECT *
FROM ai_impact
WHERE dependence > 5 ;
-- This query shows students who use AI for Debugging/Troubleshooting
SELECT *
FROM ai_impact
WHERE ai_use = "Debugging/Troubleshooting" ;
-- This query shows students studying in their Senior year
SELECT *
FROM ai_impact
WHERE year_of_study = "Senior" ; 
-- This query shows students whose ai_hours exceed 15
SELECT *
FROM ai_impact
WHERE ai_hours < 15 ; 
-- This query shows all unique AI use cases
SELECT DISTINCT ai_use 
FROM ai_impact ;
-- This query shows count the total number of students 
SELECT COUNT(*) AS total_students
FROM ai_impact ;
-- This query shows average AI hours 
SELECT AVG(ai_hours) AS avg_ai_hours
FROM ai_impact ; 
-- This query shows maximum AI Dependence score
SELECT MAX(dependence) AS max_ai_dependence
FROM ai_impact ; 
-- This query shows minimum Tool Diversity score
SELECT MIN(tool_diversity) AS min_tool_diversity
FROM ai_impact ;
-- This query shows total AI hours of all students
SELECT SUM(ai_hours) AS total_ai_hours
FROM ai_impact ;  
-- This query shows average AI dependence
SELECT AVG(dependence) AS avg_ai_dependence
FROM ai_impact ; 
-- This query count students in each Category 
SELECT COUNT(*) AS total_students, category
FROM ai_impact 
GROUP BY category ; 
-- This query shows average AI hours by Category
SELECT AVG(ai_hours) AS avg_ai_hours, category
FROM ai_impact 
GROUP BY category ; 
-- This query shows average AI dependence by Year of Study 
SELECT AVG(dependence) AS avg_ai_dependence, year_of_study
FROM ai_impact 
GROUP BY year_of_study ; 
-- This query shows count students for each prompt skill level
SELECT COUNT(*) AS total_students, prompt_skill
FROM ai_impact 
GROUP BY prompt_skill ; 
-- This query shows average tool diversity by category
SELECT AVG(tool_diversity) AS avg_ai_tools_diversity, category
FROM ai_impact 
GROUP BY category ;  
-- This query shows average AI hours for each AI Use type
SELECT AVG(ai_hours) AS avg_ai_hours, ai_use
FROM ai_impact 
GROUP BY ai_use ;  
-- This query count students in each year of study
SELECT COUNT(*) AS total_students, year_of_study
FROM ai_impact 
GROUP BY year_of_study ; 
-- This query shows categories with average AI hours greater than 10 
SELECT category, AVG(ai_hours) AS avg_ai_hours
FROM ai_impact
GROUP BY category
HAVING avg_ai_hours > 10 ; 
-- This query shows AI Use types used by more than 50 students 
SELECT COUNT(*) AS total, ai_use 
FROM ai_impact
GROUP BY ai_use
HAVING total > 50 ;
-- This query shows categories whose average AI Dependence exceeds 2
SELECT category, AVG(dependence) AS avg_depen
FROM ai_impact
GROUP BY category
HAVING avg_depen > 2 ;
-- This query shows prompt skill groups having average Tool Diversity above 3  
SELECT prompt_skill, AVG(tool_diversity) AS avg_td
FROM ai_impact
GROUP BY prompt_skill
HAVING avg_td > 3 ;
-- This query categorize students as:
-- Low AI User (<5 hours)
-- Medium AI User (5–15 hours)
-- High AI User (>15 hours)
SELECT ai_use, ai_hours,
CASE
	WHEN ai_hours < 5 THEN "Low AI user"
	WHEN ai_hours BETWEEN 5 AND 15 THEN "Medium AI user"
	ELSE "High AI user"
END AS category
FROM ai_impact ; 
-- This query classify AI Dependence as:
-- Low (1–3)
-- Medium (4–6)
-- High (7–10)
SELECT dependence,
CASE
    WHEN dependence BETWEEN 1 AND 3 THEN "Low"
    WHEN dependence BETWEEN 4 AND 6 THEN "Medium"
	ELSE "High"
END AS classify
FROM ai_impact ;    
-- This query create a column indicating whether a student is AI Dependent (Dependence > 6) 
SELECT dependence,
CASE
    WHEN dependence > 6 THEN "YES"
    ELSE "NO"
END AS AI_DEPENDENT
FROM ai_impact ;
-- This query shows students whose AI hours are above the overall average 
SELECT *
FROM ai_impact
WHERE ai_hours > (SELECT AVG(ai_hours) FROM ai_impact) ;
-- This query shows students with the highest AI dependence score 
SELECT *
FROM ai_impact
WHERE dependence = (SELECT MAX(dependence) FROM ai_impact) ; 
-- This query shows categories whose average AI hours exceed the overall average AI hours 
SELECT category
FROM ai_impact
GROUP BY category
HAVING AVG(ai_hours) > (SELECT AVG(ai_hours) FROM ai_impact) ;
-- Using a CTE, find students with above-average AI dependence 
WITH avg_dependence AS (
          SELECT AVG(dependence) AS avg_depen
          FROM ai_impact)

SELECT *
FROM ai_impact, avg_dependence
WHERE dependence > avg_depen ;           
-- Using a CTE, calculate average AI hours by category and find the highest one 
WITH avg_hours AS(
               SELECT AVG(ai_hours) AS avg_ai_hours, category
               FROM ai_impact
               GROUP BY category)

SELECT *
FROM avg_hours
ORDER BY avg_ai_hours DESC
LIMIT 1 ;
-- This query shows ranking of students by AI hours
SELECT stu_id, ai_hours,
DENSE_RANK() OVER(ORDER BY ai_hours DESC) AS dr
FROM ai_impact ;
-- This query shows top 3 students in each category based on AI hours             
WITH ranking AS(
	       SELECT *,
           ROW_NUMBER() OVER(PARTITION BY category ORDER BY ai_hours DESC) AS rn
           FROM ai_impact)
           
SELECT *
FROM ranking
WHERE rn <= 3;               
-- This query shows total running of AI hours            
SELECT ai_hours, stu_id, 
SUM(ai_hours) OVER(ORDER BY stu_id) AS total_running
FROM ai_impact ;            
-- Which category has the highest average AI dependence? 
WITH cte AS (
          SELECT AVG(dependence) AS avg_depen, category
          FROM ai_impact
          GROUP BY category )        
            
SELECT *
FROM cte 
ORDER BY avg_depen DESC
LIMIT 1;
-- Does Prompt Skill affect AI hours? 
SELECT AVG(ai_hours) AS avg_ai_hours, prompt_skill
FROM ai_impact
GROUP BY prompt_skill;           
-- Which AI Use type is associated with the highest AI dependence?													            
SELECT ai_use, AVG(dependence) AS avg_depen
FROM ai_impact
GROUP BY ai_use 
ORDER BY avg_depen DESC ;
-- Are Advanced users more dependent on AI than Beginners? 
-- (Advanced Users VS Beginner Users)
SELECT AVG(dependence) AS avg_depend, prompt_skill
FROM ai_impact
GROUP BY prompt_skill         
HAVING prompt_skill IN ( "Beginner" , "Advanced" );          
-- Which Year of Study uses AI the most?            
SELECT year_of_study, AVG(ai_hours) AS avg_hours
FROM ai_impact
GROUP BY year_of_study 
ORDER BY avg_hours DESC 
LIMIT 1;           
-- Is there a relationship between Tool Diversity and AI Dependence?            
SELECT AVG(dependence) AS avg_depen, tool_diversity
FROM ai_impact
GROUP BY tool_diversity ;
-- Find students with high AI Dependence (>7) but low Tool Diversity (<3)           
SELECT *
FROM ai_impact
WHERE dependence > 7 AND tool_diversity < 3 ;
-- Compare STEM and Humanities students on AI usage
SELECT category , AVG(ai_hours), AVG(dependence)
FROM ai_impact
GROUP BY category 
HAVING category IN ("STEM","Humanities"); 	
-- Which Category contains the highest proportion of Advanced Prompt Skill users?
SELECT category, COUNT(*) AS count_
FROM ai_impact
WHERE prompt_skill = "Advanced"
GROUP BY category
ORDER BY count_ DESC ;
-- Identify the most AI-dependent Category
SELECT category, COUNT(*) AS count_depen
FROM ai_impact
GROUP BY category 
ORDER BY count_depen DESC 
LIMIT 1; 