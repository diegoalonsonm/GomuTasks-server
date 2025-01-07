create database GomuTasks;

use database GomuTasks;

create table estado(
	idEstado int AUTO_INCREMENT PRIMARY KEY,
    nombre varchar(30) not null,
    descripcion varchar(100)
);

create table usuarios(
	idUsuario varchar(100) primary key,
    nombre varchar(100) not null,
    apellido1 varchar(100) not null,
    apellido2 varchar(100) not null,
    correo varchar(100) not null unique,
    contrasena varchar(20) not null,
    fechaCreacion datetime default current_timestamp,
    estado int,
    foreign key (estado) references estado (idEstado)
);

create table grupo(
	idGrupo varchar(100) primary key,
    nombre varchar(100) not null,
    descripcion text,
    fechaCreacion datetime default current_timestamp,
    idUsuarioCreador varchar(100),
    estado int,
    FOREIGN KEY (idUsuarioCreador) REFERENCES usuarios(idUsuario),
    foreign key (estado) references estado (idEstado)
);

create table usuariosGrupo(
	idUsuario varchar(100), 
    idGrupo varchar(100),
    fechaUnion datetime default current_timestamp,
    primary key (idUsuario, idGrupo),
    foreign key (idUsuario) references usuarios (idUsuario),
    foreign key (idGrupo) references grupo (idGrupo)
);

create table tareas(
	idTarea varchar(100) primary key,
    titulo varchar(100) not null,
    descripcion text, 
    fechaCreacion datetime DEFAULT current_timestamp,
    fechaVencimiento datetime,
    estado int not null,
    idGrupo varchar(100),
    estado int,
    foreign key (estado) REFERENCES estado (idEstado),
    foreign key (idGrupo) REFERENCES grupo (idGrupo),
    foreign key (estado) references estado (idEstado)
);

create table asignaciones(
	idAsignacion varchar(100) primary key,
    idTarea varchar(100),
    idUsuario varchar(100),
    fechaAsignacion datetime DEFAULT current_timestamp,
    estado int,
    FOREIGN KEY (idTarea) REFERENCES tareas (idTarea),
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario),
    foreign key (estado) references estado (idEstado)
);

-- INSERTS

-- estados
INSERT INTO estado (nombre, descripcion) VALUES
('Pendiente', 'La tarea aún no se ha iniciado'),
('En Progreso', 'La tarea está actualmente en progreso'),
('Completado', 'La tarea ha sido finalizada');

-- usuarios
INSERT INTO usuarios (nombre, apellido1, apellido2, correo, contrasena) VALUES
('Juan', 'Pérez', 'López', 'juan.perez@example.com', 'password123'),
('Ana', 'Martínez', 'García', 'ana.martinez@example.com', 'securepass'),
('Carlos', 'Hernández', 'Ruiz', 'carlos.hernandez@example.com', 'mypassword'),
('María', 'Gómez', 'Sánchez', 'maria.gomez@example.com', 'adminpass');

-- grupos
INSERT INTO grupo (nombre, descripcion, idUsuarioCreador) VALUES
('Equipo de Desarrollo', 'Grupo encargado del desarrollo de software', 'USU-100'),
('Equipo de Diseño', 'Grupo encargado del diseño gráfico', 'USU-101'),
('Administradores', 'Grupo de administradores del sistema', 'USU-103');

-- usuariosGrupo
INSERT INTO usuariosGrupo (idUsuario, idGrupo) VALUES
('USU-100', 'GRU-100'),
('USU-101', 'GRU-101'),
('USU-102', 'GRU-100'),
('USU-103', 'GRU-102');

-- tareas
INSERT INTO tareas (titulo, descripcion, fechaVencimiento, estado, idGrupo) VALUES
('Implementar Login', 'Desarrollar el módulo de autenticación de usuarios', '2025-01-20', 1, 'GRU-100'),
('Diseñar Logo', 'Crear un logo para la nueva campaña publicitaria', '2025-01-15', 2, 'GRU-101'),
('Configurar Servidor', 'Configurar el servidor de producción', '2025-01-25', 1, 'GRU-102'),
('Escribir Documentación', 'Escribir la documentación del proyecto', '2025-01-30', 3, 'GRU-100');

-- asignaciones
INSERT INTO asignaciones (idTarea, idUsuario) VALUES
('TAR-100', 'USU-100'), 
('TAR-101', 'USU-101'), 
('TAR-102', 'USU-103'), 
('TAR-103', 'USU-102'); 


-- TRIGGERS
-- trigger y secuencia para idUsuario
CREATE SEQUENCE seq_usuarios START WITH 100 INCREMENT BY 1 MINVALUE 100 NO MAXVALUE CACHE 10; 

DELIMITER //

CREATE TRIGGER trg_usuarios_before_insert
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    IF NEW.idUsuario IS NULL OR NEW.idUsuario = '' THEN SET @nuevoId = NEXTVAL(seq_usuarios);
        SET NEW.idUsuario = CONCAT('USU-', @nuevoId);
    END IF;
END;
//

DELIMITER ;

-- trigger de id para grupo
CREATE SEQUENCE seq_grupo START WITH 100 INCREMENT BY 1 MINVALUE 100 NO MAXVALUE CACHE 10; 

DELIMITER //

CREATE TRIGGER trg_grupos_before_insert
BEFORE INSERT ON grupo
FOR EACH ROW
BEGIN
    IF NEW.idGrupo IS NULL OR NEW.idGrupo = '' THEN SET @nuevoId = NEXTVAL(seq_grupo);
        SET NEW.idGrupo = CONCAT('GRU-', @nuevoId);
    END IF;
END;
//

DELIMITER ;

-- trigger de id para tareas
CREATE SEQUENCE seq_tareas START WITH 100 INCREMENT BY 1 MINVALUE 100 NO MAXVALUE CACHE 10; 

DELIMITER //

CREATE TRIGGER trg_tareas_before_insert
BEFORE INSERT ON tareas
FOR EACH ROW
BEGIN
    IF NEW.idTarea IS NULL OR NEW.idTarea = '' THEN SET @nuevoId = NEXTVAL(seq_tareas);
        SET NEW.idTarea = CONCAT('TAR-', @nuevoId);
    END IF;
END;
//

DELIMITER ;

-- trigger de id para asignaciones
CREATE SEQUENCE seq_asignaciones START WITH 100 INCREMENT BY 1 MINVALUE 100 NO MAXVALUE CACHE 10; 

DELIMITER //

CREATE TRIGGER trg_asignaciones_before_insert
BEFORE INSERT ON asignaciones
FOR EACH ROW
BEGIN
    IF NEW.idAsignacion IS NULL OR NEW.idAsignacion = '' THEN SET @nuevoId = NEXTVAL(seq_asignaciones);
        SET NEW.idAsignacion = CONCAT('ASI-', @nuevoId);
    END IF;
END;
//

DELIMITER ;

-- trigger estado usuario
DELIMITER //

CREATE TRIGGER trg_usuarios_set_estado
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    IF NEW.estado IS NULL THEN
        SET NEW.estado = 4;
    END IF;
END;
//

DELIMITER ;

-- trigger estado grupo
DELIMITER //

CREATE TRIGGER trg_grupo_set_estado
BEFORE INSERT ON grupo
FOR EACH ROW
BEGIN
    IF NEW.estado IS NULL THEN
        SET NEW.estado = 4;
    END IF;
END;
//

DELIMITER ;

-- trigger estado tareas
DELIMITER //

CREATE TRIGGER trg_tareas_set_estado
BEFORE INSERT ON tareas
FOR EACH ROW
BEGIN
    IF NEW.estado IS NULL THEN
        SET NEW.estado = 1;
    END IF;
END;
//

DELIMITER ;


-- trigger estado asignaciones
DELIMITER //

CREATE TRIGGER trg_asignaciones_set_estado
BEFORE INSERT ON asignaciones
FOR EACH ROW
BEGIN
    IF NEW.estado IS NULL THEN
        SET NEW.estado = 6;
    END IF;
END;
//

DELIMITER ;