CREATE DATABASE qbase;

\connect qbase;

CREATE TYPE onz AS ENUM (
  '+O', '-O', '+N', '-N', '+Z', '-Z'
);

CREATE TYPE molecule AS ENUM (
  'RNA', 'DNA', 'Other'
);

CREATE TYPE experiment AS ENUM (
  'X-Ray', 'NMR', 'Other'
);

CREATE TYPE stericity AS ENUM (
  'cis', 'trans'
);

CREATE TYPE edge AS ENUM (
  'Watson-Crick', 'Hoogsteen', 'Sugar'
);

CREATE TYPE strand_direction AS ENUM (
  'parallel', 'antiparallel', 'mixed'
);

CREATE TYPE glycosidic_bond AS ENUM (
  'anti', 'syn'
);

CREATE TABLE pdb (
  id            CHAR(4) PRIMARY KEY,
  assembly      INTEGER,
  experiment    EXPERIMENT NOT NULL,
  resolution    REAL,
  visualization TEXT       NOT NULL
);

CREATE TABLE nucleotide (
  id              SERIAL PRIMARY KEY,
  pdb_id          CHAR(4)         NOT NULL REFERENCES pdb (id),
  model           INTEGER,
  chain           TEXT            NOT NULL,
  number          INTEGER         NOT NULL,
  icode           CHAR,
  molecule        MOLECULE        NOT NULL,
  full_name       TEXT            NOT NULL,
  short_name      CHAR            NOT NULL,
  glycosidic_bond GLYCOSIDIC_BOND NOT NULL,
  coordinates     TEXT
);

CREATE TABLE tetrade (
  id        SERIAL PRIMARY KEY,
  nt1_id    INTEGER NOT NULL REFERENCES nucleotide (id),
  nt2_id    INTEGER NOT NULL REFERENCES nucleotide (id),
  nt3_id    INTEGER NOT NULL REFERENCES nucleotide (id),
  nt4_id    INTEGER NOT NULL REFERENCES nucleotide (id),
  planarity REAL    NOT NULL,
  onz       ONZ
);

CREATE TABLE quadruplex (
  id               SERIAL PRIMARY KEY,
  strand_direction STRAND_DIRECTION NOT NULL,
  visualization    TEXT             NOT NULL
);

CREATE TABLE quadruplex_tetrade (
  id            SERIAL PRIMARY KEY,
  quadruplex_id INTEGER NOT NULL REFERENCES quadruplex (id),
  tetrade_id    INTEGER NOT NULL REFERENCES tetrade (id)
);

CREATE TABLE base_pair (
  id        SERIAL PRIMARY KEY,
  nt1_id    INTEGER   NOT NULL REFERENCES nucleotide (id),
  nt2_id    INTEGER   NOT NULL REFERENCES nucleotide (id),
  stericity STERICITY NOT NULL,
  edge5     EDGE      NOT NULL,
  edge3     EDGE      NOT NULL
);

CREATE TABLE tetrade_stack (
  id          SERIAL PRIMARY KEY,
  tetrade1_id INTEGER NOT NULL REFERENCES tetrade (id),
  tetrade2_id INTEGER NOT NULL REFERENCES tetrade (id),
  rise        REAL    NOT NULL,
  twist       REAL    NOT NULL
)
