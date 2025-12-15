-- =========================================
-- Lab4 : INSERT, UPDATE, DELETE et Transactions
-- =========================================

USE bibliotheque;

-- =========================
-- Étape 0 : Vider les tables pour éviter les doublons
-- =========================
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE emprunt;
TRUNCATE TABLE ouvrage;
TRUNCATE TABLE abonne;
TRUNCATE TABLE auteur;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================
-- Étape 1 : INSERT - Auteurs
-- =========================
INSERT INTO auteur (nom) VALUES
('Antoine de Saint-Exupéry'),
('Victor Hugo'),
('Albert Camus'),
('George Orwell'),
('Jane Austen');

SELECT * FROM auteur;

-- =========================
-- Étape 2 : INSERT - Ouvrages
-- =========================
INSERT INTO ouvrage (titre, disponible, auteur_id) VALUES
('Le Petit Prince', TRUE, 1),
('Les Misérables', TRUE, 2),
('L''Étranger', FALSE, 3),
('1984', FALSE, 4),
('Pride and Prejudice', TRUE, 5);

SELECT * FROM ouvrage;

-- =========================
-- Étape 3 : INSERT - Abonnés
-- =========================
INSERT IGNORE INTO abonne (nom, email) VALUES
('Karim', 'karim@mail.com'),
('Lucie', 'lucie@mail.com');

SELECT * FROM abonne;

-- =========================
-- Étape 4 : INSERT - Emprunts
-- Utiliser uniquement des id existants
-- =========================
-- Vérifie les IDs avant de lancer ces commandes !
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut) VALUES
(1, 1, '2025-06-18'),  -- Le Petit Prince emprunté par Karim
(2, 2, '2025-06-19');  -- Les Misérables emprunté par Lucie

SELECT * FROM emprunt;

-- =========================
-- Étape 5 : UPDATE
-- Marquer un ouvrage comme indisponible
-- =========================
UPDATE ouvrage
SET disponible = FALSE
WHERE titre = 'Les Misérables';

-- Mettre à jour l’email d’un abonné
UPDATE abonne
SET email = 'karim.new@mail.com'
WHERE nom = 'Karim';

-- Clôturer un emprunt en renseignant date_fin
UPDATE emprunt
SET date_fin = CURDATE()
WHERE ouvrage_id = 1 AND abonne_id = 1;

SELECT * FROM ouvrage;
SELECT * FROM abonne;
SELECT * FROM emprunt;

-- =========================
-- Étape 6 : DELETE
-- =========================
DELETE e
FROM emprunt e
JOIN ouvrage o ON e.ouvrage_id = o.id
WHERE o.auteur_id = 4; 
-- Supprimer un auteur et observer la cascade sur les ouvrages
DELETE FROM auteur
WHERE nom = 'George Orwell';

-- Tenter de supprimer un ouvrage emprunté (verrou RESTRICT)
DELETE FROM ouvrage
WHERE id = 2;  -- échouera si emprunt non clôturé

-- Supprimer un abonné
DELETE FROM abonne
WHERE nom = 'Lucie';

SELECT * FROM auteur;
SELECT * FROM ouvrage;
SELECT * FROM abonne;
SELECT * FROM emprunt;

-- =========================
-- Étape 7 : TRANSACTION
-- =========================
START TRANSACTION;

INSERT INTO abonne (nom, email) VALUES ('Samir', 'samir@mail.com');
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut) VALUES (3, LAST_INSERT_ID(), '2025-06-20');

-- Valider la transaction
COMMIT;

SELECT * FROM abonne;
SELECT * FROM emprunt;
