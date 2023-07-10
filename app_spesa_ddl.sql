DROP DATABASE IF EXISTS railway;
CREATE DATABASE railway;
USE railway;

DROP USER IF EXISTS 'spesaUser'@'151.43.54.92';
CREATE USER 'spesaUser'@'151.43.54.92' IDENTIFIED BY 'spesaPwd';
GRANT select,insert,update,delete,execute ON railway.* TO 'spesaUser'@'151.43.54.92';

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
    isPiaciuto boolean default null,
    immagine longblob, 
    nota varchar(200),
    CONSTRAINT prodotti_distinti UNIQUE (nome_marca, nome, nome_tipo),
    CONSTRAINT prodotto_marca FOREIGN KEY (nome_marca) REFERENCES marca(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT prodotto_tipo FOREIGN KEY (nome_tipo) REFERENCES tipo(nome) ON DELETE NO ACTION ON UPDATE CASCADE
);

DELETE FROM tipo;
INSERT INTO tipo VALUES ("Biscotti"), ("Merendine"), ("Pasta"), ("Crackers"), ("Cereali"), ("Pane"), ("Farina"),("Grissini");

DELETE FROM marca;
INSERT INTO marca VALUES("Scharr"), ("Barilla"), ("De Cecco");

INSERT INTO prodotto(nome, nome_marca, nome_tipo, isDaRicomprare) VALUE("Grissini", "Scharr", "Grissini", false);
INSERT INTO prodotto(nome, nome_marca, nome_tipo, isDaRicomprare) VALUE("Grissini", "Barilla", "Grissini", false);
INSERT INTO prodotto(nome, nome_marca, nome_tipo, isDaRicomprare) VALUE("Cereali", "Scharr", "Cereali", false);
INSERT INTO prodotto(nome, nome_marca, nome_tipo, isDaRicomprare) VALUE("Cereali al cioccolato", "Scharr", "Cereali", false);
INSERT INTO prodotto(nome, nome_marca, nome_tipo, isDaRicomprare) VALUE("Fusilli", "Scharr", "Pasta", false);
INSERT INTO prodotto(nome, nome_marca, nome_tipo, isDaRicomprare) VALUE("Fusilli", "Barilla", "Pasta", false);
INSERT INTO prodotto(nome, nome_marca, nome_tipo, isDaRicomprare) VALUE("Penne", "Barilla", "Pasta", false);
INSERT INTO prodotto(nome, nome_marca, nome_tipo, isDaRicomprare) VALUE("Rigatoni", "Barilla", "Pasta", false);

DELIMITER $$
DROP TRIGGER IF EXISTS checkMarcaProdotto$$

CREATE TRIGGER checkMarcaProdotto BEFORE INSERT ON prodotto
FOR EACH ROW
BEGIN
    DECLARE v_marca VARCHAR(50);
    DECLARE v_tipo VARCHAR(50);
    SELECT nome INTO v_marca FROM marca WHERE lower(nome) = lower(NEW.nome_marca);
    SELECT nome INTO v_tipo FROM tipo WHERE lower(nome) = lower(NEW.nome_tipo);
    SET NEW.nome_marca = v_marca;
    SET NEW.nome_tipo = v_tipo;
    
END$$

DELIMITER ;

	