CREATE DATABASE qbase;

\connect qbase;

CREATE TYPE onz AS ENUM(
  'O', 'N', 'Z'
);

CREATE TABLE pdb(
  id CHAR(4) PRIMARY KEY
);

CREATE TABLE nucleotide(
  id SERIAL PRIMARY KEY,
  pdb_id CHAR(4) REFERENCES pdb(id),
  chain TEXT NOT NULL,
  number INTEGER NOT NULL,
  icode CHAR,
  coordinates TEXT NOT NULL
);

CREATE TABLE tetrade(
  id SERIAL PRIMARY KEY,
  nt1_id INTEGER REFERENCES nucleotide(id),
  nt2_id INTEGER REFERENCES nucleotide(id),
  nt3_id INTEGER REFERENCES nucleotide(id),
  nt4_id INTEGER REFERENCES nucleotide(id),
  onz ONZ
);

CREATE TABLE quadruplex(
  id SERIAL PRIMARY KEY
);

CREATE TABLE quadruplex_tetrade(
  id SERIAL PRIMARY KEY,
  quadruplex_id INTEGER REFERENCES quadruplex(id),
  tetrade_id INTEGER REFERENCES tetrade(id)
);
