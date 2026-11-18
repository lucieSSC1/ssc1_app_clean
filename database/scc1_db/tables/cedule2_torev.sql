-- ==============================================================
-- = FICHIER : /base de donnees/sql/cedule.sql
-- = CEDULE : TABLE
-- ==============================================================

CREATE TABLE IF NOT EXISTS cedule (
    id              SERIAL PRIMARY KEY,
    activ_id        INTEGER NOT NULL,

    activ_code      TEXT NOT NULL,
    activ_nom       TEXT NOT NULL,

    date_trav       TEXT NOT NULL,          -- format DD-MM-YYYY
    duree_planifiee REAL NOT NULL,          -- ex: 1.5

    terminee        BOOLEAN DEFAULT FALSE,

    created_at      TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_cedule_activite
        FOREIGN KEY (activ_id)
        REFERENCES activite(id)
        ON DELETE SET NULL
);

