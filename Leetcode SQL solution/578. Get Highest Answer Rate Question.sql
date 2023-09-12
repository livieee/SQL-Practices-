-- Table: SurveyLog

-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | id          | int  |
-- | action      | ENUM |
-- | question_id | int  |
-- | answer_id   | int  |
-- | q_num       | int  |
-- | timestamp   | int  |
-- +-------------+------+
-- This table may contain duplicate rows.
-- action is an ENUM (category) of the type: "show", "answer", or "skip".
-- Each row of this table indicates the user with ID = id has taken an action with the question question_id at time timestamp.
-- If the action taken by the user is "answer", answer_id will contain the id of that answer, otherwise, it will be null.
-- q_num is the numeral order of the question in the current session.
 

-- The answer rate for a question is the number of times a user answered the question by the number of times a user showed the question.

-- Write a solution to report the question that has the highest answer rate. If multiple questions have the same maximum answer rate, report the question with the smallest question_id.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- SurveyLog table:
-- +----+--------+-------------+-----------+-------+-----------+
-- | id | action | question_id | answer_id | q_num | timestamp |
-- +----+--------+-------------+-----------+-------+-----------+
-- | 5  | show   | 285         | null      | 1     | 123       |
-- | 5  | answer | 285         | 124124    | 1     | 124       |
-- | 5  | show   | 369         | null      | 2     | 125       |
-- | 5  | skip   | 369         | null      | 2     | 126       |
-- +----+--------+-------------+-----------+-------+-----------+
-- Output: 
-- +------------+
-- | survey_log |
-- +------------+
-- | 285        |
-- +------------+
-- Explanation: 
-- Question 285 was showed 1 time and answered 1 time. The answer rate of question 285 is 1.0
-- Question 369 was showed 1 time and was not answered. The answer rate of question 369 is 0.0
-- Question 285 has the highest answer rate.




# SQL solution 1:

# 1. action = answer
# 2. action = show
# step1: get the column 
# step2: answer rate = divide the (count of action = answer)/count of action = show) , 
# get the answer_rate for each question,
# find the max(answer_rate) question: 
    #order by answer_rate, question_id desc limit 1


with
answered as
(
    select question_id, count(*) as num_ans
    from SurveyLog
    where action = 'answer'
    group by question_id
),
showed as
(
    select question_id, count(*) as num_show
    from SurveyLog
    where action = 'show'
    group by question_id
),
rate as
(
    select s.question_id as survey_log, COALESCE(num_ans,0)/num_show as answer_rate
    from showed as s
    # in case there is no answer for a question, we need to left join show with answer, so that every question id can be joined. Fill null value (for answer) with 0 to calculate the rate
    left join answered as a on a.question_id = s.question_id
)
select survey_log
from rate
order by answer_rate desc, survey_log asc
limit 1


--solution 2:
# end goal: get the question id
# with highest answer rate
SELECT question_id as survey_log
From SurveyLog
Group By question_id
Order By 
(count(answer_id)/count(case 
when action = 'show' 
then question_id
else null end)) desc,
question_id asc
Limit 1


--solution 3: use sum case when
#1. get the question_id (with highest rate/minimum question_id)
#2. get the answer rate for each question (group by question)
#3. order by rate desc, question_id asc limit 1
#4. rate: action = answer/action = show
select question_id as survey_log
from SurveyLog
group by question_id
order by (sum(
  case when action = 'answer' then 1 else 0 end
)/sum(
  case when action = 'show' then 1 else 0 end
)) desc, question_id asc
limit 1


--solution 4: use sum if
SELECT question_id survey_log
FROM SurveyLog
GROUP BY 1
ORDER BY SUM(IF(action='answer',1,0))/SUM(IF(action='show',1,0)) DESC, 1 ASC
LIMIT 1



