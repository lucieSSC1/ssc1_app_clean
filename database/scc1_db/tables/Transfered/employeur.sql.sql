CREATE TABLE employeur (
    id           SERIAL PRIMARY KEY,
    nom          TEXT,
    adresse      TEXT,
    ville        TEXT,
    prov         TEXT,
    code_postal  TEXT,
    pays         TEXT,
    telephone    TEXT,
    fax          TEXT,
    courriel     TEXT,
    site_url     TEXT,
    secteur      TEXT
);