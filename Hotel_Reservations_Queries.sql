

-- Queries starting from here --



DROP VIEW IF EXISTS guestroom CASCADE;
DROP VIEW IF EXISTS guestservice CASCADE;
DROP VIEW IF EXISTS stay_days CASCADE;



-- 1. This query shows the room_id and the hotel name of every guest (also firstname, lastname) who stayed in the particular hotel;

WITH  fake_guests  AS (
    SELECT 
        ROW_NUMBER()  OVER(ORDER BY booked_at)  AS  guest_fake_id, *
    FROM   booking 
    WHERE  status = 'active'
) SELECT   DISTINCT  guest.guest_id, guest_first_name, guest_last_name, room_id, hotel_name
    FROM   fake_guests
        INNER JOIN  ternary_relationship_hotel_guest_service
            ON  fake_guests.guest_fake_id = ternary_relationship_hotel_guest_service.guest_id
        INNER JOIN  guest
            ON  ternary_relationship_hotel_guest_service.guest_id = guest.guest_id
        INNER JOIN  hotel
            ON  ternary_relationship_hotel_guest_service.hotel_unique_id = hotel.hotel_unique_id
    ORDER BY  guest_id
;




-- 2.1.
-- a) - This query answers to this question - From each country how many people use a specific type of service (excluding 0 cases)?
-- (For example when service_type_name = 'Doctor on call').

WITH  service_hotel  AS (
    SELECT * 
    FROM   ternary_relationship_hotel_guest_service
        INNER JOIN  other_service
            ON  other_service.service_id = ternary_relationship_hotel_guest_service.service_id
        INNER JOIN  hotel
            ON  hotel.hotel_unique_id = ternary_relationship_hotel_guest_service.hotel_unique_id 
) SELECT  country_name, COUNT(guest_id) AS number_of_occurences
    FROM  service_hotel
        INNER JOIN  country
            ON  country.country_code = service_hotel.country_code
    GROUP BY  country_name, service_type_name
        HAVING  service_type_name = 'Doctor on call'
    ORDER BY  number_of_occurences DESC
;




-- 2.1.
-- b) - This query answers to this question - For a given country how many people use a each service types (excluding 0 cases)?
-- (For example when country_name = 'Italy').

SELECT  service_type_name, COUNT(guest_id) AS number_of_occurences
FROM    ternary_relationship_hotel_guest_service
    INNER JOIN  other_service
        ON  ternary_relationship_hotel_guest_service.service_id = other_service.service_id
    INNER JOIN  hotel
        ON  ternary_relationship_hotel_guest_service.hotel_unique_id = hotel.hotel_unique_id
    INNER JOIN  country
        ON  hotel.country_code = country.country_code
GROUP BY  country_name, service_type_name
    HAVING  country_name = 'Italy'
ORDER BY  number_of_occurences  DESC
; 




-- 2.2.
-- a) - This query answers to this question - From each city how many people use a specific type of service (excluding 0 cases)?
-- (For example when service_type_name = 'Cauffeur driven limousine services').

SELECT  city_name, COUNT(guest_id) AS number_of_occurences
FROM    ternary_relationship_hotel_guest_service
    INNER JOIN  other_service
        ON  ternary_relationship_hotel_guest_service.service_id = other_service.service_id
    INNER JOIN  hotel
        ON  ternary_relationship_hotel_guest_service.hotel_unique_id = hotel.hotel_unique_id
    INNER JOIN  country
        ON  hotel.country_code = country.country_code
    INNER JOIN  city
        ON  country.country_code = city.country_code
GROUP BY  city_name, service_type_name
    HAVING  service_type_name = 'Cauffeur driven limousine services'
ORDER BY  number_of_occurences  DESC
; 




-- 2.2
-- b) - This query answers to this question - For a given city how many people use each service types (excluding 0 cases)?
-- (For example when city_name = 'Doha').

SELECT  service_type_name, COUNT(guest_id) AS number_of_occurences
FROM    ternary_relationship_hotel_guest_service
    INNER JOIN  other_service
        ON  other_service.service_id = ternary_relationship_hotel_guest_service.service_id
    INNER JOIN  hotel
        ON  ternary_relationship_hotel_guest_service.hotel_unique_id = hotel.hotel_unique_id
    INNER JOIN  country
        ON  hotel.country_code = country.country_code
    INNER JOIN  city
        ON  city.country_code = country.country_code
GROUP BY  city_name, service_type_name
    HAVING  city_name = 'Doha'
ORDER BY  number_of_occurences  DESC
; 




-- 3) This query shows the list of hotels which have 10, 9, 8 as 
-- feedback ratings and we also include the occurences of those ratings.

SELECT  hotel_name, feedback_rating, COUNT(feedback_giver_guest_id) AS number_of_occurences, guest_feedback.hotel_id
FROM    guest_feedback, hotel
    WHERE  guest_feedback.hotel_id = hotel.hotel_id
GROUP BY  hotel_name, feedback_rating, guest_feedback.hotel_id
    HAVING  feedback_rating = 10
        OR  feedback_rating = 9
        OR  feedback_rating = 8
ORDER BY  feedback_rating  DESC
; 




-- 4) This query shows which is the most preferred room type.

SELECT  room_type_id, room_type_description, COUNT(service_id) AS number_of_occurences_of_booking
FROM    room_type
    NATURAL JOIN  room
    INNER JOIN  booking
        ON  room.room_id = booking.room_id
GROUP BY  room_type_id, room_type_description
ORDER BY  number_of_occurences_of_booking  DESC LIMIT 1
;




-- 5) This query shows the hotel chain name and it`s quantity of hotels which have 5 stars(it can be 4, 3, 2, 1)

SELECT  hotel_chain_name, COUNT(hotel_id) AS quantity
FROM    hotel_chain
    NATURAL JOIN  hotel
GROUP BY  hotel_chain_name, hotel_star
    HAVING  hotel_star = 5
ORDER BY  quantity  DESC
; 




-- 6) This query shows which room type is the most preferable for the guests with no children.

SELECT  room_type_id, children_number, room_type_description, COUNT(booking.service_id) AS number_of_occurences_of_booking
FROM    room_type
    NATURAL JOIN  room
    INNER JOIN  booking
        ON  room.room_id = booking.room_id
GROUP BY  room_type_id, room_type_description, children_number
    HAVING  children_number = 0
ORDER BY  number_of_occurences_of_booking  DESC LIMIT 1
; 




-- 7) With this query we obtain the cost amount of room stay for each guest.

---------------------------------------This is the view part-----------------------------------

CREATE VIEW  guestroom
AS (
    SELECT  guest.guest_id, guest_first_name, guest_last_name, room_id
    FROM (
        SELECT 
            ROW_NUMBER()  OVER(ORDER BY check_in_time) AS guest_fake_id, *
        FROM   booking 
        WHERE  status = 'active'
   ) AS  guest_booking
    INNER JOIN  ternary_relationship_hotel_guest_service
        ON  guest_booking.guest_fake_id = ternary_relationship_hotel_guest_service.guest_id
    INNER JOIN  guest
        ON  guest_booking.guest_fake_id = guest.guest_id
  GROUP BY  guest.guest_id, guest_first_name, guest_last_name, room_id, guest_booking.service_id
        HAVING  guest_booking.service_id = 1
  ORDER BY  guest_id
);

-----------------------------------------------------------------------------------------------

SELECT DISTINCT  guest_id, guest_first_name, guest_last_name, room_id, SUM(room_price_in_dollars) AS price_for_the_stay
FROM  guestroom
    INNER JOIN  daily_room_price
        ON  guestroom.room_id = daily_room_price.room_unique_id
GROUP BY  guest_id, guest_first_name, guest_last_name, room_id
ORDER BY  price_for_the_stay  DESC
;




-- 8) With this query we obtain the cost amount of additional other services(For ex. Car rental services, Lounge and Bar) in hotel servies for each guest.

-----------------------------------This is the view part-------------------------------

CREATE VIEW  guestservice
AS (
    SELECT  guest.guest_id, guest_first_name, guest_last_name, other_service.service_id, service_price_in_dollars, other_service.service_type_name
    FROM (
        SELECT 
        ROW_NUMBER()  OVER(ORDER BY booked_at) AS guest_fake_id, *
        FROM   booking 
        WHERE  status = 'active'
   ) AS  guest_booking
    INNER JOIN  ternary_relationship_hotel_guest_service
        ON  guest_booking.guest_fake_id = ternary_relationship_hotel_guest_service.guest_id
    INNER JOIN  other_service
        ON  ternary_relationship_hotel_guest_service.service_id = other_service.service_id
    INNER JOIN  guest
        ON  guest_booking.guest_fake_id = guest.guest_id
);

-------------------------------------------------------------------------------------------

SELECT DISTINCT  guest_id, guest_first_name, guest_last_name, SUM(service_price_in_dollars) AS price_for_the_inhotel_service
FROM   guestservice
GROUP BY  guest_id, guest_first_name, guest_last_name
ORDER BY  guest_id  DESC
; 




-- 9) This query answers to this question
-- How many days each guest stayed in the hotel(we also include the hotel name, hotel ID, hotel chain id)?

-----------------------------------This is the view part-------------------------------

CREATE VIEW  stay_days
AS (
    SELECT  hotel_chain_id, hotel.hotel_unique_id, guest_id, ( check_out_time - check_in_time ) AS days_stayed
    FROM (
        SELECT 
        ROW_NUMBER()  OVER(ORDER BY check_in_time) AS guest_fake_id, *
        FROM   booking 
        WHERE  status = 'active'
   ) AS  guest_booking
    INNER JOIN  ternary_relationship_hotel_guest_service
        ON  guest_booking.guest_fake_id = ternary_relationship_hotel_guest_service.guest_id
    INNER JOIN  hotel
        ON  ternary_relationship_hotel_guest_service.hotel_unique_id = hotel.hotel_unique_id
    GROUP BY  hotel_chain_id, hotel.hotel_unique_id, guest_id, days_stayed
    ORDER BY  hotel_chain_id
);

---------------------------------------------------------------------------------------

SELECT DISTINCT  d.*, hotel_name
FROM   hotel  AS h
    INNER JOIN  stay_days  AS d
        ON   h.hotel_unique_id = d.hotel_unique_id
        AND  h.hotel_chain_id = d.hotel_chain_id
; 




-- 10) This query returns hotel's name, the guest id, guest's first and last names who cancelled their bookings.

SELECT DISTINCT  guest.guest_id, guest_first_name, guest_last_name, hotel_name, status
FROM (
    SELECT 
    ROW_NUMBER()  OVER(ORDER BY booked_at) AS guest_fake_id, *
    FROM  booking 
   ) AS  guest_booking
    INNER JOIN  ternary_relationship_hotel_guest_service
        ON  guest_booking.guest_fake_id = ternary_relationship_hotel_guest_service.guest_id
    FULL JOIN   guest
        ON  guest_booking.guest_fake_id = guest.guest_id
    INNER JOIN  hotel
        ON  ternary_relationship_hotel_guest_service.hotel_unique_id = hotel.hotel_unique_id
WHERE  status = 'cancelled'
;




-- 11) This query gives information about the weekly revenue of each hotel

-----------------------------------This is the view part-------------------------------

CREATE OR REPLACE VIEW  hotel_revenue
AS (
    SELECT DISTINCT  guest.guest_id, guest_first_name, guest_last_name, hotel_unique_id
    FROM (
        SELECT 
        ROW_NUMBER()  OVER(ORDER BY booked_at) AS guest_fake_id, *
        FROM   booking 
        WHERE  status = 'active'
    ) AS  guest_booking
    INNER JOIN  ternary_relationship_hotel_guest_service
        ON  guest_booking.guest_fake_id = ternary_relationship_hotel_guest_service.guest_id
    INNER JOIN  guest
        ON  guest_booking.guest_fake_id = guest.guest_id
    ORDER BY  guest.guest_id
);

---------------------------------------------------------------------------------------

WITH  hotel_room  AS (
    SELECT  *  FROM  daily_room_price
    INNER JOIN  room
        ON  daily_room_price.room_unique_id = room.room_unique_id
) SELECT  DISTINCT  hotel.hotel_unique_id, hotel.hotel_name, SUM(room_price_in_dollars) AS weekly_revenue_of_hotel
    FROM  hotel_revenue 
        INNER JOIN  hotel_room
            ON  hotel_revenue.hotel_unique_id = hotel_room.hotel_unique_id
        INNER JOIN  hotel
            ON  hotel_revenue.hotel_unique_id = hotel.hotel_unique_id
    GROUP BY  hotel.hotel_unique_id, hotel_name
    ORDER BY  weekly_revenue_of_hotel  DESC
; 
  



