CREATE TABLE IF NOT EXISTS tache (
    id          SERIAL PRIMARY KEY,
    code        TEXT,
    nom         TEXT,
    description TEXT,
    statut      BOOLEAN DEFAULT FALSE,
    lot_id      INTEGER,

    CONSTRAINT fk_tache_lot
        FOREIGN KEY (lot_id)
        REFERENCES lot(id)
        ON DELETE SET NULL
);