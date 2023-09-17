-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key (combination of columns with unique values) of this table.
-- This table shows the activity of players of some games.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 

-- Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

-- The result format is in the following example.

 

-- Example 1:

-- Input: 
-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-02 | 0            |
-- | 3         | 4         | 2018-07-03 | 5            |
-- +-----------+-----------+------------+--------------+
-- Output: 
-- +-----------+
-- | fraction  |
-- +-----------+
-- | 0.33      |
-- +-----------+
-- Explanation: 
-- Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33

-- solution1: use cte, date diff, select diff >= 1 to keep all the entires, then calculate
# fraction: # players logged in again on the day after first_login/# total distinct players
# numerator：# players logged in at least two consecutive days from the first_login date
# - 1. create the first_login date
# - 2. create the column of date difference: event_date-first_login
# denominator: if diff = 0 => at least we have this team player
# numerator: if diff = 1, we have a consecutive date for this player, so sum all the diff = 1


WITH temp1 as (
    SELECT player_id,
    event_date,
    min(event_date) OVER(PARTITION BY player_id) as first_login
    FROM Activity
),
temp2 as (
    SELECT player_id,
    event_date,
    first_login,
    DATEDIFF(event_date, first_login) AS DIFF
    FROM temp1
    ORDER BY DIFF ASC
),
temp3 as (
    select distinct player_id, DIFF
    from temp2
    where DIFF <=1
)
SELECT round((sum(DIFF)/ sum(CASE WHEN DIFF = 0 THEN 1 ELSE 0 END)),2) as fraction
FROM temp3



SELECT ROUND(SUM(login)/COUNT(DISTINCT player_id), 2) AS fraction
FROM (
  SELECT
    player_id,
    DATEDIFF(event_date, MIN(event_date) OVER(PARTITION BY player_id)) = 1 AS login
  FROM Activity
) AS t



-- solution 2: 
-- numerator: # of player that has consecutive login after first login
-- Subquery: in the select, use datediff(event_date, first_login) = as a condition to find the
-- players who fit the question
SELECT ROUND(SUM(t.consecutive_login)/COUNT(DISTINCT player_id),2) AS fraction
FROM (
    SELECT player_id,
    DATEDIFF(event_date, min(event_date) OVER(PARTITION BY player_id)) = 1 AS consecutive_login 
    FROM Activity
) AS t

-- solution 3:
# solution 3:
#1. find count of player with consecutive login
#2. find total distinct player
WITH player_consec AS (
    SELECT COUNT(DISTINCT player_id) AS consec_num
    FROM Activity
    WHERE (player_id, DATE_SUB(event_date, INTERVAL 1 DAY)) IN (
        SELECT player_id, MIN(event_date) AS first_login
        FROM Activity
        GROUP BY player_id
    )
),
total_player AS (
    SELECT COUNT(DISTINCT player_id) AS total_count
    FROM Activity
)
SELECT ROUND(consec_num / total_count, 2) AS fraction
FROM player_consec, total_player



--solution 4:
# same as solution 3 but shorter
SELECT
  ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM
  Activity
WHERE
  (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
  IN (
    SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id
  )


