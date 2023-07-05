drop database if exists spesa;
create database spesa;
USE spesa;

DROP USER IF EXISTS 'spesaUser'@'localhost';
CREATE USER 'spesaUser'@'localhost' IDENTIFIED BY 'spesaPwd';
GRANT select,insert,update,delete,execute ON spesa.* TO 'spesaUser'@'localhost';

DROP TABLE IF EXISTS marca;
CREATE TABLE marca (
	nome varchar(50) primary key
);

DROP TABLE IF EXISTS tipo;
CREATE TABLE tipo (
	nome varchar(50) primary key
);

DROP TABLE IF EXISTS prodotto;
CREATE TABLE prodotto (
	id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome varchar(50) not null,
	nome_marca varchar(50) not null, 
    nome_tipo varchar(50) not null, 
    isDaRicomprare boolean not null,
    isPiaciuto boolean,
    nota varchar(200),
    immagine blob,
    CONSTRAINT prodotti_distinti UNIQUE (nome_marca, nome),
    CONSTRAINT prodotto_marca FOREIGN KEY (nome_marca) REFERENCES marca(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT prodotto_tipo FOREIGN KEY (nome_tipo) REFERENCES tipo(nome) ON DELETE NO ACTION ON UPDATE CASCADE
);

DELETE FROM tipo;
INSERT INTO tipo VALUES ("Biscotti"), ("Merendine"), ("Pasta"), ("Crackers"), ("Cereali"), ("Pane"), ("Farina"),("Grissini");

DELETE FROM marca;
INSERT INTO marca VALUES("Scharr"), ("Barilla"), ("De Cecco");

