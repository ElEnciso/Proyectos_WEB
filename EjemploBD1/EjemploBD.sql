CREATE DATABASE ejemploBD;
USE ejemploBD;

-- =======================================================
-- CREACIÓN DE TABLAS BASADAS EN EL DIAGRAMA E-R
-- =======================================================

-- 1. EMPRESAS (Se crea primero al ser independiente ahora)
CREATE TABLE empresas (
    idEmpresa INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL
);

-- 2. ALIADOS (Relación recursiva Empresa-Empresa manteniendo nombres clave)
CREATE TABLE aliados (
    idAliado INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    idEmpresa1 INT NOT NULL,
    idEmpresa2 INT NOT NULL,
    tipo_alianza VARCHAR(100) NOT NULL,
    FOREIGN KEY (idEmpresa1) REFERENCES empresas(idEmpresa),
    FOREIGN KEY (idEmpresa2) REFERENCES empresas(idEmpresa)
);

-- 3. CLIENTES
CREATE TABLE clientes (
    idCliente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50),
    idEmpresa INT NOT NULL,
    FOREIGN KEY (idEmpresa) REFERENCES empresas(idEmpresa)
);

-- 4. EVENTOS
CREATE TABLE eventos (
    idEvento INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    tipo_evento VARCHAR(50) NOT NULL,
    horario VARCHAR(20) NOT NULL
);

-- 5. EDICIONES
CREATE TABLE ediciones (
    idEdicion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    sede VARCHAR(100) NOT NULL,
    idEvento INT NOT NULL,
    FOREIGN KEY (idEvento) REFERENCES eventos(idEvento)
);

-- 6. PATROCINAN
CREATE TABLE patrocinan (
    idEmpresa INT NOT NULL,
    idEdicion INT NOT NULL,
    PRIMARY KEY (idEmpresa, idEdicion),
    FOREIGN KEY (idEmpresa) REFERENCES empresas(idEmpresa),
    FOREIGN KEY (idEdicion) REFERENCES ediciones(idEdicion)
);

-- 7. HISTORIAL ACADÉMICO
CREATE TABLE historial_academico (
    idHistorial INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    institucion VARCHAR(100) NOT NULL,
    fecha_graduacion DATE NOT NULL
);

-- 8. ÁREAS
CREATE TABLE areas (
    idArea INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- 9. PONENTES
CREATE TABLE ponentes (
    idPonente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50),
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    idHistorial INT NOT NULL,
    FOREIGN KEY (idHistorial) REFERENCES historial_academico(idHistorial)
);

-- 10. ESPECIALIZA
CREATE TABLE especializa (
    idPonente INT NOT NULL,
    idArea INT NOT NULL,
    PRIMARY KEY (idPonente, idArea),
    FOREIGN KEY (idPonente) REFERENCES ponentes(idPonente),
    FOREIGN KEY (idArea) REFERENCES areas(idArea)
);

-- 11. PRESENTA
CREATE TABLE presenta (
    idPonente INT NOT NULL,
    idEvento INT NOT NULL,
    PRIMARY KEY (idPonente, idEvento),
    FOREIGN KEY (idPonente) REFERENCES ponentes(idPonente),
    FOREIGN KEY (idEvento) REFERENCES eventos(idEvento)
);

-- 12. ARTÍCULOS
CREATE TABLE articulos (
    idArticulo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    titulo_ingles VARCHAR(100) NOT NULL,
    titulo_espanol VARCHAR(100) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    abstract_ingles TEXT NOT NULL,
    abstract_espanol TEXT NOT NULL,
    idEdicion INT NOT NULL,
    FOREIGN KEY (idEdicion) REFERENCES ediciones(idEdicion)
);

-- 13. AUTORES
CREATE TABLE autores (
    idAutor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50),
    correo VARCHAR(100) NOT NULL
);

-- 14. ESCRIBEN
CREATE TABLE escriben (
    idArticulo INT NOT NULL,
    idAutor INT NOT NULL,
    PRIMARY KEY (idArticulo, idAutor),
    FOREIGN KEY (idArticulo) REFERENCES articulos(idArticulo),
    FOREIGN KEY (idAutor) REFERENCES autores(idAutor)
);

-- Triggers 
DELIMITER $

CREATE TRIGGER ValidarFechaArticulo
BEFORE INSERT ON articulos
FOR EACH ROW
BEGIN
    IF NEW.fecha_publicacion > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La fecha de publicación no puede ser una fecha futura.';
    END IF;
END $

DELIMITER ;

CREATE TABLE IF NOT EXISTS log_cambios_articulos (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    idArticulo INT NOT NULL,
    idEdicion_anterior INT,
    idEdicion_nueva INT,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_bd VARCHAR(100) NOT NULL
);

-- 2. Instalamos el Trigger que vigila la tabla articulos
DELIMITER //

DROP TRIGGER IF EXISTS trg_auditoria_articulos //

CREATE TRIGGER trg_auditoria_articulos
AFTER UPDATE ON articulos
FOR EACH ROW
BEGIN
    IF OLD.idEdicion != NEW.idEdicion THEN
        INSERT INTO log_cambios_articulos (
            idArticulo, 
            idEdicion_anterior, 
            idEdicion_nueva, 
            usuario_bd
        )
        VALUES (
            OLD.idArticulo, 
            OLD.idEdicion, 
            NEW.idEdicion, 
            USER()
        );
    END IF;
END //

DELIMITER ;

DELIMITER ;

DELIMITER ;

-- =======================================
-- SECCIÓN DE INSERCIÓN DE DATOS DE PRUEBA
-- =======================================

-- 1. EMPRESAS (Información real de Singularity)
INSERT INTO empresas (nombre, correo, telefono) VALUES 
('Deloitte', 'contacto@deloitte.com.mx', '5550000001'), ('KIO Networks', 'info@kionetworks.com', '5550000002'),
('Expansión', 'contacto@expansion.mx', '5550000003'), ('Arbomex', 'ventas@arbomex.com', '5550000004'),
('Rackspace Technology', 'soporte@rackspace.com', '5550000005'), ('Terra', 'contacto@terra.com.mx', '5550000006'),
('Tresalia Capital', 'info@tresalia.com', '5550000007'), ('Bayer', 'contacto@bayer.com.mx', '5550000008'),
('GNP Seguros', 'atencion@gnp.com.mx', '5550000009'), ('Universidad Panamericana', 'informes@up.edu.mx', '5550000010'),
('Coursera', 'partners@coursera.org', '5550000011'), ('Oracle', 'contacto@oracle.com', '5550000012'),
('GBM', 'inversiones@gbm.com', '5550000013'), ('CompuSoluciones', 'info@compusoluciones.com', '5550000014'),
('Nestlé', 'contacto@nestle.com.mx', '5550000015'), ('Fortinet', 'ventas_mx@fortinet.com', '5550000016'),
('DocuSign', 'latam@docusign.com', '5550000017'), ('Televisa', 'contacto@televisa.com.mx', '5550000018'),
('Santander', 'empresas@santander.com.mx', '5550000019'), ('PepsiCo', 'contacto@pepsico.com.mx', '5550000020'),
('Coca-Cola', 'hola@coca-cola.mx', '5550000021'), ('Profuturo', 'contacto@profuturo.mx', '5550000022'),
('Banorte', 'contacto@banorte.com', '5550000023'), ('Rappi', 'aliados@rappi.com', '5550000024'),
('WeWork', 'mexico@wework.com', '5550000025'), ('Tecnológico de Monterrey', 'informes@tec.mx', '5550000026'),
('Alestra', 'ventas@alestra.mx', '5550000027'), ('Cinépolis Klic', 'ayuda@cinepolisklic.com', '5550000028'),
('UnoCero', 'contacto@unocero.com', '5550000029'), ('IOS Offices', 'contacto@iosoffices.com', '5550000030');

-- 2. ALIADOS (Cruces estratégicos reales basados en los IDs de arriba)
INSERT INTO aliados (idEmpresa1, idEmpresa2, tipo_alianza) VALUES 
(23, 24, 'Joint Venture Financiero (RappiCard)'), (11, 26, 'Socio Académico Universitario'),
(1, 12, 'Socio de Integración Cloud'), (2, 16, 'Proveedor de Ciberseguridad'),
(12, 5, 'Alianza de Infraestructura Nube'), (19, 24, 'Pasarela de Pagos Preferente'),
(20, 21, 'Acuerdo de Distribución Logística'), (25, 30, 'Co-working y Espacios Flexibles'),
(29, 28, 'Alianza de Difusión y Media'), (14, 12, 'Distribuidor Mayorista Autorizado'),
(2, 27, 'Interconexión de Centros de Datos'), (1, 7, 'Asesoría de Inversión Estratégica'),
(8, 15, 'Desarrollo de Nutrición Científica'), (9, 22, 'Paquete de Previsión Integral'),
(10, 26, 'Intercambio de Investigación'), (13, 19, 'Sindicación de Créditos Corporativos'),
(17, 3, 'Digitalización de Procesos Editoriales'), (18, 29, 'Contenido Tecnológico Conjunto'),
(4, 6, 'Automatización de Procesos Industriales'), (1, 2, 'Consultoría de Transformación Digital'),
(12, 26, 'Laboratorio de Innovación Tecnológica'), (16, 27, 'Seguridad Administrada en Redes'),
(19, 23, 'Red de Cajeros Compartidos'), (15, 20, 'Estrategia de Puntos de Venta'),
(21, 25, 'Patrocinio de Bebidas en Espacios'), (11, 10, 'Plataforma de Educación Continua'),
(5, 14, 'Soluciones Cloud Administradas'), (3, 18, 'Alianza Comercial de Medios'),
(7, 13, 'Fondo de Inversión Tecnológica'), (6, 17, 'Firma Electrónica en Plataformas');

-- 3. CLIENTES
-- 3. CLIENTES (Nombres realistas y variados)
INSERT INTO clientes (nombre, apellido_paterno, apellido_materno, idEmpresa) VALUES 
('Saul Ascencion', 'Cruz', 'Mendoza', 1),
('Carlos Enrique', 'Flores', 'González', 2),
('Lenin Adeliz', 'Herrera', 'Escogido', 3),
('Devin', 'Landeros', 'Chávez', 4),
('Mauro Alfredo', 'Enciso', 'Galaz', 5),
('Valeria', 'Rodríguez', 'Sánchez', 6),
('Diego', 'García', 'López', 7),
('María José', 'Martínez', 'Pérez', 8),
('Alejandro', 'Hernández', 'Gómez', 9),
('Ana Sofía', 'Díaz', 'Torres', 10),
('Luis Ángel', 'Vázquez', 'Ramírez', 11),
('Daniela', 'Jiménez', 'Cruz', 12),
('Santiago', 'Ruiz', 'Ortiz', 13),
('Camila', 'Álvarez', 'Morales', 14),
('Miguel Arturo', 'Rojas', 'Castillo', 15),
('Fernanda', 'Domínguez', 'Reyes', 16),
('Mateo', 'Gutiérrez', 'Aguilar', 17),
('Ximena', 'Mendoza', 'Vargas', 18),
('Sebastián', 'Chávez', 'Romero', 19),
('Regina', 'Herrera', 'Medina', 20),
('Leonardo', 'Guzmán', 'Cortés', 21),
('Mariana', 'Muñoz', 'Navarro', 22),
('Emiliano', 'Salazar', 'Ramos', 23),
('Andrea', 'Soto', 'Delgado', 24),
('Nicolás', 'Luna', 'Campos', 25),
('Lucía', 'Peña', 'Vega', 26),
('Gabriel', 'Ríos', 'Guerrero', 27),
('Paula', 'Navarro', 'Ríos', 28),
('Adrián', 'Cervantes', 'Soto', 29),
('Natalia', 'Pacheco', 'Lara', 30);

-- 4. EVENTOS
-- 4. EVENTOS (Nombres realistas de tecnología e innovación)
INSERT INTO eventos (nombre, fecha, tipo_evento, horario) VALUES 
('Congreso de Inteligencia Artificial', '2026-01-10', 'Congreso', '09:00 - 14:00'), 
('Simposio de Ciberseguridad Avanzada', '2026-02-15', 'Simposio', '10:00 - 18:00'),
('Taller de Desarrollo Web Full Stack', '2026-03-20', 'Taller', '08:00 - 12:00'), 
('Congreso de Innovación Tecnológica', '2026-04-05', 'Congreso', '09:00 - 14:00'),
('Simposio de Computación Cuántica', '2026-05-12', 'Simposio', '10:00 - 18:00'), 
('Taller de Arquitectura Cloud', '2026-06-18', 'Taller', '08:00 - 12:00'),
('Congreso Nacional de Ingeniería', '2026-07-22', 'Congreso', '09:00 - 14:00'), 
('Simposio de Realidad Virtual y Aumentada', '2026-08-30', 'Simposio', '10:00 - 18:00'),
('Taller de DevOps y CI/CD', '2026-09-10', 'Taller', '08:00 - 12:00'), 
('Congreso de Robótica Autónoma', '2026-10-15', 'Congreso', '09:00 - 14:00'),
('Simposio de Big Data y Analítica', '2026-11-20', 'Simposio', '10:00 - 18:00'), 
('Taller Práctico de IoT', '2026-12-05', 'Taller', '08:00 - 12:00'),
('Congreso de Bioinformática', '2027-01-10', 'Congreso', '09:00 - 14:00'), 
('Simposio de Tecnologías Emergentes', '2027-02-15', 'Simposio', '10:00 - 18:00'),
('Taller de Sistemas Embebidos', '2027-03-20', 'Taller', '08:00 - 12:00'), 
('Congreso de Creadores de Videojuegos', '2027-04-05', 'Congreso', '09:00 - 14:00'),
('Simposio de Animación 3D', '2027-05-12', 'Simposio', '10:00 - 18:00'), 
('Taller de Diseño UX/UI', '2027-06-18', 'Taller', '08:00 - 12:00'),
('Congreso Latinoamericano de Blockchain', '2027-07-22', 'Congreso', '09:00 - 14:00'), 
('Simposio de Liderazgo Femenino en TI', '2027-08-30', 'Simposio', '10:00 - 18:00'),
('Taller de Gestión de Proyectos Ágiles', '2027-09-10', 'Taller', '08:00 - 12:00'), 
('Congreso de Transformación Digital', '2027-10-15', 'Congreso', '09:00 - 14:00'),
('Simposio de Ética en la IA', '2027-11-20', 'Simposio', '10:00 - 18:00'), 
('Taller de Redes Neuronales', '2027-12-05', 'Taller', '08:00 - 12:00'),
('Congreso Nacional de Software Open Source', '2028-01-10', 'Congreso', '09:00 - 14:00'), 
('Simposio de Hardware Abierto', '2028-02-15', 'Simposio', '10:00 - 18:00'),
('Taller de Desarrollo Móvil', '2028-03-20', 'Taller', '08:00 - 12:00'), 
('Congreso de Ciberdefensa', '2028-04-05', 'Congreso', '09:00 - 14:00'),
('Simposio de Sistemas Distribuidos', '2028-05-12', 'Simposio', '10:00 - 18:00'), 
('Taller de Machine Learning Práctico', '2028-06-18', 'Taller', '08:00 - 12:00');

-- 5. EDICIONES (Fechas sincronizadas con los eventos y sedes reales de México)
INSERT INTO ediciones (fecha, sede, idEvento) VALUES 
('2026-01-10', 'Centro Citibanamex, CDMX', 1), 
('2026-02-15', 'Expo Guadalajara, Jalisco', 2), 
('2026-03-20', 'Auditorio Principal ESCOM', 3),
('2026-04-05', 'Cintermex, Monterrey', 4), 
('2026-05-12', 'WTC Ciudad de México', 5), 
('2026-06-18', 'Poliforum León, Guanajuato', 6),
('2026-07-22', 'Centro de Convenciones Puebla', 7), 
('2026-08-30', 'Expo Chihuahua', 8), 
('2026-09-10', 'Centro Cultural Jaime Torres Bodet', 9),
('2026-10-15', 'Centro de Congresos Querétaro', 10), 
('2026-11-20', 'Auditorio Telmex, Guadalajara', 11), 
('2026-12-05', 'Centro de Innovación BBVA', 12),
('2027-01-10', 'Campus Tecnológico de Monterrey', 13), 
('2027-02-15', 'Expo Santa Fe México', 14), 
('2027-03-20', 'Auditorio Nacional, CDMX', 15),
('2027-04-05', 'Pabellón M, Monterrey', 16), 
('2027-05-12', 'Centro Convenciones Mérida', 17), 
('2027-06-18', 'Foro Sol (Estadio GNP), CDMX', 18),
('2027-07-22', 'Arena Ciudad de México', 19), 
('2027-08-30', 'Baja California Center, Tijuana', 20), 
('2027-09-10', 'Auditorio Santander', 21),
('2027-10-15', 'Expo Forum Hermosillo', 22), 
('2027-11-20', 'Foro Boca, Veracruz', 23), 
('2027-12-05', 'Laboratorio de IA Oracle', 24),
('2028-01-10', 'Centro de Convenciones Cancún', 25), 
('2028-02-15', 'Centro de Convenciones San Luis Potosí', 26), 
('2028-03-20', 'Sala de Conferencias KIO Networks', 27),
('2028-04-05', 'Hotel Presidente InterContinental', 28), 
('2028-05-12', 'Centro de Convenciones Aguascalientes', 29), 
('2028-06-18', 'Centro Banamex Sala A', 30);

-- 6. PATROCINAN
INSERT INTO patrocinan (idEmpresa, idEdicion) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
(21, 21), (22, 22), (23, 23), (24, 24), (25, 25), (26, 26), (27, 27), (28, 28), (29, 29), (30, 30);

-- 7. HISTORIAL ACADÉMICO (Títulos y universidades reales de prestigio en tecnología)
INSERT INTO historial_academico (titulo, institucion, fecha_graduacion) VALUES 
('Doctorado en Ciencias de la Computación', 'Instituto Politécnico Nacional (IPN)', '2015-06-30'),
('Maestría en Inteligencia Artificial', 'Tecnológico de Monterrey (ITESM)', '2018-12-15'),
('Ingeniería en Sistemas Computacionales', 'Escuela Superior de Cómputo (ESCOM) - IPN', '2016-06-30'),
('Ph.D. in Machine Learning', 'Massachusetts Institute of Technology (MIT)', '2020-05-15'),
('Maestría en Tecnologías de la Información', 'Instituto Tecnológico Autónomo de México (ITAM)', '2016-08-10'),
('Licenciatura en Ciencias de la Computación', 'Universidad de Guadalajara (UdeG)', '2014-07-25'),
('Ingeniería en Software', 'Universidad Autónoma Metropolitana (UAM)', '2019-11-20'),
('Doctorado en Robótica', 'Stanford University', '2021-06-10'),
('Maestría en Ciberseguridad', 'Universidad Panamericana', '2017-12-05'),
('Ingeniería en Comunicaciones y Electrónica', 'Escuela Superior de Ingeniería Mecánica y Eléctrica (ESIME) - IPN', '2014-08-15'),
('Ph.D. in Data Science', 'Carnegie Mellon University', '2022-05-20'),
('Maestría en Innovación y Desarrollo', 'Tecnológico de Monterrey (ITESM)', '2015-11-30'),
('Ingeniería en Computación', 'Universidad Nacional Autónoma de México (UNAM)', '2010-06-15'),
('Doctorado en Bioinformática', 'Harvard University', '2019-05-25'),
('Licenciatura en Tecnologías de la Información', 'Universidad Iberoamericana', '2018-07-10'),
('Maestría en Dirección de Proyectos', 'Universidad Anáhuac', '2016-12-15'),
('Maestría en Ciencias en Ingeniería de Cómputo', 'Centro de Investigación en Computación (CIC) - IPN', '2019-12-10'),
('Ph.D. in Human-Computer Interaction', 'University of California, Berkeley', '2020-12-10'),
('Maestría en Ingeniería de Software', 'Centro de Investigación en Matemáticas (CIMAT)', '2017-06-30'),
('Licenciatura en Informática', 'Universidad Autónoma de Nuevo León (UANL)', '2014-11-25'),
('Doctorado en Telecomunicaciones', 'Instituto Politécnico Nacional (IPN)', '2018-08-15'),
('Maestría en Negocios y Tecnología', 'ITAM', '2021-12-01'),
('Ph.D. in Computer Engineering', 'Georgia Institute of Technology', '2016-05-12'),
('Ingeniería en Inteligencia Artificial', 'Universidad de las Américas Puebla (UDLAP)', '2022-06-18'),
('Maestría en Internet de las Cosas', 'Tecnológico de Monterrey (ITESM)', '2019-12-10'),
('Licenciatura en Matemáticas Aplicadas', 'Universidad Nacional Autónoma de México (UNAM)', '2013-05-25'),
('Doctorado en Sistemas Distribuidos', 'University of Oxford', '2020-07-15'),
('Ingeniería en Desarrollo de Videojuegos', 'SAE Institute México', '2021-08-20'),
('Maestría en Computación Cuántica', 'Instituto Politécnico Nacional (IPN)', '2023-01-15'),
('Ph.D. in Artificial Intelligence', 'University of Cambridge', '2018-10-25');

-- 8. ÁREAS
INSERT INTO areas (nombre) VALUES 
('Desarrollo Web'), ('Redes'), ('Ciberseguridad'), ('Inteligencia Artificial'), ('Bases de Datos'),
('Desarrollo Móvil'), ('Big Data'), ('DevOps'), ('Sistemas Operativos'), ('Robótica'),
('Blockchain'), ('Realidad Virtual'), ('Computación Cuántica'), ('IoT'), ('Machine Learning'),
('Análisis de Datos'), ('Arquitectura de Software'), ('Testing'), ('Diseño UX/UI'), ('Bioinformática'),
('Hardware'), ('Sistemas Embebidos'), ('Gestión de Proyectos TI'), ('Computación en la Nube'), ('Automatización'),
('Visión Computacional'), ('Procesamiento de Lenguaje'), ('Animación 3D'), ('Videojuegos'), ('Ética en IA');

-- 9. PONENTES
-- 9. PONENTES (Directorio de expertos, académicos y líderes tecnológicos)
INSERT INTO ponentes (nombre, apellido_paterno, apellido_materno, correo, telefono, idHistorial) VALUES 
('Erika', 'Hernández', 'Rubio', 'ehernandez@ipn.mx', '5511223344', 1),
('Blanca', 'Treviño', 'De Vega', 'btrevino@softtek.mx', '5522334455', 2),
('Marcus', 'Dantus', 'Díaz', 'mdantus@startupmexico.com', '5533445566', 3),
('Ana Victoria', 'García', 'Álvarez', 'ana.garcia@victoria147.mx', '5544556677', 4),
('María Teresa', 'Arnal', 'Macho', 'mariate@stripe.com', '5555667788', 5),
('Ophelia', 'Pastrana', 'Ardila', 'contacto@opheliapastrana.com', '5566778899', 6),
('Adolfo', 'Babatz', 'Maza', 'ababatz@clip.mx', '5577889900', 7),
('Loreanne', 'García', 'Kavak', 'loreanne@kavak.com', '5588990011', 8),
('David', 'Geisen', 'Meyer', 'dgeisen@mercadolibre.com.mx', '5599001122', 9),
('Silvia', 'Dávila', 'Kreimerman', 'sdavila@danone.com', '5500112233', 10),
('Eduardo', 'Osuna', 'Osuna', 'eosuna@bbva.mx', '5512345678', 11),
('Carlos', 'García', 'Otal', 'cgarcia@kavak.com', '5523456789', 12),
('Begoña', 'Ortiz', 'Pérez', 'bortiz@aws.com', '5534567890', 13),
('Sergio', 'Furio', 'Gómez', 'sfurio@creditas.com', '5545678901', 14),
('Héctor', 'Cárdenas', 'López', 'hcardenas@conekta.com', '5556789012', 15),
('Ricardo', 'Weder', 'Silva', 'rweder@justo.mx', '5567890123', 16),
('Marlene', 'Garayzar', 'Flores', 'mgarayzar@stori.com', '5578901234', 17),
('Courtney', 'McColgan', 'Smith', 'courtney@runa.mx', '5589012345', 18),
('Gerry', 'Giacomán', 'Colmenero', 'gerry@clara.com', '5590123456', 19),
('Cristina', 'Junqueira', 'Lima', 'cjunqueira@nubank.com', '5501234567', 20),
('Hernán', 'Kazah', 'García', 'hkazah@kasekv.com', '5513579246', 21),
('Álvaro', 'Luque', 'Ruiz', 'aluque@avocados.com', '5524681357', 22),
('Enrique', 'Perezyera', 'Sánchez', 'eperezyera@microsoft.com', '5535792468', 23),
('Fernando', 'Valenzuela', 'Migoya', 'fvalenzuela@edtech.mx', '5546813579', 24),
('Guillermo', 'Torre', 'Amione', 'gtorre@tecsalud.mx', '5557924680', 25),
('Víctor', 'Gutiérrez', 'Martínez', 'vgutierrez@canieti.mx', '5568035791', 26),
('Vincent', 'Speranza', 'López', 'vsperanza@endeavor.org', '5579146802', 27),
('Carlos', 'Slim', 'Domit', 'cslim@gcarso.com', '5580257913', 28),
('Javier', 'Matuk', 'Vargas', 'jmatuk@unocero.com', '5591368024', 29),
('Aura', 'López', 'Castillo', 'aura@tecnologia.mx', '5502479135', 30);

-- 10. ESPECIALIZA
INSERT INTO especializa (idPonente, idArea) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
(21, 21), (22, 22), (23, 23), (24, 24), (25, 25), (26, 26), (27, 27), (28, 28), (29, 29), (30, 30);

-- 11. PRESENTA
INSERT INTO presenta (idPonente, idEvento) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
(21, 21), (22, 22), (23, 23), (24, 24), (25, 25), (26, 26), (27, 27), (28, 28), (29, 29), (30, 30);

-- 12. ARTÍCULOS
-- 12. ARTÍCULOS (Publicaciones y papers tecnológicos con abstracts bilingües)
INSERT INTO articulos (titulo_ingles, titulo_espanol, fecha_publicacion, abstract_ingles, abstract_espanol, idEdicion) VALUES 
('The Future of Quantum Computing', 'El Futuro de la Computación Cuántica', '2024-01-10', 'An overview of quantum supremacy and its implications for modern cryptography.', 'Una visión general de la supremacía cuántica y sus implicaciones para la criptografía moderna.', 1),
('AI Ethics in Healthcare', 'Ética de la IA en la Salud', '2024-02-05', 'Analyzing the moral dilemmas of implementing AI diagnostics in hospitals.', 'Análisis de los dilemas morales al implementar diagnósticos por IA en hospitales.', 2),
('Blockchain for Supply Chain', 'Blockchain para la Cadena de Suministro', '2024-03-20', 'Using decentralized ledgers to improve transparency in global logistics.', 'Uso de libros de contabilidad descentralizados para mejorar la transparencia logística.', 3),
('Cybersecurity in the IoT Era', 'Ciberseguridad en la Era del IoT', '2024-04-28', 'Vulnerability assessment of interconnected smart home devices.', 'Evaluación de vulnerabilidades en dispositivos domésticos inteligentes interconectados.', 4),
('Machine Learning for Predictive Maintenance', 'Machine Learning para Mantenimiento Predictivo', '2024-05-15', 'Predicting industrial machine failures using supervised learning models.', 'Predicción de fallas en maquinaria industrial usando modelos de aprendizaje supervisado.', 5),
('Advanced VHDL Implementations for Edge AI', 'Implementaciones Avanzadas de VHDL para IA en el Borde', '2024-06-10', 'Optimizing hardware description languages to deploy neural networks on FPGAs.', 'Optimización de lenguajes de descripción de hardware para desplegar redes neuronales en FPGAs.', 6),
('Optimizing SQL Queries in Distributed Databases', 'Optimización de Consultas SQL en Bases de Datos Distribuidas', '2024-07-22', 'Strategies for reducing latency and improving normalization in large-scale relational systems.', 'Estrategias para reducir la latencia y mejorar la normalización en sistemas relacionales a gran escala.', 7),
('Solving Differential Equations using Neural Networks', 'Resolución de Ecuaciones Diferenciales usando Redes Neuronales', '2024-08-18', 'Applying deep learning frameworks to solve complex Cauchy-Euler boundary problems.', 'Aplicación de marcos de aprendizaje profundo para resolver problemas complejos de frontera de Cauchy-Euler.', 8),
('Linux Kernel Customization for Embedded Systems', 'Personalización del Kernel de Linux para Sistemas Embebidos', '2024-09-05', 'Techniques for recompiling the Linux kernel to maximize efficiency in constrained IoT environments.', 'Técnicas de recompilación del kernel de Linux para maximizar la eficiencia en entornos IoT limitados.', 9),
('Cloud-Native Application Architectures', 'Arquitecturas de Aplicaciones Nativas en la Nube', '2024-10-12', 'A comparative study of microservices vs monolithic cloud deployments.', 'Estudio comparativo de despliegues en la nube usando microservicios frente a monolíticos.', 10),
('5G and the Future of Telecommunications', '5G y el Futuro de las Telecomunicaciones', '2024-11-01', 'Impact of 5G latency improvements on autonomous vehicle communication.', 'Impacto de las mejoras de latencia del 5G en la comunicación de vehículos autónomos.', 11),
('Augmented Reality in Education', 'Realidad Aumentada en la Educación', '2024-12-15', 'Evaluating student engagement through AR interactive learning modules.', 'Evaluación de la participación estudiantil a través de módulos interactivos de aprendizaje con RA.', 12),
('Deep Learning for Computer Vision', 'Aprendizaje Profundo para Visión Computacional', '2025-01-20', 'Improving facial recognition accuracy with convolutional neural networks.', 'Mejora de la precisión del reconocimiento facial con redes neuronales convolucionales.', 13),
('Smart City Infrastructure Planning', 'Planificación de Infraestructura para Ciudades Inteligentes', '2025-02-10', 'Data-driven approaches to optimize traffic flow and energy consumption.', 'Enfoques basados en datos para optimizar el flujo de tráfico y el consumo de energía.', 14),
('NLP in Customer Service', 'PLN en Servicio al Cliente', '2025-03-25', 'Deploying advanced language models to automate complex customer support tasks.', 'Despliegue de modelos de lenguaje avanzados para automatizar tareas complejas de soporte.', 15),
('Biometric Security Systems', 'Sistemas de Seguridad Biométrica', '2025-04-14', 'Evaluating the reliability of iris scanning versus fingerprint mapping.', 'Evaluación de la fiabilidad del escaneo de iris frente al mapeo de huellas dactilares.', 16),
('Autonomous Vehicle Navigation Algorithms', 'Algoritmos de Navegación para Vehículos Autónomos', '2025-05-30', 'Sensor fusion techniques combining LiDAR and visual data for self-driving cars.', 'Técnicas de fusión de sensores combinando LiDAR y datos visuales para coches autónomos.', 17),
('Renewable Energy Grid Integration', 'Integración de Energías Renovables en la Red Eléctrica', '2025-06-18', 'Managing fluctuations in solar and wind power output on smart grids.', 'Gestión de fluctuaciones en la producción de energía solar y eólica en redes inteligentes.', 18),
('Fintech Innovations in Latin America', 'Innovaciones Fintech en América Latina', '2025-07-22', 'The rise of digital banking and its impact on unbanked populations.', 'El auge de la banca digital y su impacto en las poblaciones no bancarizadas.', 19),
('Digital Twins in Manufacturing', 'Gemelos Digitales en la Manufactura', '2025-08-05', 'Creating virtual replicas of assembly lines to simulate process improvements.', 'Creación de réplicas virtuales de líneas de montaje para simular mejoras de procesos.', 20),
('Precision Agriculture using Drone Data', 'Agricultura de Precisión usando Datos de Drones', '2025-09-19', 'Using aerial imagery and AI to optimize crop yield and resource allocation.', 'Uso de imágenes aéreas e IA para optimizar el rendimiento de los cultivos y los recursos.', 21),
('Edge Computing for Real-Time Analytics', 'Edge Computing para Analítica en Tiempo Real', '2025-10-11', 'Processing data at the source to reduce bandwidth requirements in industrial networks.', 'Procesamiento de datos en la fuente para reducir los requisitos de ancho de banda en redes industriales.', 22),
('Data Privacy in the Age of AI', 'Privacidad de Datos en la Era de la IA', '2025-11-28', 'Regulatory challenges and technical solutions for protecting user information.', 'Desafíos regulatorios y soluciones técnicas para proteger la información del usuario.', 23),
('Evolution of E-commerce Platforms', 'Evolución de las Plataformas de Comercio Electrónico', '2025-12-14', 'Analyzing the shift towards headless commerce architectures.', 'Análisis del cambio hacia arquitecturas de comercio electrónico headless.', 24),
('Wearable Health Monitoring Devices', 'Dispositivos Vestibles para Monitoreo de Salud', '2026-01-02', 'Accuracy of consumer smartwatches in detecting cardiac arrhythmias.', 'Precisión de los relojes inteligentes de consumo en la detección de arritmias cardíacas.', 25),
('Space Exploration Technologies', 'Tecnologías de Exploración Espacial', '2026-02-15', 'Propulsion systems for deep space missions and satellite deployment.', 'Sistemas de propulsión para misiones en el espacio profundo y despliegue de satélites.', 26),
('Advances in Serverless Computing', 'Avances en Computación Serverless', '2026-03-20', 'Cost-benefit analysis of Function-as-a-Service (FaaS) for startups.', 'Análisis de costo-beneficio de la Función como Servicio (FaaS) para startups.', 27),
('Gamification in Corporate Training', 'Gamificación en el Entrenamiento Corporativo', '2026-04-10', 'Measuring knowledge retention rates using game-based learning platforms.', 'Medición de las tasas de retención de conocimientos mediante plataformas de aprendizaje basadas en juegos.', 28),
('Zero Trust Security Models', 'Modelos de Seguridad Zero Trust', '2026-05-05', 'Implementing "never trust, always verify" principles in enterprise networks.', 'Implementación de principios "nunca confíes, siempre verifica" en redes empresariales.', 29),
('The Metaverse and Virtual Economies', 'El Metaverso y las Economías Virtuales', '2026-05-22', 'Economic frameworks and digital asset ownership in immersive virtual worlds.', 'Marcos económicos y propiedad de activos digitales en mundos virtuales inmersivos.', 30);

-- 13. AUTORES (Combinación de ponentes, investigadores y académicos invitados)
INSERT INTO autores (nombre, apellido_paterno, apellido_materno, correo) VALUES 
('Erika', 'Hernández', 'Rubio', 'ehernandez@ipn.mx'),
('Blanca', 'Treviño', 'De Vega', 'btrevino@softtek.mx'),
('Marcus', 'Dantus', 'Díaz', 'mdantus@startupmexico.com'),
('Ana Victoria', 'García', 'Álvarez', 'ana.garcia@victoria147.mx'),
('Ophelia', 'Pastrana', 'Ardila', 'contacto@opheliapastrana.com'),
('David', 'Geisen', 'Meyer', 'dgeisen@mercadolibre.com.mx'),
('Eduardo', 'Osuna', 'Osuna', 'eosuna@bbva.mx'),
('Begoña', 'Ortiz', 'Pérez', 'bortiz@aws.com'),
('Fernando', 'Valenzuela', 'Migoya', 'fvalenzuela@edtech.mx'),
('Guillermo', 'Torre', 'Amione', 'gtorre@tecsalud.mx'),
('Víctor', 'Gutiérrez', 'Martínez', 'vgutierrez@canieti.mx'),
('Javier', 'Matuk', 'Vargas', 'jmatuk@unocero.com'),
('Aura', 'López', 'Castillo', 'aura@tecnologia.mx'),
('Arturo', 'Domínguez', 'Rojas', 'adominguez@unam.mx'),
('Sofía', 'Castillejos', 'Mendoza', 'scastillejos@itesm.mx'),
('Raúl', 'Alarcón', 'Gómez', 'ralarcon@uam.mx'),
('Patricia', 'Montes', 'de Oca', 'pmontes@ipn.mx'),
('Gilberto', 'Espinoza', 'Cárdenas', 'gespinoza@udg.mx'),
('Mónica', 'Valdés', 'Prieto', 'mvaldes@cinvestav.mx'),
('Roberto', 'Salinas', 'Ortiz', 'rsalinas@cimat.mx'),
('Carmen', 'Leal', 'Ruiz', 'cleal@itam.mx'),
('Hugo', 'Navarro', 'Fuentes', 'hnavarro@conacyt.mx'),
('Elena', 'Villalobos', 'Soto', 'evillalobos@up.edu.mx'),
('Ricardo', 'Macías', 'Blanco', 'rmacias@ibero.mx'),
('Teresa', 'Cárdenas', 'Pineda', 'tcardenas@uaemex.mx'),
('Óscar', 'Rivas', 'Lira', 'orivas@uanl.mx'),
('Natalia', 'Jiménez', 'Acosta', 'njimenez@udlap.mx'),
('Francisco', 'Dávila', 'Montero', 'fdavila@stanford.edu'),
('Laura', 'Beltrán', 'Núñez', 'lbeltran@mit.edu'),
('Luis', 'Herrera', 'Estrella', 'lherrera@cinvestav.mx');

-- 14. ESCRIBEN 
INSERT INTO escriben (idArticulo, idAutor) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20),
(21, 21), (22, 22), (23, 23), (24, 24), (25, 25), (26, 26), (27, 27), (28, 28), (29, 29), (30, 30);

-- SELECTS

SELECT 
    idArticulo, 
    titulo_espanol, 
    fecha_publicacion 
FROM articulos 
WHERE titulo_espanol LIKE '%IA%' 
   OR titulo_espanol LIKE '%Inteligencia%'
  AND fecha_publicacion BETWEEN '2026-01-01' AND '2026-12-31';
  
SELECT 
    idCliente, 
    nombre, 
    apellido_paterno 
FROM clientes 
WHERE idCliente BETWEEN 10 AND 25 
  AND apellido_paterno LIKE 'G%';

SELECT 
    nombre AS 'Nombre del Evento', 
    tipo_evento AS 'Formato', 
    fecha AS 'Día Programado', 
    horario 
FROM eventos 
WHERE nombre LIKE 'Taller%' 
  AND fecha BETWEEN '2026-07-01' AND '2026-12-31'
ORDER BY fecha ASC;

SELECT 
    nombre, 
    apellido_paterno, 
    correo 
FROM autores 
WHERE idAutor BETWEEN 1 AND 15 
  AND (correo LIKE '%.mx%' OR correo LIKE '%.edu%');

SELECT 
    CONCAT(p.nombre, ' ', p.apellido_paterno) AS 'Ponente',
    p.correo AS 'Contacto Corporativo',
    e.nombre AS 'Evento Asignado',
    e.fecha AS 'Fecha de Presentación'
FROM ponentes p
INNER JOIN presenta pre ON p.idPonente = pre.idPonente
INNER JOIN eventos e ON pre.idEvento = e.idEvento
WHERE p.correo NOT LIKE '%@gmail.com%' 
  AND p.correo NOT LIKE '%@hotmail.com%'
  AND e.fecha BETWEEN '2027-01-01' AND '2028-12-31'
ORDER BY e.fecha DESC;

-- VISTAS

CREATE VIEW agenda_eventos AS
SELECT 
    CONCAT(p.nombre, ' ', p.apellido_paterno, ' ', IFNULL(p.apellido_materno, '')) AS 'Ponente', 
    a.nombre AS 'Se especializa en...',
    h.titulo AS 'Título Académico',
    h.institucion AS 'Institución',
    e.nombre AS 'se presenta en...',
    ed.sede AS 'en la sede...',
    ed.fecha AS 'Con fecha de edición...'
FROM ponentes p 
INNER JOIN especializa es ON p.idPonente = es.idPonente 
INNER JOIN areas a ON es.idArea = a.idArea 
INNER JOIN historial_academico h ON p.idHistorial = h.idHistorial 
INNER JOIN presenta pre ON p.idPonente = pre.idPonente 
INNER JOIN eventos e ON e.idEvento = pre.idEvento 
INNER JOIN ediciones ed ON e.idEvento = ed.idEvento;

CREATE VIEW archivo_articulos AS
SELECT 
    art.titulo_ingles AS 'Título del artículo (IN)',
    art.titulo_espanol AS 'Título del artículo (ES)', 
    art.fecha_publicacion AS 'Fecha en que se publicó',
    CONCAT(au.nombre, ' ', au.apellido_paterno) AS 'Escrito por...', 
    e.nombre AS 'Presentado en el evento...',
    ed.fecha AS 'Con fecha de edición...',
    ed.sede AS 'Sede en...'
FROM articulos art 
INNER JOIN escriben esc ON art.idArticulo = esc.idArticulo 
INNER JOIN autores au ON esc.idAutor = au.idAutor 
INNER JOIN ediciones ed ON art.idEdicion = ed.idEdicion
INNER JOIN eventos e ON ed.idEvento = e.idEvento;

select * from archivo_articulos;

CREATE VIEW patrocinios AS
SELECT 
    em.nombre AS 'Empresa', 
    e.nombre AS 'Patrocina el evento...', 
    ed.fecha AS 'Fecha de la edición...', 
    ed.sede AS 'Sede en...'
FROM empresas em 
INNER JOIN patrocinan pat ON em.idEmpresa = pat.idEmpresa 
INNER JOIN ediciones ed ON pat.idEdicion = ed.idEdicion
INNER JOIN eventos e ON ed.idEvento = e.idEvento;

select * from patrocinios;

-- VISTAS PARA REPORTES Y CONSULTAS ESPECÍFICAS


CREATE VIEW reporte_eventos_edicion AS
SELECT 
    ed.idEdicion,
    ed.sede AS 'Sede_Edicion', 
    ed.fecha AS 'Fecha_Edicion', 
    COUNT(e.idEvento) AS 'Cantidad_Eventos'
FROM ediciones ed 
INNER JOIN eventos e ON ed.idEvento = e.idEvento 
GROUP BY ed.idEdicion, ed.sede, ed.fecha;

select * from reporte_eventos_edicion;

CREATE VIEW reporte_articulos_edicion AS
SELECT 
    ed.idEdicion,
    ed.sede AS 'Sede_Edicion', 
    ed.fecha AS 'Fecha_Edicion', 
    COUNT(art.idArticulo) AS 'Cantidad_Articulos'
FROM ediciones ed 
INNER JOIN articulos art ON ed.idEdicion = art.idEdicion 
GROUP BY ed.idEdicion, ed.sede, ed.fecha;

select * from reporte_articulos_edicion;

CREATE VIEW reporte_horarios_ponentes AS
SELECT 
    e.nombre AS 'Evento', 
    ed.sede AS 'Sede_Edicion', 
    ed.fecha AS 'Fecha_Edicion',
    CONCAT(p.nombre, ' ', p.apellido_paterno) AS 'Ponente', 
    e.horario AS 'Horario'                   
FROM ediciones ed 
INNER JOIN eventos e ON ed.idEvento = e.idEvento 
INNER JOIN presenta pre ON e.idEvento = pre.idEvento 
INNER JOIN ponentes p ON pre.idPonente = p.idPonente;

select * from reporte_horarios_ponentes;

CREATE VIEW reporte_historial_ponentes AS
SELECT 
    CONCAT(p.nombre, ' ', p.apellido_paterno) AS 'Ponente', 
    h.institucion AS 'Lugar_Estudios',
    h.titulo AS 'Titulo_Obtenido', 
    h.fecha_graduacion AS 'Fecha_Graduacion'
FROM ponentes p 
INNER JOIN historial_academico h ON p.idHistorial = h.idHistorial;

select * from reporte_historial_ponentes;

CREATE VIEW reporte_empresas_aliados AS
SELECT 
    a.idAliado AS 'ID_Alianza',
    e1.nombre AS 'Empresa_A', 
    e2.nombre AS 'Empresa_B', 
    a.tipo_alianza AS 'Tipo_Alianza'
FROM aliados a
INNER JOIN empresas e1 ON a.idEmpresa1 = e1.idEmpresa
INNER JOIN empresas e2 ON a.idEmpresa2 = e2.idEmpresa;

select * from reporte_empresas_aliados;

SELECT * FROM empresas;
SELECT * FROM aliados;
SELECT * FROM clientes;
SELECT * FROM eventos;
SELECT * FROM ediciones;
SELECT * FROM patrocinan;
SELECT * FROM historial_academico;
SELECT * FROM areas;
SELECT * FROM ponentes;
SELECT * FROM especializa;
SELECT * FROM presenta;
SELECT * FROM articulos;
SELECT * FROM autores;
SELECT * FROM escriben;

-- Procedures 
 delimiter #


create procedure RegistraArticulo (
in ar_tituloingles varchar (100),
in ar_tituloespanol varchar (100),
in ar_fechapubli date,
in ar_abstractingles text,
in ar_abstractespanol text,
in ar_idEdicion int)

begin
    insert into articulos (titulo_ingles,titulo_espanol,fecha_publicacion,abstract_ingles,abstract_espanol,idEdicion)
    values (ar_tituloingles,ar_tituloespanol,ar_fechapubli,ar_abstractingles,ar_abstractespanol,ar_idEdicion);
end#

delimiter ; 

delimiter $

create procedure consultarAgendaporSede (in sedeBusq varchar (100))
begin
    select 
        e.idEvento, 
        e.nombre as 'Nombre del evento', 
        e.fecha as 'Fecha del evento', 
        e.horario as 'Horario del evento', 
        e.tipo_evento as 'Tipo de evento',
        ed.sede as 'Sede'
    from eventos e 
    inner join ediciones ed on e.idEvento = ed.idEvento
    where ed.sede like concat('%', sedeBusq, '%') 
    order by e.fecha, e.horario;
end$

delimiter ;

delimiter %

create procedure eliminaPonente ( in idPon int)
begin
    declare var_idHistorial int;
    
    start transaction;
    
    -- 1. Resguardamos el idHistorial antes de eliminar el registro del ponente
    select idHistorial into var_idHistorial from ponentes where idPonente = idPon;
    
    -- 2. Eliminamos las dependencias en las tablas intermedias muchos a muchos
    delete from presenta where idPonente = idPon;
    delete from especializa where idPonente = idPon;
    
    -- 3. Eliminamos el registro en la tabla ponentes
    delete from ponentes where idPonente = idPon;
    
    -- 4. Ahora que ya no hay llaves apuntando al historial, lo borramos de forma segura
    if var_idHistorial is not null then
        delete from historial_academico where idHistorial = var_idHistorial;
    end if;
    
    commit;
end %

delimiter ;
CALL consultarAgendaporSede('Monterrey');
CALL RegistraArticulo('AI Horizons', 'Horizontes de IA', '2026-05-20', 'Abstract English', 'Resumen Español', 1);
CALL eliminaPonente(5);



show tables;