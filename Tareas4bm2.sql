create database if not exists Tareas4bm2;
use Tareas4bm2;

create table if not exists Tarea(
	idTarea int not null auto_increment primary key,
    nombre varchar(50) not null unique,
    descripcion varchar(255) not null,
    activo boolean
);

insert into Tarea values(1, 'Estudiar Java', 'Requiero estudiar Java', true);
insert into Tarea values(2, 'Estudiar Bases de Datos', 'Requiero estudiar Bases de Datos MySQL', true);
insert into Tarea values(3, 'Estudiar Docker', 'Requiero estudiar Docker', false);

select * from Tarea;

update Tarea set nombre='Aprender Java', descripcion='Requiero aprender Java', activo=true where idTarea = 1; 

select * from Tarea;

delete from Tarea where idTarea=1;

select * from Tarea;