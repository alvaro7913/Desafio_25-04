\c alvaro
DROP DATABASE biblioteca;
CREATE DATABASE biblioteca;
\c biblioteca

SET datestyle TO "DMY";
-- comienza la creación de tablas  / entidades  

-- tabla tipos de autor
CREATE TABLE tiposAutor(
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(20)
);

-- tabla autor
CREATE TABLE autor(
    tipo_id INT REFERENCES tiposAutor(id),
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(20),
    apellido VARCHAR(20),
    fecha_nac DATE,
    fecha_def DATE NULL
);

-- tabla libros
CREATE TABLE libros(
    isbn VARCHAR(20) PRIMARY KEY,
    autor_id INT REFERENCES autor(id),
    tipo_id INT REFERENCES tiposAutor(id),
    titulo VARCHAR(50),
    paginas SMALLINT,
    stock SMALLINT CHECK(stock >=0)
);

-- tabla comuna
CREATE TABLE comunas(
    id SERIAL PRIMARY KEY,
    comuna VARCHAR(20)
);

-- tabla de socios
CREATE TABLE socios(
    rut VARCHAR(12) PRIMARY KEY,
    comuna_id INT,
    nombre VARCHAR(20),
    apellido VARCHAR(20),
    dirección VARCHAR(50),
    telefono VARCHAR(20),
    FOREIGN KEY (comuna_id) REFERENCES comunas(id)
);

-- tabla prestamo
CREATE TABLE prestamos(
    id SERIAL PRIMARY KEY,
    rut_socio VARCHAR(12),
    isbn VARCHAR(15),
    fecha_inicio DATE,
    fecha_fin DATE CHECK(fecha_fin >= fecha_inicio),
    FOREIGN KEY (rut_socio) REFERENCES socios(rut),
    FOREIGN KEY (isbn) REFERENCES libros(isbn)
);

-- inicio de operación

INSERT INTO comunas(comuna)
VALUES ('Santiago');

INSERT INTO libros(isbn, titulo, paginas, stock)
VALUES ('111-1111111-111', 'CUENTOS DE TERROR', 344, 1);
INSERT INTO libros(isbn, titulo, paginas, stock)
VALUES ('222-2222222-222', 'POESÍAS CONTEMPORANEAS', 167, 1);
INSERT INTO libros(isbn, titulo, paginas, stock)
VALUES ('333-3333333-333', 'HISTORIA DE ASIA', 511, 1);
INSERT INTO libros(isbn, titulo, paginas, stock)
VALUES ('444-4444444-444', 'MANUAL DE MECÁNICA', 298, 1);

INSERT INTO autores(nombre, apellido, fecha_nac)
VALUES('ANDRÉS', 'ULLOA', '1/1/1982');
INSERT INTO autores(nombre, apellido, fecha_nac, fecha_def)
VALUES('SERGIO', 'MARDONES', '1/1/1950', '31/12/2012');
INSERT INTO autores(nombre, apellido, fecha_nac, fecha_def)
VALUES('JOSE', 'SALGADO', '1/1/1968', '31/12/2020');
INSERT INTO autores(nombre, apellido, fecha_nac)
VALUES('ANA', 'SALGADO', '1/1/1972');
INSERT INTO autores(nombre, apellido, fecha_nac)
VALUES('MARTIN', 'PORTA', '1/1/1976');

INSERT INTO tiposAutor(tipo)
VALUES('Principal');
INSERT INTO tiposAutor(tipo)
VALUES('Coautor');

INSERT INTO librosAutores(autor_id, tipo_id, isbn)
VALUES(1, 1, '222-2222222-222');
INSERT INTO librosAutores(autor_id, tipo_id, isbn)
VALUES(2, 1, '333-3333333-333');
INSERT INTO librosAutores(autor_id, tipo_id, isbn)
VALUES(3, 1, '111-1111111-111');
INSERT INTO librosAutores(autor_id, tipo_id, isbn)
VALUES(4, 2, '111-1111111-111');
INSERT INTO librosAutores(autor_id, tipo_id, isbn)
VALUES(5, 1, '444-4444444-444');

INSERT INTO socios(rut, comuna_Id, nombre, apellido, dirección, telefono)
VALUES ('1111111-1', 1, 'JUAN', 'SOTO', 'Avenida 1', '911111111');
INSERT INTO socios(rut, comuna_Id, nombre, apellido, dirección, telefono)
VALUES ('2222222-2', 1, 'ANA', 'PEREZ', 'Pasaje 2', '922222222');
INSERT INTO socios(rut, comuna_Id, nombre, apellido, dirección, telefono)
VALUES ('3333333-3', 1, 'SANDRA', 'AGUILAR', 'Avenida 2', '933333333');
INSERT INTO socios(rut, comuna_Id, nombre, apellido, dirección, telefono)
VALUES ('4444444-4', 1, 'ESTEBAN', 'JEREZ', 'Avenida 3', '944444444');
INSERT INTO socios(rut, comuna_Id, nombre, apellido, dirección, telefono)
VALUES ('5555555-5', 1, 'SILVANA', 'MUÑOZ', 'Pasaje 3', '955555555');

INSERT INTO prestamos(rut_socio, isbn, fecha_inicio, fecha_fin)
VALUES('1111111-1','111-1111111-111','20/1/2020','27/1/2020');
INSERT INTO prestamos(rut_socio, isbn, fecha_inicio, fecha_fin)
VALUES('5555555-5','222-2222222-222','20/1/2020','30/1/2020');
INSERT INTO prestamos(rut_socio, isbn, fecha_inicio, fecha_fin)
VALUES('3333333-3','333-3333333-333','22/1/2020','30/1/2020');
INSERT INTO prestamos(rut_socio, isbn, fecha_inicio, fecha_fin)
VALUES('4444444-4','444-4444444-444','23/1/2020','30/1/2020');
INSERT INTO prestamos(rut_socio, isbn, fecha_inicio, fecha_fin)
VALUES('2222222-2','111-1111111-111','27/1/2020','04/2/2020');
INSERT INTO prestamos(rut_socio, isbn, fecha_inicio, fecha_fin)
VALUES('1111111-1','444-4444444-444','31/1/2020','12/2/2020');
INSERT INTO prestamos(rut_socio, isbn, fecha_inicio, fecha_fin)
VALUES('3333333-3','222-2222222-222','31/1/2020','12/2/2020');

-- ACCIONES DEL DESAFIO
-- 3. Realizar las siguientes consultas:
-- a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)
SELECT
    l.isbn,
    l.titulo,
    l.paginas,
    a.id AS codAutor,
    a.nombre,
    a.apellido,
    CONCAT(CAST(EXTRACT(YEAR FROM a.fecha_nac) AS VARCHAR),'-',CAST(EXTRACT(YEAR FROM a.fecha_def) AS VARCHAR)) AS nac_muerte,
    ta.tipo AS tipoAutor
FROM
    libros AS l LEFT OUTER JOIN
    librosAutores AS la ON
    la.isbn = l.isbn LEFT OUTER JOIN
    autores AS a ON
    a.id = la.autor_id LEFT OUTER JOIN
    tiposAutor as ta ON
    ta.id = la.tipo_id
WHERE
    l.paginas < 300;
-- b. Mostrar todos los autores que hayan nacido después del 01-01-1970. (0.5 puntos)
SELECT
    a.nombre,
    a.apellido,
    a.fecha_nac,
    a.fecha_def
FROM
    autores AS a
WHERE
    a.fecha_nac>='01/01/1970';
-- c. ¿Cuál es el libro más solicitado? (0.5 puntos).
SELECT
    COUNT(p.isbn),
    p.isbn,
    l.titulo
FROM
    prestamos AS p LEFT OUTER JOIN
    libros as l ON
    l.isbn = p.isbn
GROUP BY
    p.isbn,
    l.titulo
ORDER BY
    COUNT(p.isbn) DESC LIMIT 1;
-- d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días. (0.5 puntos)
SELECT
    p.fecha_Inicio,
    p.fecha_fin,
    s.nombre,
    (p.fecha_fin-p.fecha_inicio)-7 AS atraso,
    ((p.fecha_fin-p.fecha_inicio)-7) * 100 AS multa
FROM
    prestamos AS p INNER JOIN
    socios AS s ON
    s.rut = p.rut_socio
WHERE
    p.fecha_fin-p.fecha_inicio > 7;