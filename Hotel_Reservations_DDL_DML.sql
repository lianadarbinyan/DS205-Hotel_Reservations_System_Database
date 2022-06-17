
---  TABLE CREATION  ---  DDL  ---



DROP TABLE IF EXISTS hotel_chain CASCADE ;
DROP TABLE IF EXISTS service_manager CASCADE ;
DROP TABLE IF EXISTS country CASCADE ;
DROP TABLE IF EXISTS guest CASCADE ;
DROP TABLE IF EXISTS guest_feedback CASCADE ;
DROP TABLE IF EXISTS city CASCADE ;
DROP TABLE IF EXISTS hotel CASCADE ;
DROP TABLE IF EXISTS daily_room_price CASCADE ;
DROP TABLE IF EXISTS room_type CASCADE ;
DROP TABLE IF EXISTS room CASCADE ;
DROP TABLE IF EXISTS service CASCADE ;
DROP TABLE IF EXISTS booking CASCADE ;
DROP TABLE IF EXISTS other_services CASCADE ;
DROP TABLE IF EXISTS ternary_relationship_hotel_guest_service CASCADE ;
DROP SEQUENCE IF EXISTS seq_dp_id CASCADE ;
DROP SEQUENCE IF EXISTS seq_book_id CASCADE ;
DROP SEQUENCE IF EXISTS seq_tern_id CASCADE ;




CREATE TABLE hotel_chain(

  hotel_chain_id INTEGER NOT NULL,
  hotel_chain_name VARCHAR(200) NOT NULL,

  PRIMARY KEY (hotel_chain_id)
 );
 
 
 
CREATE TABLE service_manager(

  service_manager_id INTEGER NOT NULL UNIQUE,
  service_manager_first_name VARCHAR(200) NOT NULL,
  service_manager_last_name  VARCHAR(200) NOT NULL,
  service_manager_age INTEGER NOT NULL,

  PRIMARY KEY (service_manager_id)
);
 
 
 
CREATE TABLE country(

  country_code INTEGER NOT NULL ,
  country_name VARCHAR(200) NOT NULL,

  PRIMARY KEY (country_code)
);



CREATE TABLE guest (

  guest_id integer NOT NULL,
  guest_first_name VARCHAR(200) NOT NULL,
  guest_last_name VARCHAR(200) NOT NULL,
  guest_email VARCHAR(200) NOT NULL,
  guest_age INTEGER NOT NULL,

  country_code INTEGER NOT NULL REFERENCES country(country_code) ON DELETE CASCADE,

  PRIMARY KEY (guest_id)
);


 
CREATE TABLE city (

  city_id INTEGER NOT NULL UNIQUE,
  city_name VARCHAR(100) NOT NULL,

  country_code INTEGER NOT NULL REFERENCES country(country_code) ON DELETE CASCADE,

  PRIMARY KEY (city_id, country_code)
);



CREATE TABLE hotel (

  hotel_id INTEGER NOT NULL UNIQUE,
  hotel_name VARCHAR(200) NOT NULL,
  hotel_address VARCHAR(200) NOT NULL,
  hotel_url VARCHAR(1000) NOT NULL,
  hotel_email VARCHAR(1000) NOT NULL,
  hotel_phone_number VARCHAR(999) NOT NULL,
  hotel_star INTEGER NOT NULL CHECK( hotel_star IN (1,2,3,4,5) ),

  hotel_chain_id INTEGER NOT NULL REFERENCES hotel_chain(hotel_chain_id),
  country_code INTEGER NOT NULL REFERENCES country(country_code),
  city_id INTEGER NOT NULL UNIQUE REFERENCES city(city_id),

  CONSTRAINT hotel_keys UNIQUE(hotel_id, hotel_chain_id, country_code, city_id),
  hotel_unique_id INTEGER NOT NULL UNIQUE,

  PRIMARY KEY (hotel_unique_id)
);



CREATE TABLE guest_feedback (

  feedback_giver_guest_ID INTEGER NOT NULL,
  feedback_rating INTEGER NOT NULL CHECK(feedback_rating IN (1,2,3,4,5,6,7,8,9,10)),
  feedback_comment VARCHAR(5000) NOT NULL,

  hotel_id INTEGER NOT NULL REFERENCES hotel(hotel_id) ON DELETE CASCADE,
  guest_id INTEGER NOT NULL REFERENCES guest(guest_id) ON DELETE CASCADE,

  PRIMARY KEY (guest_id, hotel_id, feedback_giver_guest_ID, feedback_comment)
);



CREATE TABLE room_type (

  room_type_id INTEGER NOT NULL,
  room_type_description VARCHAR(1000) NOT NULL,

  PRIMARY KEY (room_type_id)
);



CREATE TABLE room (

  room_id INTEGER NOT NULL UNIQUE,
  room_floor VARCHAR(1000) NOT NULL,
  room_number INTEGER NOT NULL,
  room_size VARCHAR(1000) NOT NULL,

  hotel_unique_id INTEGER NOT NULL REFERENCES hotel(hotel_unique_id),
  room_type_id INTEGER NOT NULL REFERENCES room_type(room_type_id),
  
  CONSTRAINT room_keys UNIQUE(room_id, hotel_unique_id, room_type_id),
  room_unique_id INTEGER NOT NULL UNIQUE,

  PRIMARY KEY (room_unique_id)

);



CREATE TABLE daily_room_price (

  room_price_in_dollars integer NOT NULL,
  r_date TIMESTAMP NOT NULL,

  room_unique_id INTEGER NOT NULL REFERENCES room(room_unique_id),

  CONSTRAINT daily_room_price_keys UNIQUE(r_date, room_unique_id),
  daily_price_unique_id INTEGER NOT NULL UNIQUE,

  PRIMARY KEY (daily_price_unique_id)


);



CREATE Table service (

  service_id INTEGER NOT NULL,
  service_type_name VARCHAR(4000) NOT NULL,

  PRIMARY KEY (service_id)
);



CREATE TABLE booking (

  adults_number INTEGER NOT NULL,
  children_number INTEGER NOT NULL,
  status VARCHAR(100) CHECK( status in ('active', 'cancelled') ) ,
  booked_at TIMESTAMP NOT NULL,
  check_in_time DATE,
  check_out_time DATE,

  room_id INTEGER NOT NULL REFERENCES room(room_id) ON DELETE CASCADE,

  CONSTRAINT booking_keys UNIQUE(service_id, service_type_name, room_id, booked_at, check_in_time, check_out_time),
  booking_unique_id INTEGER NOT NULL UNIQUE,


  PRIMARY KEY (booking_unique_id)

) INHERITS (service);



CREATE TABLE other_service (

  service_price_in_dollars NUMERIC(100) NOT NULL,

  service_manager_id INTEGER NOT NULL UNIQUE REFERENCES service_manager(service_manager_id),
  
  PRIMARY KEY (service_id, service_type_name)

) INHERITS (service);



CREATE TABLE ternary_relationship_hotel_guest_service (
 
  hotel_unique_id INTEGER NOT NULL REFERENCES hotel(hotel_unique_id),
  guest_id INTEGER NOT NULL REFERENCES guest(guest_id) ON DELETE CASCADE,
  service_id INTEGER REFERENCES service(service_id) ON DELETE CASCADE,
  ternary_unique_id INTEGER NOT NULL unique,

  PRIMARY KEY (ternary_unique_id, hotel_unique_id, guest_id, service_id)
);








---  INSERTIONS  ---  DML  ---







DROP SEQUENCE IF EXISTS seq_dp_id;
DROP SEQUENCE IF EXISTS seq_book_id;
DROP SEQUENCE IF EXISTS seq_tern_id;




INSERT INTO public.hotel_chain ( hotel_chain_id, hotel_chain_name )
  VALUES
  (1, 'Mariott International'),
  (2, 'Hilton'),
  (3, 'Gaylord Hotels'),
  (4, 'Sheraton Hotels and Resorts'),
  (5, 'Accor Hotels'),
  (6, 'Choice Hotels'),
  (7, 'Days Inn'),
  (8, 'Even Hotels'),
  (9, 'Wyndham Hotels'),
  (10, 'Courtyard Hotels')
;




INSERT INTO public.service_manager ( service_manager_id, service_manager_first_name, service_manager_last_name, service_manager_age )
  VALUES
  (1, 'James', 'Smith', 19),
  (2, 'Alexandra', 'Johnson', 26),
  (3, 'Gaylord', 'Williams', 29),
  (4, 'Muraka', 'Huraki', 22 ),
  (5, 'Betty', 'Garcia', 29),
  (6, 'Ovsanna', 'Armenakyan', 40),
  (7, 'Sipan', 'Araratyan', 82),
  (8, 'Kevin', 'Shelby', 37),
  (9, 'Will', 'Smith', 50),
  (10, 'Qilis', 'Ichi', 41)
;
    


 
INSERT INTO public.country ( country_name, country_code )
  VALUES
  ('Italy', 380),
  ('Monaco', 492),
  ('Netherlands', 528),
  ('Oman', 512),
  ('Peru', 604),
  ('Slovenia', 705),
  ('Armenia', 51),
  ('United Kingdom', 826),
  ('Canada', 124),
  ('France', 250),
  ('Germany', 276),
  ('Greece', 300),
  ('Hungary', 348),
  ('Japan', 392),
  ('Iran', 364),
  ('Jamaica', 388),
  ('Macedonia', 807),
  ('Malta', 470),
  ('Nepal', 524),
  ('Qatar', 634)
;
 
 


INSERT INTO public.guest ( guest_id, guest_first_name, guest_last_name, guest_email, guest_age, country_code )
  VALUES
  (1, 'Mark', 'Wick', 'mark_wick@gmail.com', 29, 826),
  (2, 'Anita', 'Quincey', 'anita_quincey@gmail.com', 26, 124),
  (3, 'Sandy', 'Quincy', 'sandy_quincy@gmail.com', 39, 705),
  (4, 'Alice', 'Voorhees', 'alice_voorhees@gmail.com', 63, 604),
  (5, 'Bob', 'Krueger', 'bob_krueger@gmail.com', 36, 470),
  (6, 'Bob', 'Nigger', 'bob_nigger@gmail.com', 60, 492),
  (7, 'Sargis', 'Wick', 'sargis_wick@gmail.com', 33, 528),
  (8, 'Vermont', 'Pandher', 'vermont_pendher@gmail.com', 30, 380),
  (9, 'Valeri', 'Sahakyan', 'valeri_sahakyan@gmail.com', 38, 51),
  (10, 'Shaqar', 'Sahakyan', 'shaqar_sahakyan@gmail.com', 59, 51),
  (11, 'Pedri', 'Krueger', 'pedri_krueger@gmail.com', 59, 276),
  (12, 'Bob', 'Krueger', 'bob_krueger@gmail.com', 26, 300),
  (13, 'Eve', 'Quincey', 'eve_quincey@gmail.com', 25, 392),
  (14, 'Eva', 'Quin', 'eva_quin@gmail.com', 57,  388),
  (15, 'Bubba', 'Black', 'bubba_black@gmail.com', 34, 807),
  (16, 'Nader', 'Alfie', 'nadar_alfie@gmail.com', 52, 364),
  (17, 'Nadin', 'Soze', 'nadin_soze@gmail.com', 22, 524),
  (18, 'Louie', 'Sall', 'louie_sall@gmail.com', 44, 348),
  (19, 'Dewey', 'Quincy', 'dewey_quincy@gmail.com',  80, 250),
  (20, 'Huey', 'Quey', 'huey_quey@gmail.com', 31, 634),
  (21, 'Manvel', 'Arshakyan', 'manvel_arshakyan@gmail.com', 33, 51),
  (22, 'Huey', 'Qulak', 'huey_qulak@gmail.com', 31, 634),
  (23, 'Galust', 'Arshakyan', 'galust_arshakyan@gmail.com', 33, 51),
  (24, 'Huey', 'Quey', 'huey_quey@gmail.com', 31, 300),
  (25, 'Silva', 'Arshakyan', 'silva_arshakyan@gmail.com', 33, 364),
  (26, 'Nader', 'Alfie',  'nadar_alfie@gmail.com', 52, 807),
  (27, 'Nadine', 'Soze', 'nadine_soze@gmail.com', 22, 524),
  (28, 'Louie', 'Sall', 'louie_sall@gmail.com', 44, 348),
  (29, 'Dewey', 'Quincy', 'dewey_quincy@gmail.com', 80, 250),
  (30, 'Subba', 'White', 'subba_white@gmail.com', 34, 634),
  (31, 'Harry', 'Quey', 'harry_quey@gmail.com', 30, 250),
  (32, 'Samvel', 'Ashotyan', 'samvel_ashotyan@gmail.com', 32, 51),
  (33, 'Huey', 'Quluk', 'huey_quluk@gmail.com', 31, 634),
  (34, 'Galustik', 'Arshakyan', 'galustik_arshakyan@gmail.com', 19, 51),
  (35, 'Hans', 'Quey', 'hans_quey@gmail.com', 31, 250),
  (36, 'Silvik', 'Arshakyan', 'silvik_arshakyan@gmail.com', 33, 51),
  (37, 'Nadir', 'Alfie',  'nadir_alfie@gmail.com', 42, 634),
  (38, 'Nado', 'Soza', 'nado_soza@gmail.com', 22, 524),
  (39, 'Low', 'Sally', 'low_sally@gmail.com', 24, 634),
  (40, 'Dave', 'Quincy', 'dave_quincy@gmail.com', 80, 51),
  (41, 'Lubba', 'Brown', 'lubba_brown@gmail.com', 34, 807),
  (42, 'Markos', 'Wickos', 'markos_wickos@gmail.com', 78, 826),
  (43, 'Anitik', 'Quincey', 'anitik_quincey@gmail.com', 29, 124),
  (44, 'Vandos', 'Quincy', 'vandos_quincy@gmail.com', 45, 705),
  (45, 'Alicya', 'Vorhees', 'alicya_vorhees@gmail.com', 63, 634),
  (46, 'Bobby', 'Krueger', 'bobby_krueger@gmail.com', 37, 380),
  (47, 'Bob', 'Subber', 'bob_subber@gmail.com', 60, 492),
  (48, 'Sargis','Janoyan', 'sargis_janoyan@gmail.com', 33, 51),
  (49, 'Vermontik', 'Pandher', 'vermontik_pandher@gmail.com', 30, 380),
  (50, 'Valer', 'Sahakyan', 'valer_sahakyan@gmail.com', 28, 51),
  (51, 'Shaqe', 'Suqiasyan', 'shaqe_suqiasyan@gmail.com', 60, 51),
  (52, 'Pedros', 'Pedro', 'pedi_kdr@gmail.com', 59, 300),
  (53, 'Bob', 'Pedro', 'bob_pedro@gmail.com', 29, 300),
  (54, 'Eve', 'Quin', 'eve_quin@gmail.com', 25, 807),
  (55, 'Evalina', 'Quin', 'evalin_quin@gmail.com', 59,  388),
  (56, 'Bubbassa', 'Black', 'bubbassa_black@gmail.com', 34, 524),
  (57, 'Nazer', 'Alfie', 'nadzer_alfie@gmail.com', 52, 524),
  (58, 'Nadine', 'Soza', 'nadine_soza@gmail.com', 22, 250),
  (59, 'Lowa', 'Sally', 'losall@gmail.com', 44, 51),
  (60, 'Dave', 'Quin', 'd_quin@gmail.com',  80, 634),
  (61, 'Huey', 'Huey', 'huey_huey@gmail.com', 31, 250),
  (62, 'Sipan', 'Arshakyan', 'sipan_arshakyan@gmail.com', 38, 51),
  (63, 'Haze', 'Qulak', 'h_qulak@gmail.com', 31, 250)
;




INSERT INTO public.city( city_id, city_name, country_code )
  VALUES
  (1, 'Rome', 380),
  (2, 'Venice', 380),
  (3, 'Milan', 380),
  (4, 'La Turbie', 492),
  (5, 'Beausoleil', 492),
  (6, 'Amsterdam', 528),
  (7, 'Utrecht', 528),
  (8, 'Sur', 512),
  (9, 'Khasab', 512),
  (10, 'Lima', 604),
  (11, 'Tarapoto', 604),
  (12, 'Maribor', 705),
  (13, 'Bled', 705),
  (14, 'Bovec', 705),
  (15, 'Yerevan', 51),
  (16, 'Dilijan', 51),
  (17, 'Gyumri', 51),
  (18, 'Ijevan', 51),
  (19, 'London', 826),
  (20, 'Birmingham', 826),
  (21, 'Toronto', 124),
  (22, 'Ottawa', 124),
  (23, 'Paris', 250),
  (24, 'Lyon', 250),
  (25, 'Hamburg', 276),
  (26, 'Berlin', 276),
  (27, 'Kavala', 300),
  (28, 'Athens', 300),
  (29, 'Eger', 348),
  (30, 'Sopron', 348),
  (31, 'Tokyo', 392),
  (32, 'Naha', 392),
  (33, 'Tehran', 364),
  (34, 'Ardebil', 364),
  (35, 'Kingston', 388),
  (36, 'Linsead', 388),
  (37, 'Bitola', 807),
  (38, 'Gostivar', 807),
  (39, 'Birgu', 470),
  (40, 'Mdina', 470),
  (41, 'Kathmandu', 524),
  (42, 'Doha', 634)
;
    



INSERT INTO public.hotel(hotel_unique_id, hotel_id, hotel_name, hotel_address, hotel_url, hotel_email, hotel_phone_number, hotel_star, hotel_chain_id, country_code, city_id )
  VALUES
  (1, 1, 'Mariot Hotel Rome', 'Via della Conciliazione, 00193 Rome, Italy', 'https://www.marriott.com/search/submitSearch.mi?', 'mariotrome@gmail.com', '+39 390 205 422', 5, 1, 380, 1),
  (2, 2, 'Mariot Hotel Venice', 'Calle Varisco, Venice, Italy', 'https://www.marriott.com/search/VeniceSearch.mi', 'mariotVenice@gmail.com', '+39 390 205 498', 5, 1, 380, 2),
  (3, 3, 'Hilton La Turbie', 'Rue Bellevue 33/40, La Turbie, Monaco', 'https://www.Hilton.com/search/LaturbieSearch.mi', 'HiltonLaturbie@gmail.com', '+377 380 404 498', 3, 2, 492, 4),
  (4, 4, 'Hilton Beausoleil', 'Av. de Villaine 8/10, Beausoleil, Monaco', 'https://www.Hilton.com/search/BeausoleilSearch.mi', 'HiltonBeausoleil@yahoo.com', '+377 580 496 397', 5, 2, 492, 5),
  (5, 5, 'Gaylord Hotel Amsterdam', 'Geuzenveld-Slotermeer8/20, Amsterdam, Netherlands', 'https://www.GayLordHotelAmsterdam.com/search/Amsterdam////.mi', 'GaylordHotelAmsterdam@gmail.com', '+31 549 777 390', 4, 3, 528, 6),
  (6, 6, 'Gaylord Hotel Utrecht', 'Oude Zederik 18/9, Utrecht, Netherlands', 'https://www.GayLordHotelUtrecht.com/searchhotel/Utrecht////.mi', 'GaylordHotelUtrecht@gmail.com', '+31 643 797 339', 5, 3, 528, 7),
  (7, 7, 'Sheraton Sur', 'Al Aise Street, Sur', 'https://www.booking.com/hotel/om/sur-plaza.en-us.html?aid=1250365;label=huno.1;sid=15575652b00f6776c3ca5c7fe37a3fba;all_sr_blocks=7435502_344679873_0_0_0;checkin=2022-05-17;checkout=2022-05-18;dest_id=-789047;dest_type=city;dist=0;group_adults=2;group_children=0;hapos=1;highlighted_blocks=7435502_344679873_0_0_0;hpos=1;matching_block_id=7435502_344679873_0_0_0;no_rooms=1;req_adults=2;req_children=0;room1=A%2CA;sb_price_type=total;sr_order=popularity;sr_pri_blocks=7435502_344679873_0_0_0__1852;srepoch=1652181835;srpvid=b27550252413005a;type=total;ucfs=1&#hotelTmpl ', 'sheratonsur@gmail.com', '+968 1505 4929', 3, 4, 512, 8),
  (8, 8, 'Sheraton Lima', 'Paseo de la República 170, Lima 1 Lima, Peru', 'https://www.booking.com/hotel/pe/sheraton-lima-convention-center.en-us.html?aid=1250365;label=huno.1;sid=15575652b00f6776c3ca5c7fe37a3fba;all_sr_blocks=23840204_270635248_2_1_0;checkin=2022-05-17;checkout=2022-05-18;dest_id=-352647;dest_type=city;dist=0;group_adults=2;group_children=0;hapos=1;highlighted_blocks=23840204_270635248_2_1_0;hpos=1;matching_block_id=23840204_270635248_2_1_0;no_rooms=1;req_adults=2;req_children=0;room1=A%2CA;sb_price_type=total;sr_order=popularity;sr_pri_blocks=23840204_270635248_2_1_0__8900;srepoch=1652182831;srpvid=b140521767ad033f;type=total;ucfs=1&#hotelTmpl ', 'sheratonlima@gmail.com', '+51 974 426 649', 5, 4, 604, 10),
  (9, 9, 'Accor Khasab', 'Khasab, Oman, 811 Khasab, Oman', 'https://www.booking.com/hotel/om/atana-musandam.en-us.html?aid=1250365;label=huno.1;sid=15575652b00f6776c3ca5c7fe37a3fba;all_sr_blocks=107668601_264053326_3_2_0;checkin=2022-05-17;checkout=2022-05-18;dest_id=-787654;dest_type=city;dist=0;group_adults=2;group_children=0;hapos=1;highlighted_blocks=107668601_264053326_3_2_0;hpos=1;matching_block_id=107668601_264053326_3_2_0;no_rooms=1;req_adults=2;req_children=0;room1=A%2CA;sb_price_type=total;sr_order=popularity;sr_pri_blocks=107668601_264053326_3_2_0__5400;srepoch=1652182537;srpvid=42cc5184b82f0463;type=total;ucfs=1&#hotelTmpl ', 'sheratonkhasab@gmail.com', '+968 7725 6393', 4, 5, 512, 9),
  (10, 10, 'Accor Tarapoto', 'Jr. Pedro de Urzua 515, TARA 01 Tarapoto, Peru', 'https://www.booking.com/hotel/pe/rio-cumbaza.en-us.html?aid=1250365;label=huno.1;sid=15575652b00f6776c3ca5c7fe37a3fba;all_sr_blocks=38960502_340995254_2_1_0;checkin=2022-05-17;checkout=2022-05-18;dest_id=-365359;dest_type=city;dist=0;group_adults=2;group_children=0;hapos=1;highlighted_blocks=38960502_340995254_2_1_0;hpos=1;matching_block_id=38960502_340995254_2_1_0;no_rooms=1;req_adults=2;req_children=0;room1=A%2CA;sb_price_type=total;sr_order=popularity;sr_pri_blocks=38960502_340995254_2_1_0__6500;srepoch=1652183107;srpvid=9a0952a1416801e2;type=total;ucfs=1&#hotelTmpl ', 'accortarapoto@gmail.com', '+51 969 711 013', 3, 5, 604, 11),
  (11, 11, 'Choice Maribor', 'Karantanska ulica, 2000 Maribor, Slovenia', 'https://www.booking.com/hotel/si/kacar.en-us.html?aid=1250365;label=huno.1;sid=15575652b00f6776c3ca5c7fe37a3fba;all_sr_blocks=24687605_118216747_0_2_0;checkin=2022-05-17;checkout=2022-05-18;dest_id=-88556;dest_type=city;dist=0;group_adults=2;group_children=0;hapos=3;highlighted_blocks=24687605_118216747_0_2_0;hpos=3;matching_block_id=24687605_118216747_0_2_0;no_rooms=1;req_adults=2;req_children=0;room1=A%2CA;sb_price_type=total;sr_order=popularity;sr_pri_blocks=24687605_118216747_0_2_0__10500;srepoch=1652183350;srpvid=d8b3531a42c70485;type=total;ucfs=1&#hotelTmpl ', 'choicemaribor@gmail.com', '+386 40 106 144', 2, 6, 705, 12),
  (12, 12, 'Choice Bled', 'Ljubljanska cesta 6, 4260 Bled, Slovenia', 'https://www.booking.com/hotel/si/hotel-lovec.en-us.html?aid=1250365;label=huno.1;sid=15575652b00f6776c3ca5c7fe37a3fba;all_sr_blocks=3956739_94104690_0_33_0;checkin=2022-05-17;checkout=2022-05-18;dest_id=-75414;dest_type=city;dist=0;group_adults=2;group_children=0;hapos=1;highlighted_blocks=3956739_94104690_0_33_0;hpos=1;matching_block_id=3956739_94104690_0_33_0;no_rooms=1;req_adults=2;req_children=0;room1=A%2CA;sb_price_type=total;sr_order=popularity;sr_pri_blocks=3956739_94104690_0_33_0__11475;srepoch=1652183580;srpvid=9813538d96830109;type=total;ucfs=1&#hotelTmpl ', 'choicebled@gmail.com', '+386 65 177 551', 4, 6, 705, 13),
  (13, 13, 'Days Inn Doha', 'St. 910. Al Corniche Street', 'https://www.wyndhamhotels.com/days-inn', 'daysinn@gmail.com', '+91 60493 15971', 3, 7, 634, 42),
  (14, 14, 'Courtyard Hotels Athens', 'Agias Theklas 10, Athina 105 54', 'https://courtyard.marriott.com/', 'courtyhotel@gmail.com', '+30 691 558 8818', 5, 10, 300, 28),
  (15, 15, 'Courtyard Hotels Tokyo', '26-1 Sakuragaokacho, Shibuya City', 'https://courtyard.marriott.com/', 'courtyhotel@gmail.com', '+81 80-5390-3878', 4, 10, 392, 31),
  (16, 16, 'Wyndham Hotels Naha', '46-54 songaremal, Naha City', 'https://courtyard.marriott.com/', 'courtyhotel@gmail.com', '+81 90-8785-1552', 2, 9, 392, 32),
  (17, 17, 'Even Hotels Tehran', 'Baghestan Street 15/16, Tehran Iran', 'https://evenhotelstehran.com/', 'evenhoteltehran@gmail.com', '+98 87-8675-1092', 1, 8, 364, 33),
  (18, 18, 'Mariot Hotel Milan', 'Via pellegrini Conciliazione, 193/3 Milan, Italy', 'https://www.marriottmilan.com/search/submitSearch.mi?', 'mariotmilan@gmail.com','+39 377 205 422',5, 1, 380, 3);
;




INSERT INTO public.guest_feedback( feedback_giver_guest_ID, guest_id, hotel_id, feedback_rating,  feedback_comment )
  VALUES
  (1, 1, 1, 10, 'What a great hotel!'),
  (1, 1, 2, 9, 'I really love this place'),
  (1, 1, 3, 8, 'Woww nice stay!'),
  (1, 1, 4, 10, 'Sickoooo!'),
  (2, 2, 2, 8, 'Nice stay. Near the train station. Easy access to metro'),
  (2, 2, 3, 9, 'Easy access to transport and nice service'),
  (2, 2, 1, 1, 'I will never come here again((('),
  (2, 2, 6, 2, 'Me and my wife had a bad time here…'),
  (3, 3, 3, 6, 'Good Hotel'),
  (3, 1, 3, 10, 'Fine touch, liked it'),
  (3, 10, 3, 9, 'I will come here next summer'),
  (4, 4, 4, 2, 'Bad'),
  (5, 5, 5, 9, 'Perfecto'),
  (5, 1, 5, 9, 'Perfectinho'),
  (5, 10, 5, 10, 'Perfectinho'),
  (6, 6, 6, 5, 'Perfect for single, overnight'),
  (7, 7, 7, 7, 'pleasant stay'),
  (8, 8, 8, 8, 'Great'),
  (9, 9, 9, 10, 'Super!'),
  (10, 10, 10, 3, 'SHat vat er'),
  (11, 11, 2, 7, 'Very clean'),
  (12, 12, 4, 2, 'I am very disappointed'),
  (13, 13, 6, 6, 'Not so bad'),
  (14, 14, 4, 1, 'Hard to find, horrible'),
  (15, 15, 7, 9, 'Will come here again'),
  (16, 16, 9, 10, 'Perfect for a stay'),
  (17, 17, 2, 9, 'I liked this hotel very much'),
  (17, 17, 5, 8, 'A very good one'),
  (20, 20, 3, 9, 'Perfect stay, thank you'),
  (23, 23, 4, 4, 'Horribleeeee'),
  (24, 24, 10, 3, 'Kashmaaaar'),
  (25, 25, 2, 5, 'Well, finneee'),
  (27, 27, 5, 7, 'Could have been better, but OK!'),
  (28, 28, 4, 4, 'I don’t know what to say, but I didn’t like it'),
  (29, 29, 6, 10, 'I am obsesseddd!!!!!'),
  (31, 31, 8, 9, 'Good :)'),
  (33, 33, 3, 3, 'CURSED!')
;




INSERT INTO public.room_type( room_type_id, room_type_description )
  VALUES
  (1, 'Single: A room assigned to one person. May have one or more beds. The room size or area of Single Rooms are generally between 37 m² to 45 m².'),
  (2, 'Double: A room assigned to two people. May have one or more beds. The room size or area of Double Rooms are generally between 40 m² to 45 m².'),
  (3, 'Triple: A room that can accommodate three persons and has been fitted with three twin beds, one double bed and one twin bed or two double beds.The room size or area of Triple Rooms are generally between 45 m² to 65 m².'),
  (4, 'Quad: A room assigned to four people. May have two or more beds. The room size or area of Quad Rooms are generally between 70 m² to 85 m².'),
  (5, 'Queen: A room with a queen-sized bed. May be occupied by one or more people. The room size or area of Queen Rooms are generally between 32 m² to 50 m².'),
  (6, 'King: A room with a king-sized bed. May be occupied by one or more people. The room size or area of King Rooms are generally between 32 m² to 50 m².'),
  (7, 'Twin: A room with two twin beds. May be occupied by one or more people. The room size or area of Twin Rooms are generally between 32 m² to 40 m².'),
  (8, 'Double-double: A Room with two double beds. And can accommodate two to four persons with two twin, double or queen-size beds. The room size or area of Double-double / Double Twin rooms are generally between 50 m² to 70 m².'),
  (9, 'Suite: A parlour or living room connected with to one or more bedrooms. (A room with one or more bedrooms and a separate living space.) The room size or area of Suite rooms are generally between 70 m² to 100 m².'),
  (10, 'Presidential Suite: The most expensive room provided by a hotel. Usually, only one president suite is available in one single hotel property. Similar to the normal suites, a president suite always has one or more bedrooms and a living space with a strong emphasis on grand in-room decoration, high-quality amenities and supplies, and tailor-made services. The room size or area of Presidential Suites are generally between 80 m² to 350 m².')
;
 
 


INSERT INTO public.room( room_unique_id, room_id, room_floor, room_number, room_size, hotel_unique_id, room_type_id )
  VALUES
  (1, 1, 1, 101, '38m²', 1, 1),
  (2, 2, 2, 201, '40m²', 1, 7),
  (3, 3, 3, 301, '45m²', 1, 2),

  (4, 4, 1, 105, '38m²', 2, 1),
  (5, 5, 2, 206, '38m²', 2, 1),
  (6, 6, 3, 307, '50m²', 2, 5),

  (7, 7, 1, 108, '65m²', 3, 3),
  (8, 8, 2, 201, '65m²', 3, 3),
  (9, 9, 3, 311, '38m²', 3, 1),

  (10, 10, 1, 112, '50m²', 4, 5),
  (11, 11, 2, 233, '150m²', 4, 10),
  (12, 12, 3, 301, '38m²', 4, 1),

  (13, 13, 1, 101, '65m²', 5, 3),
  (14, 14, 2, 221, '350m²', 5, 10),
  (15, 15, 3, 306, '32m²', 5, 7),

  (16, 16, 1, 121, '40m²', 6, 1),
  (17, 17, 2, 232, '70m²', 6, 9),
  (18, 18, 3, 304, '50m²', 6, 8),

  (19, 19, 1, 193, '40m²', 7, 1),
  (20, 20, 2, 207, '45m²', 7, 2),
  (21, 21, 3, 311, '85m²', 7, 4),

  (22, 22, 1, 116, '40m²', 9, 1),
  (23, 23, 2, 234, '40m²', 9, 1),
  (24, 24, 3, 345, '40m²', 9, 1),

  (25, 25, 1, 116, '65m²', 8, 3),
  (26, 26, 2, 216, '70m²', 8, 9),
  (27, 27, 3, 316, '300m²', 8, 10),

  (28, 28, 1, 106, '37m²', 10, 1),
  (29, 29, 2, 223, '40m²', 10, 2),
  (30, 30, 3, 304, '45m²', 10, 3),

  (31, 31, 1, 104, '50m²', 11, 8),
  (32, 32, 2, 204, '37m²', 11, 1),
  (33, 33, 3, 304, '40m²', 11, 2),

  (34, 34, 1, 112, '40m²', 12, 2),
  (35, 35, 3, 203, '40m²', 12, 2),
  (36, 36, 3, 304, '40m²', 12, 2),

  (37, 37, 1, 103, '56m²', 13, 6),
  (38, 38, 2, 205, '41m²', 13, 2),
  (39, 39, 3, 314, '42m²', 13, 2),

  (40, 40, 1, 103, '56m²', 14, 6),
  (41, 41, 2, 205, '41m²', 14, 2),
  (42, 42, 3, 314, '37m²', 14, 1),

  (43, 43, 1, 113, '56m²', 15, 6),
  (44, 44, 2, 225, '41m²', 15, 2),
  (45, 45, 3, 313, '37m²', 15, 1),

  (46, 46, 1, 111, '56m²', 16, 6),
  (47, 47, 2, 222, '41m²', 16, 2),
  (48, 48, 3, 333, '37m²', 16, 1),

  (49, 49, 1, 111, '56m²', 17, 6),
  (50, 50, 2, 222, '41m²', 17, 2),
  (51, 51, 3, 333, '37m²', 17, 1)
;




CREATE SEQUENCE seq_dp_id START WITH 1 INCREMENT BY 1; 


INSERT INTO daily_room_price( daily_price_unique_id, room_price_in_dollars, r_date, room_unique_id )
  VALUES
  (NEXTVAL('seq_dp_id'), 120, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 1),
  (NEXTVAL('seq_dp_id'), 120, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 1),
  (NEXTVAL('seq_dp_id'), 120, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 1),
  (NEXTVAL('seq_dp_id'), 115, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 1),
  (NEXTVAL('seq_dp_id'), 115, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 1),
  (NEXTVAL('seq_dp_id'), 110, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 1),
  (NEXTVAL('seq_dp_id'), 110, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 1),

  (NEXTVAL('seq_dp_id'), 100, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 2),
  (NEXTVAL('seq_dp_id'), 100, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 2),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 2),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 2),
  (NEXTVAL('seq_dp_id'), 95, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 2),
  (NEXTVAL('seq_dp_id'), 95, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 2),
  (NEXTVAL('seq_dp_id'), 95, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 2),

  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 3),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 3),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 3),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 3),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 3),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 3),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 3),

  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 4),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 4),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 4),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 4),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 4),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 4),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 4),

  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 5),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 5),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 5),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 5),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 5),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 5),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 5),

  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 6),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 6),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 6),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 6),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 6),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 6),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 6),

  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 7),
  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 7),
  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 7),
  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 7),
  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 7),
  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 7),
  (NEXTVAL('seq_dp_id'), 160, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 7),

  (NEXTVAL('seq_dp_id'), 298, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 8),
  (NEXTVAL('seq_dp_id'), 298, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 8),
  (NEXTVAL('seq_dp_id'), 298, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 8),
  (NEXTVAL('seq_dp_id'), 298, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 8),
  (NEXTVAL('seq_dp_id'), 298, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 8),
  (NEXTVAL('seq_dp_id'), 298, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 8),
  (NEXTVAL('seq_dp_id'), 300, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 8),

  (NEXTVAL('seq_dp_id'), 45, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 9),
  (NEXTVAL('seq_dp_id'), 45, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 9),
  (NEXTVAL('seq_dp_id'), 45, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 9),
  (NEXTVAL('seq_dp_id'), 45, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 9),
  (NEXTVAL('seq_dp_id'), 45, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 9),
  (NEXTVAL('seq_dp_id'), 45, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 9),
  (NEXTVAL('seq_dp_id'), 45, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 9),

  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 10),
  (NEXTVAL('seq_dp_id'), 148, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 10),
  (NEXTVAL('seq_dp_id'), 146, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 10),
  (NEXTVAL('seq_dp_id'), 148, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 10),
  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 10),
  (NEXTVAL('seq_dp_id'), 148, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 10),
  (NEXTVAL('seq_dp_id'), 150, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 10),

  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 11),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 11),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 11),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 11),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 11),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 11),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 11),

  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 12),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 12),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 12),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 12),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 12),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 12),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 12),

  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 13),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 13),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 13),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 13),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 13),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 13),
  (NEXTVAL('seq_dp_id'), 65, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 13),

  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 14),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 14),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 14),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 14),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 14),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 14),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 14),

  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 15),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 15),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 15),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 15),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 15),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 15),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 15),

  (NEXTVAL('seq_dp_id'), 80, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 16),
  (NEXTVAL('seq_dp_id'), 80, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 16),
  (NEXTVAL('seq_dp_id'), 80, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 16),
  (NEXTVAL('seq_dp_id'), 81, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 16),
  (NEXTVAL('seq_dp_id'), 81, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 16),
  (NEXTVAL('seq_dp_id'), 81, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 16),
  (NEXTVAL('seq_dp_id'), 81, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 16),

  (NEXTVAL('seq_dp_id'), 71, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 17),
  (NEXTVAL('seq_dp_id'), 71, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 17),
  (NEXTVAL('seq_dp_id'), 71, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 17),
  (NEXTVAL('seq_dp_id'), 71, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 17),
  (NEXTVAL('seq_dp_id'), 71, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 17),
  (NEXTVAL('seq_dp_id'), 71, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 17),
  (NEXTVAL('seq_dp_id'), 71, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 17),

  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 18),
  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 18),
  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 18),
  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 18),
  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 18),
  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 18),
  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 18),

  (NEXTVAL('seq_dp_id'), 77, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 19),
  (NEXTVAL('seq_dp_id'), 77, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 19),
  (NEXTVAL('seq_dp_id'), 77, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 19),
  (NEXTVAL('seq_dp_id'), 78, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 19),
  (NEXTVAL('seq_dp_id'), 79, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 19),
  (NEXTVAL('seq_dp_id'), 80, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 19),
  (NEXTVAL('seq_dp_id'), 80, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 19),

  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 20),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 20),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 20),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 20),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 20),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 20),
  (NEXTVAL('seq_dp_id'), 160, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 20),

  (NEXTVAL('seq_dp_id'), 25, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 21),
  (NEXTVAL('seq_dp_id'), 26, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 21),
  (NEXTVAL('seq_dp_id'), 26, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 21),
  (NEXTVAL('seq_dp_id'), 26, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 21),
  (NEXTVAL('seq_dp_id'), 26, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 21),
  (NEXTVAL('seq_dp_id'), 20, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 21),
  (NEXTVAL('seq_dp_id'), 20, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 21),

  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 22),
  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 22),
  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 22),
  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 22),
  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 22),
  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 22),
  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 22),

  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 23),
  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 23),
  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 23),
  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 23),
  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 23),
  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 23),
  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 23),

  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 24),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 24),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 24),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 24),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 24),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 24),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 24),

  (NEXTVAL('seq_dp_id'), 55.9, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 25),
  (NEXTVAL('seq_dp_id'), 55.9, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 25),
  (NEXTVAL('seq_dp_id'), 55.9, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 25),
  (NEXTVAL('seq_dp_id'), 55.9, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 25),
  (NEXTVAL('seq_dp_id'), 55.9, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 25),
  (NEXTVAL('seq_dp_id'), 55.9, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 25),
  (NEXTVAL('seq_dp_id'), 55.9, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 25),

  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 26),
  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 26),
  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 26),
  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 26),
  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 26),
  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 26),
  (NEXTVAL('seq_dp_id'), 80, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 26),

  (NEXTVAL('seq_dp_id'), 115, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 27),
  (NEXTVAL('seq_dp_id'), 110, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 27),
  (NEXTVAL('seq_dp_id'), 110, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 27),
  (NEXTVAL('seq_dp_id'), 120, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 27),
  (NEXTVAL('seq_dp_id'), 120, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 27),
  (NEXTVAL('seq_dp_id'), 120, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 27),
  (NEXTVAL('seq_dp_id'), 120, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 27),

  (NEXTVAL('seq_dp_id'), 89, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 28),
  (NEXTVAL('seq_dp_id'), 89, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 28),
  (NEXTVAL('seq_dp_id'), 89, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 28),
  (NEXTVAL('seq_dp_id'), 89, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 28),
  (NEXTVAL('seq_dp_id'), 89, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 28),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 28),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 28),

  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 29),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 29),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 29),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 29),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 29),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 29),
  (NEXTVAL('seq_dp_id'), 91, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 29),

  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 30),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 30),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 30),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 30),
  (NEXTVAL('seq_dp_id'), 70, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 30),
  (NEXTVAL('seq_dp_id'), 71, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 30),
  (NEXTVAL('seq_dp_id'), 72, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 30),

  (NEXTVAL('seq_dp_id'), 10, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 31),
  (NEXTVAL('seq_dp_id'), 11, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 31),
  (NEXTVAL('seq_dp_id'), 12, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 31),
  (NEXTVAL('seq_dp_id'), 12, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 31),
  (NEXTVAL('seq_dp_id'), 12, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 31),
  (NEXTVAL('seq_dp_id'), 12, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 31),
  (NEXTVAL('seq_dp_id'), 12, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 31),

  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 32),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 32),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 32),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 32),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 32),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 32),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 32),

  (NEXTVAL('seq_dp_id'), 89, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 33),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 33),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 33),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 33),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 33),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 33),
  (NEXTVAL('seq_dp_id'), 90, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 33),

  (NEXTVAL('seq_dp_id'), 57, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 34),
  (NEXTVAL('seq_dp_id'), 57, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 34),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 34),
  (NEXTVAL('seq_dp_id'), 56, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 34),
  (NEXTVAL('seq_dp_id'), 52, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 34),
  (NEXTVAL('seq_dp_id'), 54, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 34),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 34),

  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 35),
  (NEXTVAL('seq_dp_id'), 63, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 35),
  (NEXTVAL('seq_dp_id'), 62, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 35),
  (NEXTVAL('seq_dp_id'), 64, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 35),
  (NEXTVAL('seq_dp_id'), 62, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 35),
  (NEXTVAL('seq_dp_id'), 62, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 35),
  (NEXTVAL('seq_dp_id'), 63, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 35),

  (NEXTVAL('seq_dp_id'), 56, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 36),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 36),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 36),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 36),
  (NEXTVAL('seq_dp_id'), 53, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 36),
  (NEXTVAL('seq_dp_id'), 54, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 36),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 36),

  (NEXTVAL('seq_dp_id'), 100, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 37),
  (NEXTVAL('seq_dp_id'), 101, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 37),
  (NEXTVAL('seq_dp_id'), 101, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 37),
  (NEXTVAL('seq_dp_id'), 102, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 37),
  (NEXTVAL('seq_dp_id'), 108, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 37),
  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 37),
  (NEXTVAL('seq_dp_id'), 100, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 37),

  (NEXTVAL('seq_dp_id'), 80, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 38),
  (NEXTVAL('seq_dp_id'), 81, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 38),
  (NEXTVAL('seq_dp_id'), 81, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 38),
  (NEXTVAL('seq_dp_id'), 82, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 38),
  (NEXTVAL('seq_dp_id'), 83, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 38),
  (NEXTVAL('seq_dp_id'), 82, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 38),
  (NEXTVAL('seq_dp_id'), 82, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 38),

  (NEXTVAL('seq_dp_id'), 22, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 39),
  (NEXTVAL('seq_dp_id'), 23, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 39),
  (NEXTVAL('seq_dp_id'), 22, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 39),
  (NEXTVAL('seq_dp_id'), 21, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 39),
  (NEXTVAL('seq_dp_id'), 24, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 39),
  (NEXTVAL('seq_dp_id'), 24, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 39),
  (NEXTVAL('seq_dp_id'), 23, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 39),

  (NEXTVAL('seq_dp_id'), 77, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 40),
  (NEXTVAL('seq_dp_id'), 78, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 40),
  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 40),
  (NEXTVAL('seq_dp_id'), 75, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 40),
  (NEXTVAL('seq_dp_id'), 75, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 40),
  (NEXTVAL('seq_dp_id'), 74, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 40),
  (NEXTVAL('seq_dp_id'), 73, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 40),

  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 41),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 41),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 41),
  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 41),
  (NEXTVAL('seq_dp_id'), 65, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 41),
  (NEXTVAL('seq_dp_id'), 65, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 41),
  (NEXTVAL('seq_dp_id'), 65, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 41),

  (NEXTVAL('seq_dp_id'), 92, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 42),
  (NEXTVAL('seq_dp_id'), 93, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 42),
  (NEXTVAL('seq_dp_id'), 93, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 42),
  (NEXTVAL('seq_dp_id'), 94, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 42),
  (NEXTVAL('seq_dp_id'), 94, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 42),
  (NEXTVAL('seq_dp_id'), 95, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 42),
  (NEXTVAL('seq_dp_id'), 96, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 42),

  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 43),
  (NEXTVAL('seq_dp_id'), 86, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 43),
  (NEXTVAL('seq_dp_id'), 85, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 43),
  (NEXTVAL('seq_dp_id'), 83, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 43),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 43),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 43),
  (NEXTVAL('seq_dp_id'), 88, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 43),

  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 44),
  (NEXTVAL('seq_dp_id'), 97, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 44),
  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 44),
  (NEXTVAL('seq_dp_id'), 96, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 44),
  (NEXTVAL('seq_dp_id'), 97, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 44),
  (NEXTVAL('seq_dp_id'), 98, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 44),
  (NEXTVAL('seq_dp_id'), 99, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 44),

  (NEXTVAL('seq_dp_id'), 77, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 45),
  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 45),
  (NEXTVAL('seq_dp_id'), 72, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 45),
  (NEXTVAL('seq_dp_id'), 75, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 45),
  (NEXTVAL('seq_dp_id'), 79, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 45),
  (NEXTVAL('seq_dp_id'), 73, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 45),
  (NEXTVAL('seq_dp_id'), 78, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 45),

  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 46),
  (NEXTVAL('seq_dp_id'), 202, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 46),
  (NEXTVAL('seq_dp_id'), 204, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 46),
  (NEXTVAL('seq_dp_id'), 204, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 46),
  (NEXTVAL('seq_dp_id'), 202, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 46),
  (NEXTVAL('seq_dp_id'), 202, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 46),
  (NEXTVAL('seq_dp_id'), 200, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 46),

  (NEXTVAL('seq_dp_id'), 115, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 47),
  (NEXTVAL('seq_dp_id'), 115, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 47),
  (NEXTVAL('seq_dp_id'), 112, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 47),
  (NEXTVAL('seq_dp_id'), 115, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 47),
  (NEXTVAL('seq_dp_id'), 111, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 47),
  (NEXTVAL('seq_dp_id'), 111, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 47),
  (NEXTVAL('seq_dp_id'), 115, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 47),

  (NEXTVAL('seq_dp_id'), 95, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 48),
  (NEXTVAL('seq_dp_id'), 94, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 48),
  (NEXTVAL('seq_dp_id'), 95, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 48),
  (NEXTVAL('seq_dp_id'), 95, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 48),
  (NEXTVAL('seq_dp_id'), 92, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 48),
  (NEXTVAL('seq_dp_id'), 91, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 48),
  (NEXTVAL('seq_dp_id'), 95, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 48),

  (NEXTVAL('seq_dp_id'), 68, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 49),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 49),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 49),
  (NEXTVAL('seq_dp_id'), 66, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 49),
  (NEXTVAL('seq_dp_id'), 67, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 49),
  (NEXTVAL('seq_dp_id'), 65, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 49),
  (NEXTVAL('seq_dp_id'), 60, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 49),

  (NEXTVAL('seq_dp_id'), 48, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 50),
  (NEXTVAL('seq_dp_id'), 48, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 50),
  (NEXTVAL('seq_dp_id'), 49, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 50),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 50),
  (NEXTVAL('seq_dp_id'), 50, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 50),
  (NEXTVAL('seq_dp_id'), 48, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 50),
  (NEXTVAL('seq_dp_id'), 55, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 50),

  (NEXTVAL('seq_dp_id'), 76, TO_TIMESTAMP('2022-01-01 13:34','YYYY-MM-DD HH24:MI'), 51),
  (NEXTVAL('seq_dp_id'), 75, TO_TIMESTAMP('2022-01-02 13:34','YYYY-MM-DD HH24:MI'), 51),
  (NEXTVAL('seq_dp_id'), 77, TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), 51),
  (NEXTVAL('seq_dp_id'), 74, TO_TIMESTAMP('2022-01-04 13:34','YYYY-MM-DD HH24:MI'), 51),
  (NEXTVAL('seq_dp_id'), 73, TO_TIMESTAMP('2022-01-05 13:34','YYYY-MM-DD HH24:MI'), 51),
  (NEXTVAL('seq_dp_id'), 75, TO_TIMESTAMP('2022-01-06 13:34','YYYY-MM-DD HH24:MI'), 51),
  (NEXTVAL('seq_dp_id'), 79, TO_TIMESTAMP('2022-01-07 13:34','YYYY-MM-DD HH24:MI'), 51)
;




INSERT INTO public.service ( service_id , service_type_name )
  VALUES
  (1, 'booking'),
  (2, 'Car rental services'),
  (3,  'Doctor on call'),
  (4, 'Guided tour'),
  (5, 'Cauffeur driven limousine services'),
  (6, 'Lounge and bar services'),
  (7, 'Sauna'),
  (8, 'Renting a conference-hall'),
  (9, 'Rehabilitative services'),
  (10, 'Restaurant'),
  (11,  'Gym and Yoga')
;




CREATE SEQUENCE seq_book_id START WITH 1 INCREMENT BY 1;


INSERT INTO public.booking ( booking_unique_id, service_id, service_type_name, room_id, adults_number, children_number, status, booked_at, check_in_time, check_out_time )
  VALUES
  (NEXTVAL('seq_book_id'), 1, 'booking', 1, 1, 0, 'active', TO_TIMESTAMP('2022-01-03 13:34','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 15:30', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 2, 2, 2, 'active', TO_TIMESTAMP('2022-01-01 09:13','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-01 13:05', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 3, 1, 2, 'active', TO_TIMESTAMP('2022-01-02 09:30','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 13:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 4, 2, 2, 'active', TO_TIMESTAMP('2022-01-01 10:21','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 14:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 5, 1, 1, 'cancelled', TO_TIMESTAMP('2022-01-02 11:23','YYYY-MM-DD HH24:MI'), NULL, NULL),
  (NEXTVAL('seq_book_id'), 1, 'booking', 6, 1, 1, 'active', TO_TIMESTAMP('2022-01-02 10:14','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 13:55', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 7, 4, 8, 'active', TO_TIMESTAMP('2022-01-01 10:23','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 11:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 7, 1, 0, 'active', TO_TIMESTAMP('2022-01-02 10:36','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 12:10', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 8, 1, 0, 'active', TO_TIMESTAMP('2022-01-01 11:21','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-01 14:06', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 8, 1, 0, 'active', TO_TIMESTAMP('2022-01-02 11:54','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 13:27', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 8, 1, 0, 'active', TO_TIMESTAMP('2022-01-03 11:12','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 13:11', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 8, 1, 0, 'active', TO_TIMESTAMP('2022-01-04 11:43','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 14:03', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 8, 1, 0, 'active', TO_TIMESTAMP('2022-01-05 11:20','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:06', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 8, 1, 0, 'active', TO_TIMESTAMP('2022-01-06 12:34','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 9, 2, 1, 'active', TO_TIMESTAMP('2022-01-03 10:39','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 10:10', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 9, 2, 1, 'active', TO_TIMESTAMP('2022-01-04 09:34','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 11:08', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 10, 2, 1, 'active', TO_TIMESTAMP('2022-01-02 12:42','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 12:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 11, 4, 2, 'active', TO_TIMESTAMP('2022-01-02 13:37','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 15:30', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 12, 4, 2, 'active', TO_TIMESTAMP('2022-01-01 14:19','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-01 14:34', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 12, 4, 2, 'active', TO_TIMESTAMP('2022-01-02 11:59','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 13:45', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 12, 4, 2, 'active', TO_TIMESTAMP('2022-01-03 12:27','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 15:11', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 12, 4, 2, 'active', TO_TIMESTAMP('2022-01-04 11:30','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:06', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 12, 4, 2, 'active', TO_TIMESTAMP('2022-01-04 10:44','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 12:43', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 13, 4, 2, 'active', TO_TIMESTAMP('2022-01-04 12:26','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 09:09', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 13, 2, 2, 'active', TO_TIMESTAMP('2022-01-03 09:39','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 17:10', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 13, 1, 0, 'cancelled', TO_TIMESTAMP('2022-01-02 14:23','YYYY-MM-DD HH24:MI'), NULL, NULL),
  (NEXTVAL('seq_book_id'), 1, 'booking', 13, 2, 0, 'active', TO_TIMESTAMP('2022-01-02 12:16','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 12:07', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 14, 1, 0, 'active', TO_TIMESTAMP('2022-01-03 11:38','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 12:20', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 15, 1, 0, 'active', TO_TIMESTAMP('2022-01-04 11:26','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 15:17', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 16, 1, 1, 'active', TO_TIMESTAMP('2022-01-05 11:07','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 18:18', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 16, 1, 1, 'active', TO_TIMESTAMP('2022-01-06 12:11','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 14:13', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 17, 1, 1, 'active', TO_TIMESTAMP('2022-01-04 11:03','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-08 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 18, 1, 1, 'active', TO_TIMESTAMP('2022-01-01 13:23','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-01 17:10', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 19, 1, 2, 'active', TO_TIMESTAMP('2022-01-01 12:25','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-01 20:16', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 25, 6, 7, 'active', TO_TIMESTAMP('2022-01-01 10:17','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 15:10', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 25, 2, 2, 'active', TO_TIMESTAMP('2022-01-03 10:00','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 12:03', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 25, 2, 2, 'active', TO_TIMESTAMP('2022-01-03 11:23','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 13:07', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 25, 1, 0, 'active', TO_TIMESTAMP('2022-01-04 08:10','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 12:21', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 25, 1, 0, 'active', TO_TIMESTAMP('2022-01-06 06:46','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:31', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 27, 1, 1, 'active', TO_TIMESTAMP('2022-01-06 12:09','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 28, 6, 0, 'active', TO_TIMESTAMP('2021-01-01 10:17','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 12:06', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 29, 5, 1, 'active', TO_TIMESTAMP('2021-01-04 17:28','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 10:05', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 30, 4, 0, 'active', TO_TIMESTAMP('2021-01-05 13:33','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 15:11', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 17:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 32, 4, 0, 'active', TO_TIMESTAMP('2021-01-01 10:32','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 12:34', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 33, 2, 0, 'active', TO_TIMESTAMP('2021-01-02 10:06','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 11:10', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 34, 5, 1, 'active', TO_TIMESTAMP('2021-01-06 11:43','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 17:05', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 35, 1, 0, 'active', TO_TIMESTAMP('2021-01-03 14:16','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 09:07', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 36, 2, 3, 'active', TO_TIMESTAMP('2021-01-04 20:34','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 12:54', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 37, 8, 0, 'active', TO_TIMESTAMP('2021-01-01 16:47','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-01 20:02', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 38, 3, 2, 'active', TO_TIMESTAMP('2021-01-06 10:38','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 19:10', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-08 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 39, 2, 0, 'active', TO_TIMESTAMP('2021-01-02 19:33','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:06', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 40, 3, 0, 'cancelled', TO_TIMESTAMP('2021-01-03 10:23','YYYY-MM-DD HH24:MI'), NULL, NULL),
  (NEXTVAL('seq_book_id'), 1, 'booking', 40, 2, 0, 'active', TO_TIMESTAMP('2021-01-03 07:54','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 10:04', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 42, 5, 0, 'active', TO_TIMESTAMP('2021-01-02 14:20','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 09:08', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 42, 5, 0, 'active', TO_TIMESTAMP('2021-01-02 11:00','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 12:31', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 44, 3, 0, 'active', TO_TIMESTAMP('2021-01-02 10:49','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 14:04', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-06 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 45, 2, 1, 'active', TO_TIMESTAMP('2021-01-01 12:50','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-02 15:12', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 46, 4, 0, 'active', TO_TIMESTAMP('2021-01-02 14:10','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 11:08', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 47, 3, 1, 'active', TO_TIMESTAMP('2021-01-01 13:25','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 10:02', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 48, 2, 0, 'active', TO_TIMESTAMP('2021-12-30 05:14','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-01 11:20', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 49, 1, 2, 'active', TO_TIMESTAMP('2022-01-03 10:31','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 14:16', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-04 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 49, 4, 1, 'active', TO_TIMESTAMP('2022-01-03 10:32','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-05 14:21', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI')),
  (NEXTVAL('seq_book_id'), 1, 'booking', 50, 2, 2, 'active', TO_TIMESTAMP('2022-01-02 11:0','YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-03 16:04', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2022-01-07 13:00','YYYY-MM-DD HH24:MI'))
;




INSERT INTO public.other_service ( service_id, service_type_name, service_manager_id, service_price_in_dollars )
  VALUES
  (2, 'Car rental services', 5, 20),
  (3, 'Doctor on call', 1, 0),
  (4, 'Guided tour', 3, 15.5),
  (5, 'Cauffeur driven limousine services', 2, 100),
  (6, 'Lounge and bar services', 6, 65),
  (7, 'Sauna', 8, 0),
  (8, 'Renting a conference-hall', 9, 15),
  (9, 'Rehabilitative services', 4, 10),
  (10, 'Restaurant', 10, 100),
  (11, 'Gym and Yoga', 7, 0)
;




CREATE SEQUENCE seq_tern_id START WITH 1 INCREMENT BY 1;


INSERT INTO public.ternary_relationship_hotel_guest_service ( ternary_unique_id, service_id, hotel_unique_id, guest_id )
  VALUES
  (NEXTVAL('seq_tern_id'), 1, 1, 1),
  (NEXTVAL('seq_tern_id'), 2, 1, 1),
  (NEXTVAL('seq_tern_id'), 3, 1, 1),

  (NEXTVAL('seq_tern_id'), 1, 1, 2),
  (NEXTVAL('seq_tern_id'), 6, 1, 2),
  (NEXTVAL('seq_tern_id'), 8, 1, 2),
  (NEXTVAL('seq_tern_id'), 10, 1, 2),

  (NEXTVAL('seq_tern_id'), 1, 1, 3),
  (NEXTVAL('seq_tern_id'), 4, 1, 3),
  (NEXTVAL('seq_tern_id'), 5, 1, 3),
  (NEXTVAL('seq_tern_id'), 7, 1, 3),
  (NEXTVAL('seq_tern_id'), 2, 1, 3),

  (NEXTVAL('seq_tern_id'), 1, 2, 4),
  (NEXTVAL('seq_tern_id'), 6, 2, 4),
  (NEXTVAL('seq_tern_id'), 10, 2, 4),
  (NEXTVAL('seq_tern_id'), 11, 2, 4),
  (NEXTVAL('seq_tern_id'), 5, 2, 4),

  (NEXTVAL('seq_tern_id'), 1, 2, 5),
  (NEXTVAL('seq_tern_id'), 6, 2, 5),
  (NEXTVAL('seq_tern_id'), 2, 2, 5),
  (NEXTVAL('seq_tern_id'), 4, 2, 5),
  (NEXTVAL('seq_tern_id'), 3, 2, 5),

  (NEXTVAL('seq_tern_id'), 1, 2, 6),
  (NEXTVAL('seq_tern_id'), 8, 2, 6),
  (NEXTVAL('seq_tern_id'), 10, 2, 6),
  (NEXTVAL('seq_tern_id'), 3, 2, 6),
  (NEXTVAL('seq_tern_id'), 11, 2, 6),
  (NEXTVAL('seq_tern_id'), 9, 2, 6),

  (NEXTVAL('seq_tern_id'), 1, 3, 7),
  (NEXTVAL('seq_tern_id'), 10, 3, 7),

  (NEXTVAL('seq_tern_id'), 1, 3, 8),
  (NEXTVAL('seq_tern_id'), 6, 3, 8),
  (NEXTVAL('seq_tern_id'), 3, 3, 8),
  (NEXTVAL('seq_tern_id'), 4, 3, 8),

  (NEXTVAL('seq_tern_id'), 1, 3, 9),
  (NEXTVAL('seq_tern_id'), 2, 3, 9),
  (NEXTVAL('seq_tern_id'), 8, 3, 9),
  (NEXTVAL('seq_tern_id'), 11, 3, 9),

  (NEXTVAL('seq_tern_id'), 1, 3, 10),
  (NEXTVAL('seq_tern_id'), 3, 3, 10),
  (NEXTVAL('seq_tern_id'), 7, 3, 10),
  (NEXTVAL('seq_tern_id'), 8, 3, 10),

  (NEXTVAL('seq_tern_id'), 1, 3, 11),
  (NEXTVAL('seq_tern_id'), 7, 3, 11),

  (NEXTVAL('seq_tern_id'), 1, 3, 12),
  (NEXTVAL('seq_tern_id'), 10, 3, 12),
  (NEXTVAL('seq_tern_id'), 11, 3, 12),

  (NEXTVAL('seq_tern_id'), 1, 3, 13),
  (NEXTVAL('seq_tern_id'), 9, 3, 13),
  (NEXTVAL('seq_tern_id'), 6, 3, 13),
  (NEXTVAL('seq_tern_id'), 4, 3, 13),

  (NEXTVAL('seq_tern_id'), 1, 3, 14),
  (NEXTVAL('seq_tern_id'), 6, 3, 14),
  (NEXTVAL('seq_tern_id'), 10, 3, 14),

  (NEXTVAL('seq_tern_id'), 1, 3, 15),
  (NEXTVAL('seq_tern_id'), 2, 3, 15),
  (NEXTVAL('seq_tern_id'), 5, 3, 15),

  (NEXTVAL('seq_tern_id'), 1, 3, 16),
  (NEXTVAL('seq_tern_id'), 3, 3, 16),

  (NEXTVAL('seq_tern_id'), 1, 3, 17),
  (NEXTVAL('seq_tern_id'), 6, 3, 17),

  (NEXTVAL('seq_tern_id'), 1, 4, 18),
  (NEXTVAL('seq_tern_id'), 9, 4, 18),

  (NEXTVAL('seq_tern_id'), 1, 4, 19),
  (NEXTVAL('seq_tern_id'), 8, 4, 19),

  (NEXTVAL('seq_tern_id'), 1, 4, 20),
  (NEXTVAL('seq_tern_id'), 11, 4, 20),
  (NEXTVAL('seq_tern_id'), 2, 4, 20),
  (NEXTVAL('seq_tern_id'), 6, 4, 20),

  (NEXTVAL('seq_tern_id'), 1, 4, 21),
  (NEXTVAL('seq_tern_id'), 5, 4, 21),
  (NEXTVAL('seq_tern_id'), 3, 4, 21),
  (NEXTVAL('seq_tern_id'), 6, 4, 21),

  (NEXTVAL('seq_tern_id'), 1, 4, 22),
  (NEXTVAL('seq_tern_id'), 7, 4, 22),
  (NEXTVAL('seq_tern_id'), 8, 4, 22),

  (NEXTVAL('seq_tern_id'), 1, 4, 23),
  (NEXTVAL('seq_tern_id'), 8, 4, 23),
  (NEXTVAL('seq_tern_id'), 10, 4, 23),
  (NEXTVAL('seq_tern_id'), 6, 4, 23),

  (NEXTVAL('seq_tern_id'), 1, 4, 24),
  (NEXTVAL('seq_tern_id'), 2, 4, 24),
  (NEXTVAL('seq_tern_id'), 6, 4, 24),
  (NEXTVAL('seq_tern_id'), 5, 4, 24),
  (NEXTVAL('seq_tern_id'), 4, 4, 24),
  (NEXTVAL('seq_tern_id'), 7, 4, 24),
  (NEXTVAL('seq_tern_id'), 8, 4, 24),
  (NEXTVAL('seq_tern_id'), 11, 4, 24),

  (NEXTVAL('seq_tern_id'), 1, 5, 25),
  (NEXTVAL('seq_tern_id'), 10, 5, 25),
  (NEXTVAL('seq_tern_id'), 4, 5, 25),

  (NEXTVAL('seq_tern_id'), 1, 5, 26),
  (NEXTVAL('seq_tern_id'), 3, 5, 26),
  (NEXTVAL('seq_tern_id'), 2, 5, 26),

  (NEXTVAL('seq_tern_id'), 1, 5, 27),
  (NEXTVAL('seq_tern_id'), 6, 5, 27),
  (NEXTVAL('seq_tern_id'), 7, 5, 27),

  (NEXTVAL('seq_tern_id'), 1, 5, 28),
  (NEXTVAL('seq_tern_id'), 3, 5, 28),
  (NEXTVAL('seq_tern_id'), 8, 5, 28),

  (NEXTVAL('seq_tern_id'), 1, 5, 29),
  (NEXTVAL('seq_tern_id'), 11, 5, 29),
  (NEXTVAL('seq_tern_id'), 8, 5, 29),

  (NEXTVAL('seq_tern_id'), 1, 5, 30),
  (NEXTVAL('seq_tern_id'), 10, 5, 30),
  (NEXTVAL('seq_tern_id'), 8, 5, 30),
  (NEXTVAL('seq_tern_id'), 6, 5, 30),

  (NEXTVAL('seq_tern_id'), 1, 6, 31),
  (NEXTVAL('seq_tern_id'), 6, 6, 31),
  (NEXTVAL('seq_tern_id'), 7, 6, 31),

  (NEXTVAL('seq_tern_id'), 1, 6, 32),
  (NEXTVAL('seq_tern_id'), 2, 6, 32),
  (NEXTVAL('seq_tern_id'), 4, 6, 32),

  (NEXTVAL('seq_tern_id'), 1, 6, 33),
  (NEXTVAL('seq_tern_id'), 4, 6, 33),
  (NEXTVAL('seq_tern_id'), 8, 6, 33),
  (NEXTVAL('seq_tern_id'), 3, 6, 33),

  (NEXTVAL('seq_tern_id'), 1, 6, 34),
  (NEXTVAL('seq_tern_id'), 4, 6, 34),
  (NEXTVAL('seq_tern_id'), 6, 6, 34),

  (NEXTVAL('seq_tern_id'), 1, 7, 35),
  (NEXTVAL('seq_tern_id'), 8, 7, 35),
  (NEXTVAL('seq_tern_id'), 11, 7, 35),

  (NEXTVAL('seq_tern_id'), 1, 8, 36),
  (NEXTVAL('seq_tern_id'), 10, 8, 36),
  (NEXTVAL('seq_tern_id'), 8, 8, 36),

  (NEXTVAL('seq_tern_id'), 1, 8, 37),
  (NEXTVAL('seq_tern_id'), 9, 8, 37),
  (NEXTVAL('seq_tern_id'), 10, 8, 37),

  (NEXTVAL('seq_tern_id'), 1, 8, 38),
  (NEXTVAL('seq_tern_id'), 11, 8, 38),
  (NEXTVAL('seq_tern_id'), 4, 8, 38),
  (NEXTVAL('seq_tern_id'), 2, 8, 38),

  (NEXTVAL('seq_tern_id'), 1, 8, 39),
  (NEXTVAL('seq_tern_id'), 3, 8, 39),
  (NEXTVAL('seq_tern_id'), 6, 8, 39),

  (NEXTVAL('seq_tern_id'), 1, 8, 40),
  (NEXTVAL('seq_tern_id'), 4, 8, 40),
  (NEXTVAL('seq_tern_id'), 7, 8, 40),

  (NEXTVAL('seq_tern_id'), 1, 8, 41),
  (NEXTVAL('seq_tern_id'), 11, 8, 41),
  (NEXTVAL('seq_tern_id'), 6, 8, 41),

  (NEXTVAL('seq_tern_id'), 1, 10, 42),
  (NEXTVAL('seq_tern_id'), 3, 10, 42),
  (NEXTVAL('seq_tern_id'), 4, 10, 42),

  (NEXTVAL('seq_tern_id'), 1, 10, 43),
  (NEXTVAL('seq_tern_id'), 10, 10, 43),
  (NEXTVAL('seq_tern_id'), 6, 10, 43),

  (NEXTVAL('seq_tern_id'), 1, 10, 44),
  (NEXTVAL('seq_tern_id'), 2, 10, 44),
  (NEXTVAL('seq_tern_id'), 5, 10, 44),

  (NEXTVAL('seq_tern_id'), 1, 11, 45),
  (NEXTVAL('seq_tern_id'), 3, 11, 45),
  (NEXTVAL('seq_tern_id'), 10, 11, 45),
  (NEXTVAL('seq_tern_id'), 8, 11, 45),

  (NEXTVAL('seq_tern_id'), 1, 11, 46),
  (NEXTVAL('seq_tern_id'), 11, 11, 46),
  (NEXTVAL('seq_tern_id'), 2, 11, 46),
  (NEXTVAL('seq_tern_id'), 3, 11, 46),

  (NEXTVAL('seq_tern_id'), 1, 12, 47),
  (NEXTVAL('seq_tern_id'), 2, 12, 47),
  (NEXTVAL('seq_tern_id'), 5, 12, 47),
  (NEXTVAL('seq_tern_id'), 4, 12, 47),

  (NEXTVAL('seq_tern_id'), 1, 12, 48),
  (NEXTVAL('seq_tern_id'), 3, 12, 48),
  (NEXTVAL('seq_tern_id'), 6, 12, 48),

  (NEXTVAL('seq_tern_id'), 1, 12, 49),
  (NEXTVAL('seq_tern_id'), 2, 12, 49),
  (NEXTVAL('seq_tern_id'), 7, 12, 49),

  (NEXTVAL('seq_tern_id'), 1, 13, 50),
  (NEXTVAL('seq_tern_id'), 6, 13, 50),
  (NEXTVAL('seq_tern_id'), 5, 13, 50),

  (NEXTVAL('seq_tern_id'), 1, 13, 51),
  (NEXTVAL('seq_tern_id'), 10, 13, 51),
  (NEXTVAL('seq_tern_id'), 3, 13, 51),
  (NEXTVAL('seq_tern_id'), 6, 13, 51),

  (NEXTVAL('seq_tern_id'), 1, 13, 52),
  (NEXTVAL('seq_tern_id'), 7, 13, 52),
  (NEXTVAL('seq_tern_id'), 8, 13, 52),

  (NEXTVAL('seq_tern_id'), 1, 14, 53),
  (NEXTVAL('seq_tern_id'), 8, 14, 53),
  (NEXTVAL('seq_tern_id'), 9, 14, 53),

  (NEXTVAL('seq_tern_id'), 1, 14, 54),
  (NEXTVAL('seq_tern_id'), 8, 14, 54),
  (NEXTVAL('seq_tern_id'), 5, 14, 54),

  (NEXTVAL('seq_tern_id'), 1, 14, 55),
  (NEXTVAL('seq_tern_id'), 6, 14, 55),
  (NEXTVAL('seq_tern_id'), 8, 14, 55),

  (NEXTVAL('seq_tern_id'), 1, 14, 56),
  (NEXTVAL('seq_tern_id'), 8, 14, 56),
  (NEXTVAL('seq_tern_id'), 3, 14, 56),
  (NEXTVAL('seq_tern_id'), 5, 14, 56),

  (NEXTVAL('seq_tern_id'), 1, 15, 57),
  (NEXTVAL('seq_tern_id'), 2, 15, 57),
  (NEXTVAL('seq_tern_id'), 7, 15, 57),

  (NEXTVAL('seq_tern_id'), 1, 16, 58),
  (NEXTVAL('seq_tern_id'), 4, 16, 58),
  (NEXTVAL('seq_tern_id'), 6, 16, 58),

  (NEXTVAL('seq_tern_id'), 1, 16, 59),
  (NEXTVAL('seq_tern_id'), 8, 16, 59),
  (NEXTVAL('seq_tern_id'), 2, 16, 59),

  (NEXTVAL('seq_tern_id'), 1, 16, 60),
  (NEXTVAL('seq_tern_id'), 8, 16, 60),
  (NEXTVAL('seq_tern_id'), 9, 16, 60),
  (NEXTVAL('seq_tern_id'), 4, 16, 60),
  (NEXTVAL('seq_tern_id'), 3, 16, 60),

  (NEXTVAL('seq_tern_id'), 1, 17, 61),
  (NEXTVAL('seq_tern_id'), 2, 17, 61),
  (NEXTVAL('seq_tern_id'), 3, 17, 61),
  (NEXTVAL('seq_tern_id'), 8, 17, 61),

  (NEXTVAL('seq_tern_id'), 1, 17, 62),
  (NEXTVAL('seq_tern_id'), 7, 17, 62),
  (NEXTVAL('seq_tern_id'), 6, 17, 62),

  (NEXTVAL('seq_tern_id'), 1, 17, 63),
  (NEXTVAL('seq_tern_id'), 2, 17, 63),
  (NEXTVAL('seq_tern_id'), 3, 17, 63),
  (NEXTVAL('seq_tern_id'), 5, 17, 63)
;




