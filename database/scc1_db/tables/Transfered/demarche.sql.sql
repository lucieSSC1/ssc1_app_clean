CREATE TABLE demarche (
    id SERIAL PRIMARY KEY,

    -- Chronologie
    glob_id INTEGER,                     -- Lien vers global_info

    date_demar DATE,
    domaine TEXT,
    service_prospect TEXT,
    service_details TEXT,

    mot_cle1 TEXT,
    mot_cle2 TEXT,
    mot_cle3 TEXT,

    prosp_id INTEGER,                    -- Cl� �trang�re vers prospect

    pending BOOLEAN,
    entente BOOLEAN,
    interactions TEXT,

    lettre_url TEXT,
    cv_url TEXT,
    preparation_url TEXT,

    CONSTRAINT fk_demarche_glob_info
        FOREIGN KEY (glob_id)
        REFERENCES glob_info(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_demarche_prospect
        FOREIGN KEY (prosp_id)
        REFERENCES prospect(id)
        ON DELETE SET NULL
);