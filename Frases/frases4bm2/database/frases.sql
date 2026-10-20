create database if not exists Frases;
use Frases;

create table if not exists Frase(
	idFrase int not null auto_increment primary key,
    textoFrase varchar(500) not null,
    autorFrase varchar(150) not null,
    origenFrase varchar(200) not null
);

select * from Frase;