CREATE TABLE reference (
    id SERIAL PRIMARY KEY,

    -- Chronologie
    glob_id INTEGER,

    -- Classification
    type_doc reference_type,             -- ENUM fixe
    categorie_id INTEGER,            -- Lien vers ref_categ (modifiable)

    -- M�tadonn�es g�n�rales
    titre TEXT,
    auteur TEXT,
    date_publication DATE,
    domaine TEXT,
    description_ref TEXT,
    location_ref TEXT,
    collection_ref TEXT,

    -- Source (articles)
    source TEXT,
    section TEXT,
    page_no TEXT,
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
    prix REAL,

    -- Statut et notes
    statut TEXT,
    commentaire TEXT,

    CONSTRAINT fk_reference_glob_info
        FOREIGN KEY (glob_id)
        REFERENCES glob_info(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_reference_categorie
        FOREIGN KEY (categorie_id)
        REFERENCES ref_categ(id)
        ON DELETE SET NULL
);