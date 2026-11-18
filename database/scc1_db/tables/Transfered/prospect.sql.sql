CREATE TABLE prospect (
    id          SERIAL PRIMARY KEY,
    nom         TEXT,
    entreprise  TEXT,
    telephone   TEXT,
    courriel    TEXT,
    site_url    TEXT,
    adresse     TEXT,
    ville       TEXT,
    prov        TEXT,
    pays        TEXT,
    commentaire TEXT
);