/* user_dimension */
/* create user_dimension table */
DROP TABLE IF EXISTS user_dimension;
CREATE TABLE user_dimension (
  user_id varchar(13) NOT NULL,
  user_nif varchar(9) NOT NULL,
  user_nome varchar(80) NOT NULL,
  user_telefone varchar(26) NOT NULL,
  PRIMARY KEY (user_id)
);

/* populate user_dimension */
INSERT INTO user_dimension
SELECT 
  concat('user',nif) as user_id,
  nif as user_nif,
  nome as user_nome,
  telefone as user_telefone
FROM user;

/* location_dimension */
/* create location_dimension table */
DROP TABLE IF EXISTS location_dimension;
CREATE TABLE location_dimension (
  location_id varchar(765) NOT NULL,
  morada varchar(255) NOT NULL,
  codigo_espaco varchar(255) NOT NULL,
  codigo_posto varchar(255),
  location_foto varchar(255),
  PRIMARY KEY (location_id)
);

/* populate location_dimension */
INSERT INTO location_dimension
SELECT
	concat(morada,codigo) as location_id,
  	morada,
  	codigo,
  	NULL,
  	foto
FROM espaco natural join alugavel;
UNION
SELECT
	concat(morada,codigo_espaco,codigo),
	morada,
	codigo_espaco,
	codigo,
	foto
FROM posto natural join alugavel;

/* date_dimension */
/* create date_dimension table */
DROP TABLE IF EXISTS date_dimension;
CREATE TABLE date_dimension (
  date_id    int(11) NOT NULL,
  date_time date DEFAULT NULL,
  
  date_year    int(11) DEFAULT NULL,
  semester    int(11) DEFAULT NULL,
  
  month_number   int(11) DEFAULT NULL,
  month_name  char(10) DEFAULT NULL,

  week_number    int(11) DEFAULT NULL,
  week_day_number    int(11) DEFAULT NULL,
  week_day_name char(10) DEFAULT NULL,
  PRIMARY KEY (date_id)
);

/* procedure to populate date_dimension */
DROP PROCEDURE IF EXISTS populate_date_dimension;
DELIMITER //
CREATE PROCEDURE populate_date_dimension()
  BEGIN
    SET @d0 = '2016-01-01';
    SET @d1 = '2017-12-31';
    SET @date = date_sub(@d0, INTERVAL 1 DAY);

    WHILE date_add(@date, INTERVAL 1 DAY) <= @d1 DO
      SET @date = date_add(@date, INTERVAL 1 DAY);
      IF quarter(@date) <= 2 THEN
        SET @semester = 1;
      ELSE
        SET @semester = 2;
      END IF;
      INSERT INTO date_dimension VALUES(
        date_format(@date, "%Y%m%d"),
        @date,
        year(@date),
        @semester,
        month(@date),
        monthname(@date),
        week(@date),
        day(@date),
        dayname(@date)
      );
    END WHILE;
  END //

CALL populate_date_dimension();

/* time_dimension */
/* create time_dimension table */
DROP TABLE IF EXISTS time_dimension;
CREATE TABLE time_dimension (
  time_id int(4) NOT NULL,
  time_of_day time NOT NULL,
  hour_of_day int(2) NOT NULL,

  minute_of_day int(4) NOT NULL,
  minute_of_hour int(2) NOT NULL,
  PRIMARY KEY (time_id)
);

/* procedure to populate time_dimension */
DROP PROCEDURE IF EXISTS populate_time_dimension;
DELIMITER //
CREATE PROCEDURE populate_time_dimension()
  BEGIN
    SET @t0 = '2016-11-11 00:00:00';
    SET @t1 = '2016-11-11 23:59:59';
    SET @time = date_sub(@t0, INTERVAL 1 MINUTE);
    WHILE date_add(@time, INTERVAL 1 MINUTE) <= @t1 DO
      SET @time = date_add(@time, INTERVAL 1 MINUTE);
      SET @minuteofday = ( hour(@time) * 60 ) + minute(@time) + 1;
      INSERT INTO time_dimension VALUES(
      	date_format(@time, "%H%i"),
      	@time,
      	hour(@time),
      	@minuteofday,
      	minute(@time)
      );
    END WHILE;
  END //

CALL populate_time_dimension();

/* reservas_info - facts table */
/* criar tabela reservas_info */
DROP TABLE IF EXISTS reservas_info;
CREATE TABLE reservas_info (
  reserva_id varchar(255) NOT NULL,
  user_id varchar(13) NOT NULL,
  location_id varchar(510) NOT NULL,
  time_id int(4) NOT NULL,
  date_id int(11) NOT NULL,
  montante_pago int NOT NULL,
  duracao int NOT NULL,
  PRIMARY KEY (reserva_id,time_id,date_id),
  FOREIGN KEY(time_id) REFERENCES time_dimension(time_id),
  FOREIGN KEY(date_id) REFERENCES date_dimension(date_id),
  FOREIGN KEY(location_id) REFERENCES location_dimension(location_id),
  FOREIGN KEY(user_id) REFERENCES user_dimension(user_id)
);

/* populate reservas_info */
INSERT INTO reservas_info
SELECT
  numero as reserva_id,
  concat('user',nif) as user_id,
  concat(morada,codigo) as location_id,
  date_format(data, "%H%i") as time_id,
  date_format(data, "%Y%m%d") as date_id,
  tarifa * (data_fim - data_inicio) as montante_pago,
  data_fim - data_inicio as duracao
FROM aluga NATURAL JOIN oferta NATURAL JOIN espaco NATURAL JOIN paga
UNION
SELECT
  numero as reserva_id,
  concat('user',nif) as user_id,
  concat(morada, codigo_espaco, codigo) as location_id,
  date_format(data, "%H%i") as time_id,
  date_format(data, "%Y%m%d") as date_id,
  tarifa * (data_fim - data_inicio) as montante_pago,
  data_fim - data_inicio as duracao
FROM aluga NATURAL JOIN oferta NATURAL JOIN posto NATURAL JOIN paga;
