DROP TABLE IF EXISTS population;
DROP TABLE IF EXISTS dispo_alim;
DROP TABLE IF EXISTS equilibre_prod;
DROP TABLE IF EXISTS sous_nutrition;



CREATE TABLE population (
    id INTEGER,
    code_pays INTEGER,
    pays TEXT,
    annee INTEGER,
    population REAL,
Primary Key (code_pays,annee)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fr_bdd_pop.csv'
INTO TABLE population
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


CREATE TABLE dispo_alim  (
    id INTEGER,
    code_pays INTEGER,
    pays TEXT,
    code_produit INTEGER,
    produit TEXT,
    annee INTEGER,
    dispo_mat_gr FLOAT,
    origin TEXT,
    dispo_prot FLOAT,
    dispo_alim_kcal_p_j FLOAT,
    dispo_alim_tonnes FLOAT,
Primary Key (code_pays,code_produit)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fr_bdd_dispo_alim.csv'
INTO TABLE dispo_alim
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


CREATE TABLE equilibre_prod  (
    id INTEGER,
    code_pays INTEGER,
    pays TEXT,
    code_produit INTEGER,
    produit TEXT,
    annee INTEGER,
    traitement REAL,
    autres_utilisations REAL,
    alim_ani REAL,
    nourriture REAL,
    pertes REAL,
    semences REAL,
    dispo_int REAL,
Primary Key (code_pays,code_produit)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fr_bdd_equilibre_prod.csv'
INTO TABLE equilibre_prod
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE sous_nutrition (
    id INTEGER,
    code_pays INTEGER,
    pays TEXT,
    nb_personnes REAL,
    annee INTEGER,
Primary Key (code_pays)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fr_bdd_sous_nutrition.csv'
INTO TABLE sous_nutrition
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

--Maj des NULL dans la base de données
UPDATE  dispo_alim SET  dispo_mat_gr = NULL WHERE dispo_mat_gr = -999;
UPDATE  dispo_alim SET  dispo_prot = NULL WHERE dispo_prot = -999;
UPDATE  dispo_alim SET  dispo_alim_tonnes = NULL WHERE dispo_alim_tonnes = -999;
UPDATE  dispo_alim SET  dispo_alim_kcal_p_j = NULL WHERE dispo_alim_kcal_p_j = -999;
UPDATE  sous_nutrition SET  nb_personnes = NULL WHERE nb_personnes = -999;
UPDATE  equilibre_prod SET  autres_utilisations = NULL WHERE autres_utilisations = -999;
UPDATE  equilibre_prod SET  alim_ani = NULL WHERE alim_ani = -999;
UPDATE  equilibre_prod SET  nourriture = NULL WHERE nourriture = -999;
UPDATE  equilibre_prod SET  pertes = NULL WHERE pertes = -999;
UPDATE  equilibre_prod SET  traitement = NULL WHERE pertes = -999;
UPDATE  equilibre_prod SET  dispo_int = NULL WHERE dispo_int = -999;



--les différentes requêtes SQL pour répondres au question

SELECT dispo_alim.pays, SUM(dispo_alim.dispo_prot * 365 / 1000) AS ratio_p
FROM dispo_alim
GROUP BY dispo_alim.pays
ORDER BY ratio_p DESC LIMIT 20;

SELECT dispo_alim.pays, SUM(dispo_alim.dispo_alim_kcal_p_j * 365) AS ratio_kcal
FROM dispo_alim
GROUP BY dispo_alim.pays
ORDER BY ratio_kcal DESC LIMIT 20;

SELECT dispo_alim.pays, SUM(dispo_alim.dispo_prot * 365 / 1000) AS ratio_p
FROM dispo_alim
GROUP BY dispo_alim.pays
ORDER BY ratio_p LIMIT 20;

SELECT equilibre_prod.pays, SUM(equilibre_prod.pertes) AS sum_pertes
FROM equilibre_prod
GROUP BY equilibre_prod.pays
ORDER BY sum_pertes DESC;

SELECT population.pays, sous_nutrition.nb_personnes/population.population AS ratio_sousnutr
FROM sous_nutrition, population WHERE sous_nutrition.pays = population.pays
GROUP BY population.pays
ORDER BY ratio_sousnutr DESC  LIMIT 10;

SELECT equilibre_prod.produit, AVG(equilibre_prod.autres_utilisations/equilibre_prod.dispo_int) AS ratio_otheruse
FROM equilibre_prod
GROUP BY equilibre_prod.produit
ORDER BY ratio_otheruse DESC  LIMIT 10;





--test perte par habitant par pays

SELECT equilibre_prod.pays, SUM(equilibre_prod.pertes)/population.population*1000000 AS sum_pertes
FROM equilibre_prod, population WHERE equilibre_prod.pays = population.pays
GROUP BY equilibre_prod.pays
ORDER BY sum_pertes DESC;