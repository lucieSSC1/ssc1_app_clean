CREATE TABLE emploi (
    id SERIAL PRIMARY KEY,
    glob_id INTEGER,
    fonction TEXT,
    employeur_id INTEGER,
    taches TEXT,
    no_contrat TEXT,
    taux_horaire REAL,
    commentaire TEXT,

    CONSTRAINT fk_emploi_glob_info
        FOREIGN KEY (glob_id)
        REFERENCES glob_info(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_emploi_employeur
        FOREIGN KEY (employeur_id)
        REFERENCES employeur(id)
        ON DELETE SET NULL
);