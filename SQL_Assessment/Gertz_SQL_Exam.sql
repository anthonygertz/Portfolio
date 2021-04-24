--I chose to use as little aliasing as possible for the exam. I felt given the time crunch that this would help prevent unseen errors
--as I made code changes throughout problems. 

--QUESTION #1
SELECT grade_id, grade.name AS grade, COUNT(author.name)
FROM author
JOIN grade
ON author.grade_id = grade.id
GROUP BY grade_id, grade.name
ORDER BY grade;

--ANSWER #1A - See code above
--Michael said I get 5 bonus points

SELECT grade_id, grade.name AS grade, COUNT(author.name), gender.name
FROM author
JOIN grade
ON author.grade_id = grade.id
JOIN gender
ON author.gender_id = gender.id
WHERE gender.name = 'Male' OR gender.name = 'Female'
GROUP BY grade_id, grade.name, gender.name
ORDER BY grade;

--ANSWER #1B -- See code above

/*ANSWER #1C -- Given the queries above, it looks like participation in the Poki project increases as grade level increases
and begins to taper off between 4th and 5th grade. It might mean that children are more likely to write poetry as grade level
increases, but I would be hesitant to make this statement without further investigation. Children at the 1st and 2nd grade 
level mihgt not have the vocabulary or level of language composition to be capable of writing poetry. Further, 
this increase could be strictly due to which grade levels begin teaching and assigning homework that relates to poetry. 
Reading the project description website tells us that these are submission based too, further confounding any conclusions we
might begin to draw */

--QUESTION #2

SELECT COUNT(id) AS poem_count, ROUND(AVG(char_count), 4) AS avg_char_count, 
	CASE WHEN text LIKE '%death%' THEN 'death'
	WHEN text LIKE '%love%' THEN 'love'
	ELSE '' END AS theme 
FROM poem
WHERE text LIKE '%death%' OR text LIKE '%love%'
GROUP BY theme;

--ANSWER #2 - See code above
--Test code below to see if the total count matches when just using a WHERE clause. What's odd about this is that they match.
--One would think that my query above does not account for poems where both love and death are mentioned, but somehow the 
--code knows??? Switching to an AND argument shows that indeed 19 poems include both terms. Queries for the individual terms
--show 4550 results total which would inlcude the double counting (4550-19 = 4531). 
SELECT COUNT(id)
FROM poem
WHERE text LIKE '%death%' OR text LIKE '%love%'

SELECT COUNT(id)
FROM poem
WHERE text LIKE '%death%' AND text LIKE '%love%'

SELECT COUNT(id)
FROM poem
WHERE text LIKE '%love%'

SELECT COUNT(id)
FROM poem
WHERE text LIKE '%death%'

--QUESTION #3
--Exploratation, verification, and joins
SELECT poem.id, char_count, intensity_percent, emotion_id, emotion.name
FROM poem
JOIN poem_emotion
ON poem.id = poem_emotion.poem_id
JOIN emotion
ON poem_emotion.emotion_id = emotion.id
ORDER BY poem.id

--QUESTION #3A

SELECT emotion.name AS emotion, 
	ROUND(AVG(char_count),4) AS avg_char_count, 
	ROUND(AVG(intensity_percent),4) AS avg_perc_intensity
FROM poem
JOIN poem_emotion
ON poem.id = poem_emotion.poem_id
JOIN emotion
ON poem_emotion.emotion_id = emotion.id
GROUP BY emotion.name
ORDER BY avg_char_count;

--ANSWER #3A - See code above. Shortest is Joy, longest is Anger

--QUESTION #3B

WITH dominant_emotion AS (
	SELECT emotion.name AS emotion, 
		ROUND(AVG(char_count),4) AS avg_char_count, 
		ROUND(AVG(intensity_percent),4) AS avg_perc_intensity
	FROM poem
	JOIN poem_emotion
	ON poem.id = poem_emotion.poem_id
	JOIN emotion
	ON poem_emotion.emotion_id = emotion.id
	GROUP BY emotion.name
	ORDER BY avg_char_count)
SELECT emotion.name AS emotion, 
	poem_emotion.intensity_percent, 
	poem.char_count,
	dominant_emotion.avg_char_count, 
	CASE WHEN poem.char_count >= dominant_emotion.avg_char_count THEN 'longer or equal'
		 ELSE 'shorter' END AS comp_to_avg_char,
	poem.text
FROM poem
JOIN poem_emotion
ON poem.id = poem_emotion.poem_id
JOIN emotion
ON poem_emotion.emotion_id = emotion.id
JOIN dominant_emotion
ON emotion.name = dominant_emotion.emotion
WHERE emotion.name = 'Joy'
ORDER BY poem_emotion.intensity_percent DESC
LIMIT 5
	
--ANSWER #3B - See code above. AWWWW CUTE, IT IS ABOUT A DOG(DOGE)!
--Mostly, but no, the classification is simple and not perfect. Number 5 in the list is about the lack of happiness

--QUESTION #4
WITH ultra_mega_join AS (
	SELECT poem.title, 
		   grade.name AS grade, 
	       gender.name AS gender, 
	       poem_emotion.intensity_percent AS intensity_perc, 
	       emotion.name AS emotion, 
	       poem.text
	FROM poem
	JOIN author
	ON poem.author_id = author.id
		JOIN grade
		ON author.grade_id = grade.id
			JOIN gender
			ON author.gender_id = gender.id
				JOIN poem_emotion
				ON poem.id = poem_emotion.poem_id
					JOIN emotion
					ON poem_emotion.emotion_id = emotion.id
	),

top5_anger_grade1 AS (
	SELECT grade, AVG(intensity_perc) AS top5_anger_grade1, gender
	FROM ultra_mega_join
	WHERE emotion = 'Anger' AND grade = '1st Grade'
	GROUP BY grade
	ORDER BY AVG(intensity_perc) DESC
	LIMIT 5	
	)

SELECT grade, ROUND(AVG(intensity_perc),4) AS top5_anger_grade5, gender
FROM ultra_mega_join
WHERE emotion = 'Anger' AND grade = '5th Grade'
GROUP BY grade
ORDER BY AVG(intensity_perc) DESC
LIMIT 5; 

--ANSWER #4A - 5th grade's top 5 angriest poems are on average angrier than the 1st grades equivalent at 44.17 > 38.86
--It occurs to me I should have done this via RANK and PARTITION, oh well, see below: 

--QUESTION #4B 

--Code testing: 
WITH ultra_mega_join AS (
	SELECT poem.title, 
		   grade.name AS grade, 
	       gender.name AS gender, 
	       poem_emotion.intensity_percent AS intensity_perc, 
	       emotion.name AS emotion, 
	       poem.text
	FROM poem
	JOIN author
	ON poem.author_id = author.id
		JOIN grade
		ON author.grade_id = grade.id
			JOIN gender
			ON author.gender_id = gender.id
				JOIN poem_emotion
				ON poem.id = poem_emotion.poem_id
					JOIN emotion
					ON poem_emotion.emotion_id = emotion.id
	)

SELECT grade, gender, intensity_perc,
	RANK() OVER(PARTITION BY grade ORDER BY intensity_perc DESC) AS intensity_rank
FROM ultra_mega_join
WHERE emotion = 'Anger' AND (grade = '1st Grade' OR grade = '5th Grade')
ORDER BY intensity_rank

--Working code below (Also contains the proper way to answer #4A): 

WITH ultra_mega_join AS (
	SELECT poem.title, 
		   grade.name AS grade, 
	       gender.name AS gender, 
	       poem_emotion.intensity_percent AS intensity_perc, 
	       emotion.name AS emotion, 
	       poem.text
	FROM poem
	JOIN author
	ON poem.author_id = author.id
		JOIN grade
		ON author.grade_id = grade.id
			JOIN gender
			ON author.gender_id = gender.id
				JOIN poem_emotion
				ON poem.id = poem_emotion.poem_id
					JOIN emotion
					ON poem_emotion.emotion_id = emotion.id
	),

ranks AS (
	SELECT grade, gender, intensity_perc,
	RANK() OVER(PARTITION BY grade ORDER BY intensity_perc DESC) AS intensity_rank
	FROM ultra_mega_join
	WHERE emotion = 'Anger' AND (grade = '1st Grade' OR grade = '5th Grade')
	),
	
grade1_top5 AS (
	SELECT grade, gender, intensity_perc, intensity_rank
	FROM ranks
	WHERE grade = '1st Grade'
	ORDER BY intensity_rank
	LIMIT 5
	),

grade5_top5 AS (
	SELECT grade, gender, intensity_perc, intensity_rank
	FROM ranks
	WHERE grade = '5th Grade'
	ORDER BY intensity_rank
	LIMIT 5
	)

SELECT grade, gender, intensity_perc, intensity_rank
FROM grade5_top5
UNION ALL
SELECT grade, gender, intensity_perc, intensity_rank
FROM grade1_top5
--OK, the code above brings us to the point of the correct code to assess #4A
--Now below is the same code with a few modifications to answer #4B

WITH ultra_mega_join AS (
	SELECT poem.title, 
		   grade.name AS grade, 
	       gender.name AS gender, 
	       poem_emotion.intensity_percent AS intensity_perc, 
	       emotion.name AS emotion, 
	       poem.text
	FROM poem
	JOIN author
	ON poem.author_id = author.id
		JOIN grade
		ON author.grade_id = grade.id
			JOIN gender
			ON author.gender_id = gender.id
				JOIN poem_emotion
				ON poem.id = poem_emotion.poem_id
					JOIN emotion
					ON poem_emotion.emotion_id = emotion.id
	),

ranks AS (
	SELECT grade, gender, intensity_perc,
	RANK() OVER(PARTITION BY grade ORDER BY intensity_perc DESC) AS intensity_rank
	FROM ultra_mega_join
	WHERE emotion = 'Anger' AND (grade = '1st Grade' OR grade = '5th Grade')
	),
	
grade1_top5 AS (
	SELECT grade, gender, intensity_perc, intensity_rank
	FROM ranks
	WHERE grade = '1st Grade'
	ORDER BY intensity_rank
	LIMIT 5
	),

grade5_top5 AS (
	SELECT grade, gender, intensity_perc, intensity_rank
	FROM ranks
	WHERE grade = '5th Grade'
	ORDER BY intensity_rank
	LIMIT 5
	),

all_together_now AS (
	SELECT gender, grade, intensity_perc 
	FROM grade5_top5
	UNION ALL
	SELECT gender, grade, intensity_perc
	FROM grade1_top5
	)

SELECT grade, gender, COUNT(intensity_perc)
FROM all_together_now
GROUP BY grade, gender

--ANSWER #4B See code above. Females show up more than males, even with an NA value that could possibly be male. 

WITH ultra_mega_join AS (
	SELECT poem.title AS title, 
		   grade.name AS grade, 
	       gender.name AS gender, 
	       poem_emotion.intensity_percent AS intensity_perc, 
	       emotion.name AS emotion, 
	       poem.text AS text
	FROM poem
	JOIN author
	ON poem.author_id = author.id
		JOIN grade
		ON author.grade_id = grade.id
			JOIN gender
			ON author.gender_id = gender.id
				JOIN poem_emotion
				ON poem.id = poem_emotion.poem_id
					JOIN emotion
					ON poem_emotion.emotion_id = emotion.id
	),

ranks AS (
	SELECT grade, gender, intensity_perc, title, text,
	RANK() OVER(PARTITION BY grade ORDER BY intensity_perc DESC) AS intensity_rank
	FROM ultra_mega_join
	WHERE emotion = 'Anger' AND (grade = '1st Grade' OR grade = '5th Grade')
	),
	
grade1_top5 AS (
	SELECT grade, gender, intensity_perc, intensity_rank, title, text
	FROM ranks
	WHERE grade = '1st Grade'
	ORDER BY intensity_rank
	LIMIT 5
	),

grade5_top5 AS (
	SELECT grade, gender, intensity_perc, intensity_rank, title, text
	FROM ranks
	WHERE grade = '5th Grade'
	ORDER BY intensity_rank
	LIMIT 5
	)

SELECT title, text
FROM grade5_top5
UNION ALL
SELECT title, text
FROM grade1_top5

--ANSWER #4C - I suppose "Nature <something> Ways" which talks about summer and heat right now hits me the most. 

--QUESTION #5
	SELECT author.name AS name,
		   poem.title AS title, 
		   grade.name AS grade,
		   author.grade_id AS grade_num,
	       gender.name AS gender, 
	       poem_emotion.intensity_percent AS intensity_perc, 
	       emotion.name AS emotion, 
	       poem.text,
		   poem.char_count AS char_count	
	FROM poem
	JOIN author
	ON poem.author_id = author.id
		JOIN grade
		ON author.grade_id = grade.id
			JOIN gender
			ON author.gender_id = gender.id
				JOIN poem_emotion
				ON poem.id = poem_emotion.poem_id
					JOIN emotion
					ON poem_emotion.emotion_id = emotion.id
	WHERE author.name = 'emily'





--Investigation and testing code for quick reference 

SELECT * FROM emotion

SELECT * FROM poem_emotion
ORDER BY poem_id

SELECT * FROM poem
ORDER BY author_id DESC

SELECT * FROM author
ORDER BY id DESC

SELECT * FROM grade

SELECT * FROM gender
WHERE name = 'Male'