-- base de donnee/journee.sql

-- ==============================================================
-- = FICHIER : /base de donnees/sql/journee.sql
-- = JOURNÉE : TABLE + INSERT + UPDATE + DELETE + SELECT
-- ==============================================================
CREATE TABLE IF NOT EXISTS journee (
    id                  SERIAL PRIMARY KEY,
    activ_id            INTEGER NOT NULL,
    date                TEXT NOT NULL,      -- format DD-MM-YYYY
    heures_travaillees  REAL NOT NULL,      -- ex: 3.5

    objectif            TEXT,               -- ce que je voulais accomplir
    description         TEXT,               -- ce que j’ai fait
    suite               TEXT,               -- ce qu’il reste à faire
    note                TEXT,               -- remarques diverses

    CONSTRAINT fk_journee_activite
        FOREIGN KEY (activ_id)
        REFERENCES activite(id)
        ON DELETE SET NULL
);
-- TABLE ---------------------------------------------------------
-- INSERT --------------------------------------------------------
-- $1 = activ_id
-- $2 = date
-- $3 = heures
-- $4 = note
-- $5 = objectif
-- $6 = tache
-- $7 = suite
INSERT INTO journee (activ_id, date, heures, note, objectif, tache, suite)
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING id;

-- UPDATE --------------------------------------------------------
-- $1 = date
-- $2 = heures
-- $3 = note
-- $4 = objectif
-- $5 = tache
-- $6 = suite
-- $7 = id
UPDATE journee
SET
    date = $1,
    heures = $2,
    note = $3,
    objectif = $4,
    tache = $5,
    suite = $6
WHERE id = $7;

-- DELETE --------------------------------------------------------
-- $1 = id
DELETE FROM journee
WHERE id = $1;

-- SELECT : toutes les journées ---------------------------------
SELECT
    id,
    activ_id,
    date,
    heures,
    note,
    objectif,
    tache,
    suite,
    created_at
FROM journee
ORDER BY id DESC;

-- SELECT : journée par ID --------------------------------------
-- $1 = id
SELECT
    id,
    activ_id,
    date,
    heures,
    note,
    objectif,
    tache,
    suite,
    created_at
FROM journee
WHERE id = $1;

-- SELECT COMBINÉ : journée + activité ---------------------------
SELECT
    j.id,
    j.activ_id,
    a.activite_nom,
    a.description,
    j.date,
    j.heures,
    j.note,
    j.objectif,
    j.tache,
    j.suite,
    j.created_at
FROM journee j
LEFT JOIN activite a ON a.id = j.activ_id
ORDER BY j.id DESC;

-- SELECT COMBINÉ : journée + activité par ID --------------------
-- $1 = id
SELECT
    j.id,
    j.activ_id,
    a.activite_nom,
    a.description,
    j.date,
    j.heures,
    j.note,
    j.objectif,
    j.tache,
    j.suite,
    j.created_at
FROM journee j
LEFT JOIN activite a ON a.id = j.activ_id
WHERE j.id = $1;