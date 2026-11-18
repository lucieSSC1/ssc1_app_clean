-- base de donnee/ressource.sql

CREATE TABLE IF NOT EXISTS ressource (
    id           SERIAL PRIMARY KEY,
    nom          TEXT NOT NULL,
    compagnie    TEXT,
    taux_horaire REAL
    telephone    TEXT,
    fax          TEXT,
    courriel     TEXT,
    adresse      TEXT,
    ville        TEXT,
    code_postal  TEXT,
    description  TEXT,
    services     TEXT,
    note		 TEXT
);