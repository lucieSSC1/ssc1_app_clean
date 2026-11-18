-- -----------------------------------------------------------------------------
-- TABLE : planification  (Structure 4)
-- -----------------------------------------------------------------------------
-- Une planification est une activit� mise dans la liste de travail.
-- Elle contient :
--   - l'identit� de l'activit� (id, code, nom)
--   - une description (optionnelle)
--   - un statut "termin�e"
--   - un lien vers l'activit�
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS planification (
    id              SERIAL PRIMARY KEY,

    activ_id        INTEGER NOT NULL,
    activ_code      TEXT NOT NULL,
    activ_nom       TEXT NOT NULL,

    description_plan TEXT,
    terminee        BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_planification_activite
        FOREIGN KEY (activ_id)
        REFERENCES activite(id)
        ON DELETE SET NULL
);