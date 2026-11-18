CREATE TABLE emploi (
    id SERIAL PRIMARY KEY,

    glob_id INTEGER,

    fonction TEXT NOT NULL,

    employeur_id INTEGER,

    taches TEXT,

    no_contrat TEXT,

    taux_horaire NUMERIC(10,2),

    commentaire TEXT,

    CONSTRAINT fk_emploi_global_info
        FOREIGN KEY (glob_id)
        REFERENCES global_info(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_emploi_employeur
        FOREIGN KEY (employeur_id)
        REFERENCES employeur(id)
        ON DELETE SET NULL
);