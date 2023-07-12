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
    immagine longblob not null, 
    CONSTRAINT prodotti_distinti UNIQUE (nome_marca, nome, nome_tipo),
    CONSTRAINT prodotto_marca FOREIGN KEY (nome_marca) REFERENCES marca(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT prodotto_tipo FOREIGN KEY (nome_tipo) REFERENCES tipo(nome) ON DELETE NO ACTION ON UPDATE CASCADE
);

DELETE FROM tipo;
INSERT INTO tipo VALUES ("Biscotti"), ("Merendine"), ("Pasta"), ("Crackers"), ("Cereali"), ("Pane"), ("Farina"),("Grissini");

DELETE FROM marca;
INSERT INTO marca VALUES("Scharr"), ("Barilla"), ("De Cecco");

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

DROP FUNCTION IF EXISTS capitalize$$


CREATE FUNCTION capitalize (s varchar(255)) RETURNS varchar(255) deterministic
BEGIN
  declare c int;
  declare x varchar(255);
  declare y varchar(255);
  declare z varchar(255);

  set x = UPPER( SUBSTRING( s, 1, 1));
  set y = SUBSTR( s, 2);
  set c = instr( y, ' ');

  while c > 0
    do
      set z = SUBSTR( y, 1, c);
      set x = CONCAT( x, z);
      set z = UPPER( SUBSTR( y, c+1, 1));
      set x = CONCAT( x, z);
      set y = SUBSTR( y, c+2);
      set c = INSTR( y, ' ');     
  end while;
  set x = CONCAT(x, y);
  return x;
END$$

DROP TRIGGER IF EXISTS tipo_capitalize_first$$

CREATE TRIGGER tipo_capitalize_first BEFORE INSERT ON tipo FOR EACH ROW
BEGIN
	SET NEW.nome = capitalize(NEW.nome);
END$$

CREATE TRIGGER marca_capitalize_first BEFORE INSERT ON marca FOR EACH ROW
BEGIN
	SET NEW.nome = capitalize(NEW.nome);
END$$

DELIMITER ;

	