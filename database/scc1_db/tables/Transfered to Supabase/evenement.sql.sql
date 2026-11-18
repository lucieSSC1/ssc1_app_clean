CREATE TABLE evenement (
    id SERIAL PRIMARY KEY,

    -- Chronologie
    glob_id INTEGER,

    nom TEXT NOT NULL,
    categorie INTEGER,               -- Lien vers event_categ

    mot_cle1 TEXT,
    mot_cle2 TEXT,
    mot_cle3 TEXT,
    description TEXT,

    CONSTRAINT fk_evenement_global_info
        FOREIGN KEY (glob_id)
        REFERENCES global_info(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_evenement_categorie
        FOREIGN KEY (categorie)
        REFERENCES event_categ(id)
        ON DELETE SET NULL
);