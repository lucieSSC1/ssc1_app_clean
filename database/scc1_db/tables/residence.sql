-- ============================================================
-- TABLE : residence
-- SSC1
-- ============================================================

CREATE TABLE residence (
    id SERIAL PRIMARY KEY,

    glob_id INTEGER,

    adresse TEXT NOT NULL,
    ville TEXT NOT NULL,
    province TEXT NOT NULL,
    pays TEXT NOT NULL,

    commentaire TEXT,

    loyer NUMERIC(10,2),

    CONSTRAINT fk_residence_global_info
        FOREIGN KEY (glob_id)
        REFERENCES global_info(id)
        ON DELETE SET NULL
);