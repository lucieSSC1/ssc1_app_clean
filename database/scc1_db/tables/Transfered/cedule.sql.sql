-- ==============================================================
-- = CÉDULE (Structure 2 — version finale)
-- ==============================================================

CREATE TABLE IF NOT EXISTS cedule (
    id              SERIAL PRIMARY KEY,
    activ_id        INTEGER NOT NULL,

    activ_code      TEXT NOT NULL,
    activ_nom       TEXT NOT NULL,

    date            TEXT NOT NULL,          -- format DD-MM-YYYY
    duree_planifiee TEXT NOT NULL,          -- ex: "1.5"

    terminee        BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_cedule_activite
        FOREIGN KEY (activ_id)
        REFERENCES activite(id)
        ON DELETE SET NULL
);

-- INSERT --------------------------------------------------------
INSERT INTO cedule (activ_id, activ_code, activ_nom, date, duree_planifiee, terminee)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING id;

-- UPDATE --------------------------------------------------------
UPDATE cedule
SET
    activ_code      = $1,
    activ_nom       = $2,
    date            = $3,
    duree_planifiee = $4,
    terminee        = $5
WHERE id = $6;

-- DELETE --------------------------------------------------------
DELETE FROM cedule
WHERE id = $1;

-- SELECT --------------------------------------------------------
SELECT
    id,
    activ_id,
    activ_code,
    activ_nom,
    date,
    duree_planifiee,
    terminee
FROM cedule
ORDER BY id DESC;

-- SELECT PAR ID -------------------------------------------------
SELECT
    id,
    activ_id,
    activ_code,
    activ_nom,
    date,
    duree_planifiee,
    terminee
FROM cedule
WHERE id = $1;