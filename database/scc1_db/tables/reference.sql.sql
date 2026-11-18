CREATE TABLE reference (
    id SERIAL PRIMARY KEY,

    -- Chronologie
    glob_id INTEGER,

    -- Classification
    type TEXT,
    categorie_id INTEGER,

    -- Métadonnées générales
    titre TEXT NOT NULL,
    auteur TEXT,
    date DATE,
    domaine TEXT,
    categ TEXT,
    desc TEXT,
    location TEXT,
    collection TEXT,

    -- Source (articles)
    source TEXT,
    section TEXT,
    page TEXT,
    txt_section TEXT,

    -- Fichiers
    pdf TEXT,
    format TEXT,
    medium TEXT,

    -- Informations bibliographiques (livres)
    ISBN TEXT,
    editeur_nom TEXT,
    editeur_lieu TEXT,
    copyright TEXT,
    pages INTEGER,
    prix NUMERIC(10,2),

    -- Liens internes SSC1
    programme_id INTEGER,
    projet_id INTEGER,

    -- Statut et notes
    statut TEXT,
    commentaire TEXT,
    info TEXT,

    CONSTRAINT fk_reference_global_info
        FOREIGN KEY (glob_id)
        REFERENCES global_info(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_reference_categorie
        FOREIGN KEY (categorie_id)
        REFERENCES artcateg(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_reference_programme
        FOREIGN KEY (programme_id)
        REFERENCES programme(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_reference_projet
        FOREIGN KEY (projet_id)
        REFERENCES projet(id)
        ON DELETE SET NULL
);