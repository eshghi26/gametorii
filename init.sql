-- init.sql
CREATE TABLE "Games" (
    "Id" SERIAL PRIMARY KEY,
    "MaxNumber" INTEGER NOT NULL,
    "guess" INTEGER NOT NULL
);

