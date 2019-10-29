CREATE ROLE qbase WITH CREATEDB LOGIN PASSWORD 'Jellux37';

CREATE DATABASE qbase WITH OWNER qbase;

\connect qbase;

SET ROLE qbase;

CREATE TYPE onz AS ENUM ('O+', 'O-', 'N+', 'N-', 'Z+', 'Z-');

CREATE TYPE onzm AS ENUM ('Op', 'Oa', 'Oh', 'Np', 'Na', 'Nh', 'Zp', 'Za', 'Zh', 'Mp', 'Ma', 'Mh', 'n/a');

CREATE TYPE molecule AS ENUM ('RNA', 'DNA', 'Other');

CREATE TYPE experiment AS ENUM ('X-Ray', 'NMR', 'Other');

CREATE TYPE stericity AS ENUM ('cis', 'trans');

CREATE TYPE edge AS ENUM ('Watson-Crick', 'Hoogsteen', 'Sugar');

CREATE TYPE glycosidic_bond AS ENUM ('anti', 'syn', '...');

CREATE TYPE direction AS ENUM ('parallel', 'antiparallel', 'hybrid', 'n/a');

CREATE TABLE pdb
(
    id            SERIAL PRIMARY KEY,
    identifier    CHAR(4)    NOT NULL,
    assembly      INTEGER    NOT NULL,
    experiment    EXPERIMENT NOT NULL,
    resolution    REAL,
    visualization TEXT       NOT NULL,
    arc_diagram   TEXT       NOT NULL
);

CREATE TABLE nucleotide
(
    id              SERIAL PRIMARY KEY,
    pdb_id          INTEGER         NOT NULL REFERENCES pdb (id),
    model           INTEGER         NOT NULL,
    chain           TEXT            NOT NULL,
    number          INTEGER         NOT NULL,
    icode           CHAR,
    molecule        MOLECULE        NOT NULL,
    full_name       TEXT            NOT NULL,
    short_name      CHAR            NOT NULL,
    glycosidic_bond GLYCOSIDIC_BOND NOT NULL,
    coordinates     TEXT            NOT NULL
);

CREATE TABLE helix
(
    id            SERIAL PRIMARY KEY,
    visualization TEXT NOT NULL,
    arc_diagram   TEXT NOT NULL
);

CREATE TABLE quadruplex
(
    id            SERIAL PRIMARY KEY,
    helix_id      INTEGER NOT NULL REFERENCES helix (id),
    onzm          ONZM    NOT NULL,
    visualization TEXT    NOT NULL,
    arc_diagram   TEXT    NOT NULL
);

CREATE TABLE tetrad
(
    id            SERIAL PRIMARY KEY,
    quadruplex_id INTEGER NOT NULL REFERENCES quadruplex (id),
    nt1_id        INTEGER NOT NULL REFERENCES nucleotide (id),
    nt2_id        INTEGER NOT NULL REFERENCES nucleotide (id),
    nt3_id        INTEGER NOT NULL REFERENCES nucleotide (id),
    nt4_id        INTEGER NOT NULL REFERENCES nucleotide (id),
    onz           ONZ     NOT NULL,
    planarity     REAL    NOT NULL,
    visualization TEXT    NOT NULL,
    arc_diagram   TEXT    NOT NULL
);

CREATE TABLE base_pair
(
    id        SERIAL PRIMARY KEY,
    nt1_id    INTEGER   NOT NULL REFERENCES nucleotide (id),
    nt2_id    INTEGER   NOT NULL REFERENCES nucleotide (id),
    stericity STERICITY NOT NULL,
    edge5     EDGE      NOT NULL,
    edge3     EDGE      NOT NULL
);

CREATE TABLE tetrad_pair
(
    id         SERIAL PRIMARY KEY,
    tetrad1_id INTEGER   NOT NULL REFERENCES tetrad (id),
    tetrad2_id INTEGER   NOT NULL REFERENCES tetrad (id),
    direction  DIRECTION NOT NULL,
    rise       REAL      NOT NULL,
    twist      REAL      NOT NULL
);
