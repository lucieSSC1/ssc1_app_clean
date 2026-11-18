CREATE TABLE IF NOT EXISTS chanson_categ (
    id          SERIAL PRIMARY KEY,
    nom         TEXT NOT NULL,        -- nom de la catégorie
    description TEXT,                 -- optionnel
    created_at  TIMESTAMP DEFAULT NOW()
);

INSERT INTO chanson_categ (nom) VALUES
('Rock'),
('Pop'),
('Country'),
('Classique'),
('Jazz'),
('Blues'),
('Metal'),
('Folk'),
('Électro'),
('Hip-hop'),
('Reggae'),
('Latino'),
('Soul'),
('R&B');
