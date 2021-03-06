USE touragency_db;

SET NAMES 'utf8';

INSERT INTO human VALUES
	(1, 'Иван', 'Иванов', '1980-01-23'), 
	(2, 'Алексей', 'Петров', '1990-03-14'), 
	(3, 'Сергей', 'Васильев', '1985-10-10'), 
	(4, 'Петр', 'Чернухин', '1971-05-24'), 
	(5, 'Милорад', 'Зайцев', '1969-11-07'), 
	(6, 'Юрий', 'Прокопьев', '1991-04-17'),
	(7, 'Акакий', 'Семенов', '1965-08-11'),
	(8, 'Полина', 'Шибаева', '1992-02-14'),
	(9, 'Анна', 'Карпова', '1989-06-15'),
	(10, 'Ирина', 'Черепахова', '1970-09-20'),
	(11, 'Валентина', 'Афанасьева', '1975-09-14'),
	(12, 'Мария', 'Фролова', '1999-01-08'),
	(13, 'Ольга', 'Павлова', '1968-10-20');

INSERT INTO countries VALUES
	(1, "Турция"),
	(2, "Грузия"),
	(3, "Китай"),
	(4, "Испания"),
	(5, "Италия"),
	(6, "Доминикана"),
	(7, "Мексика");

INSERT INTO tour_operator VALUES
	(1, "Анекс Тур"),
	(2, "Coral Travel"),
	(3, "FUN&SUN"),
	(4, "SUNMAR"),
	(5, "Алеан");

INSERT INTO travel_agencies VALUES
	(1, "Глобус-Тур", "Новосибирск"),
	(2, "Домашний отдых", "Москва"),
	(3, "Розовый слон", "Таганрог"),
	(4, "Иностранка", "Ростов-на-Дону"),
	(5, "Лагуна-Тур", "Саратов");

INSERT INTO tourmanager VALUES 
	(1, 1, 1),
	(2, 8, 2),
	(3, 6, 3);

INSERT INTO tour_client VALUES
	(1, 2),
	(2, 4),
	(3, 10),
	(4, 11),
	(5, 5);