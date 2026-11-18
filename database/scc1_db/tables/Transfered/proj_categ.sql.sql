-- ssc1_db/proj_categ.sql

CREATE TABLE IF NOT EXISTS proj_categ (
    id      SERIAL PRIMARY KEY,
    categ   TEXT NOT NULL
);