/* ---Задание №1--- */

SELECT name, COUNT(trip) AS count 
FROM 
    Passenger 
    INNER JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
GROUP BY name
ORDER BY count DESC, name ASC;


/* ---Задание №2--- */

SELECT TIMEDIFF( 
                (SELECT end_pair FROM Timepair WHERE id = 4),
                (SELECT start_pair FROM Timepair WHERE id = 2)
               ) AS time; 


/* ---Задание №3--- */

SELECT DISTINCT Rooms.*
FROM 
    Reservations
    INNER JOIN Rooms ON Reservations.room_id = Rooms.id
WHERE WEEK(Reservations.start_date, 1) = 12
      AND YEAR(Reservations.start_date) = 2020;


/* ---Задание №4--- */

SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(classroom) = (
                           SELECT COUNT(classroom) AS count 
                           FROM Schedule
                           GROUP BY classroom
                           ORDER BY count DESC 
                           LIMIT 1);


/* ---Задание №5--- */

WITH intervals AS (
                   SELECT date AS dt1,
                          LEAD(date) OVER(ORDER BY date) AS dt2
                   FROM (SELECT DISTINCT date FROM Income_o) AS tmp
                  )

SELECT COALESCE( (SELECT SUM(out) 
                  FROM Outcome_o 
                  WHERE date > dt1 and date <= dt2), 0 ) AS qty,
       dt1,
       dt2 
FROM intervals
WHERE dt2 IS NOT NULL;


/* ---Задание №6--- */

WITH Battles_sort AS (SELECT
                            ROW_NUMBER() OVER(ORDER BY date, name) AS rn,
                            name,
                            date
                      FROM Battles),
     k AS (SELECT COUNT(*) as count
           FROM Battles_sort
           WHERE rn%2=1)

SELECT TOP ( (SELECT * FROM k) )
       b.rn AS rn_1,
       b.name AS name_1,
       b.date AS date_1,
       LEAD(b.rn, (SELECT * FROM k), null) OVER(ORDER BY b.rn) AS rn_2,
       LEAD(b.name, (SELECT * FROM k), null) OVER(ORDER BY b.rn) AS name_2,
       LEAD(b.date, (SELECT * FROM k), null) OVER(ORDER BY b.rn) AS date_2
FROM Battles_sort AS b;
