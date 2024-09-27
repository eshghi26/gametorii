-- init.sql
CREATE TABLE Games (
    Id SERIAL PRIMARY KEY,
    maxNumber INTEGER NOT NULL,
    guess INTEGER NOT NULL
);
