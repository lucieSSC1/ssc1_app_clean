CREATE TABLE cours (
    id SERIAL PRIMARY KEY,
    glob_id INTEGER,
    code  TEXT,
    nom  TEXT,
    desc TEXT,
    prog_id  INTEGER,
    session  TEXT,
    note_num  INTEGER,
    note_alpha  TEXT,
    categ  INTEGER,
    remarque TEXT,

    CONSTRAINT fk_cours_glob_info     
        FOREIGN KEY (glob_id)
        REFERENCES glob_info(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_cours_programme   
        FOREIGN KEY (prog_id)
        REFERENCES programme(id)
        ON DELETE SET NULL
);