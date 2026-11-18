CREATE TABLE programme (
    id               SERIAL PRIMARY KEY,
    nom              TEXT,
    desc             TEXT,
    rem              TEXT,
    cout             REAL,
    etablissement_id INTEGER,
    glob_id          INTEGER,

    CONSTRAINT fk_programme_etablissement
        FOREIGN KEY (etablissement_id)
        REFERENCES etablissement(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_programme_global_info
        FOREIGN KEY (glob_id)
        REFERENCES global_info(id)
        ON DELETE SET NULL
);