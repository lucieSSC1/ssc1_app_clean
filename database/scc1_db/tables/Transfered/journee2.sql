CREATE TABLE IF NOT EXISTS journee (
    id                  SERIAL PRIMARY KEY,
    activ_id            INTEGER NOT NULL,
    date_trav           TEXT NOT NULL,      -- format DD-MM-YYYY
    heures              REAL NOT NULL,      -- ex: 3.5

    objectif            TEXT,               -- ce que je voulais accomplir
    description         TEXT,               -- ce que j’ai fait
    suite               TEXT,               -- ce qu’il reste à faire
    note                TEXT,               -- remarques diverses

    created_at          TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_journee_activite
        FOREIGN KEY (activ_id)
        REFERENCES activite(id)
        ON DELETE SET NULL
);