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
    fechaCreacion datetime default current_timestamp
);

create table grupo(
	idGrupo varchar(100) primary key,
    nombre varchar(100) not null,
    descripcion text,
    fechaCreacion datetime default current_timestamp,
    idUsuarioCreador varchar(100),
    FOREIGN KEY (idUsuarioCreador) REFERENCES usuarios(idUsuario)
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
    foreign key (estado) REFERENCES estado (idEstado),
    foreign key (idGrupo) REFERENCES grupo (idGrupo)
);

create table asignaciones(
	idAsignacion varchar(100) primary key,
    idTarea varchar(100),
    idUsuario varchar(100),
    fechaAsignacion datetime DEFAULT current_timestamp,
    FOREIGN KEY (idTarea) REFERENCES tareas (idTarea),
    FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
);