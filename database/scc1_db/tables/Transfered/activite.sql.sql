CREATE TABLE IF NOT EXISTS activite (
    id          SERIAL PRIMARY KEY,
    code        TEXT,
    nom         TEXT,
    description TEXT,
    duree       REAL,          -- heures planifiées
    tache_id    INTEGER,
    resp_id     INTEGER,       -- responsable (FK vers ressource)

    CONSTRAINT fk_activite_tache
        FOREIGN KEY (tache_id)
        REFERENCES tache(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_activite_ressource
        FOREIGN KEY (resp_id)
        REFERENCES ressource(id)
        ON DELETE SET NULL
);