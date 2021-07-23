CREATE ROLE qbase WITH CREATEDB LOGIN PASSWORD 'Jellux37';

CREATE DATABASE qbase WITH OWNER qbase;

\connect qbase;

SET ROLE qbase;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE EXTENSION IF NOT EXISTS citext;

CREATE TYPE onz AS ENUM ('O+', 'O-', 'N+', 'N-', 'Z+', 'Z-');

CREATE TYPE onzm AS ENUM ('Op', 'Oa', 'Oh', 'Np', 'Na', 'Nh', 'Zp', 'Za', 'Zh', 'Mp', 'Ma', 'Mh', 'n/a');

CREATE TYPE subtype AS ENUM ('+', '-', '*', 'n/a');

CREATE TYPE molecule AS ENUM ('RNA', 'DNA', 'Other');

CREATE TYPE experiment AS ENUM ('X-Ray', 'NMR', 'Other');

CREATE TYPE stericity AS ENUM ('cis', 'trans');

CREATE TYPE edge AS ENUM ('Watson-Crick', 'Hoogsteen', 'Sugar');

CREATE TYPE glycosidic_bond AS ENUM ('anti', 'syn', '...');

CREATE TYPE direction AS ENUM ('parallel', 'antiparallel', 'hybrid', 'n/a');

CREATE TYPE gba_tetrad_class AS ENUM ('Ia', 'Ib', 'IIa', 'IIb', 'IIIa', 'IIIb', 'IVa', 'IVb', 'Va', 'Vb', 'VIa', 'VIb', 'VIIa', 'VIIb', 'VIIIa', 'VIIIb', 'n/a');

CREATE TYPE gba_quadruplex_class AS ENUM ('I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'n/a');

CREATE TYPE loop_class AS ENUM ('1a', '1b', '2a', '2b', '3a', '3b', '4a', '4b', '5a', '5b', '6a', '6b', '7a', '7b', '8a', '8b', '9a', '9b', '10a', '10b', '11a', '11b', '12a', '12b', '13a', '13b', 'n/a');

CREATE TYPE loop_type AS ENUM ('diagonal', 'lateral-', 'lateral+', 'propeller-', 'propeller+');

-- Source: https://dba.stackexchange.com/questions/68266/what-is-the-best-way-to-store-an-email-address-in-postgresql
CREATE DOMAIN emailtype AS CITEXT
    CHECK (VALUE ~
           '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$');

CREATE TABLE newsletter
(
    id    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email EMAILTYPE UNIQUE NOT NULL
);

CREATE TABLE pdb
(
    id              SERIAL PRIMARY KEY,
    identifier      CHAR(4)    NOT NULL,
    assembly        INTEGER    NOT NULL,
    experiment      EXPERIMENT NOT NULL,
    resolution      REAL,
    deposition_date DATE       NOT NULL,
    release_date    DATE       NOT NULL,
    revision_date   DATE       NOT NULL,
    dot_bracket     TEXT       NOT NULL,
    title           TEXT       NOT NULL
);

CREATE TABLE ion
(
    id     SERIAL PRIMARY KEY,
    name   CHAR(4) NOT NULL,
    charge CHAR(2) NOT NULL
);

CREATE TABLE pdb_ion
(
    id     SERIAL PRIMARY KEY,
    pdb_id INTEGER NOT NULL REFERENCES pdb (id),
    ion_id INTEGER NOT NULL REFERENCES ion (id),
    count  INTEGER NOT NULL
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
    chi             DOUBLE PRECISION,
    glycosidic_bond GLYCOSIDIC_BOND NOT NULL,
    coordinates     TEXT            NOT NULL
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

CREATE TABLE quadruplex
(
    id          SERIAL PRIMARY KEY,
    onzm        ONZM       NOT NULL,
    subtype     SUBTYPE    NOT NULL,
    loop_class  LOOP_CLASS NOT NULL,
    dot_bracket TEXT       NOT NULL,
    basename    TEXT       NOT NULL
);

CREATE TABLE quadruplex_gba
(
    id                   SERIAL PRIMARY KEY,
    quadruplex_id        INTEGER              NOT NULL REFERENCES quadruplex (id),
    gba_quadruplex_class GBA_QUADRUPLEX_CLASS NOT NULL
);

CREATE TABLE tract
(
    id            SERIAL PRIMARY KEY,
    quadruplex_id INTEGER NOT NULL REFERENCES quadruplex (id)
);

CREATE TABLE tract_nucleotide
(
    id            SERIAL PRIMARY KEY,
    tract_id      INTEGER NOT NULL REFERENCES tract (id),
    nucleotide_id INTEGER NOT NULL REFERENCES nucleotide (id)
);

CREATE TABLE loop
(
    id            SERIAL PRIMARY KEY,
    quadruplex_id INTEGER   NOT NULL REFERENCES quadruplex (id),
    loop_type     LOOP_TYPE NOT NULL
);

CREATE TABLE loop_nucleotide
(
    id            SERIAL PRIMARY KEY,
    loop_id       INTEGER NOT NULL REFERENCES loop (id),
    nucleotide_id INTEGER NOT NULL REFERENCES nucleotide (id)
);

CREATE TABLE tetrad
(
    id                  SERIAL PRIMARY KEY,
    quadruplex_id       INTEGER          NOT NULL REFERENCES quadruplex (id),
    nt1_id              INTEGER          NOT NULL REFERENCES nucleotide (id),
    nt2_id              INTEGER          NOT NULL REFERENCES nucleotide (id),
    nt3_id              INTEGER          NOT NULL REFERENCES nucleotide (id),
    nt4_id              INTEGER          NOT NULL REFERENCES nucleotide (id),
    onz                 ONZ              NOT NULL,
    gba_tetrad_class    GBA_TETRAD_CLASS NOT NULL,
    planarity_deviation REAL             NOT NULL,
    dot_bracket         TEXT             NOT NULL,
    basename            TEXT             NOT NULL
);

CREATE TABLE ion_channel
(
    id        SERIAL PRIMARY KEY,
    ion_id    INTEGER NOT NULL REFERENCES ion (id),
    tetrad_id INTEGER NOT NULL REFERENCES tetrad (id)
);

CREATE TABLE ion_outside
(
    id            SERIAL PRIMARY KEY,
    ion_id        INTEGER NOT NULL REFERENCES ion (id),
    tetrad_id     INTEGER NOT NULL REFERENCES tetrad (id),
    nucleotide_id INTEGER NOT NULL REFERENCES nucleotide (id)
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

CREATE TABLE helix
(
    id          SERIAL PRIMARY KEY,
    dot_bracket TEXT NOT NULL,
    basename    TEXT NOT NULL
);

CREATE TABLE helix_quadruplex
(
    id            SERIAL PRIMARY KEY,
    helix_id      INTEGER NOT NULL REFERENCES helix (id),
    quadruplex_id INTEGER NOT NULL REFERENCES quadruplex (id)
);

CREATE VIEW tetrad_view AS
SELECT t.id,
       t.quadruplex_id,
       t.onz,
       n1.id     AS nt1_id,
       n2.id     AS nt2_id,
       n3.id     AS nt3_id,
       n4.id     AS nt4_id,
       CONCAT(
               UPPER(n1.short_name),
               UPPER(n2.short_name),
               UPPER(n3.short_name),
               UPPER(n4.short_name)
           )     AS sequence,
       (SELECT molecule
        FROM nucleotide
        WHERE id IN (n1.id, n2.id, n3.id, n4.id)
        GROUP BY molecule
        ORDER BY COUNT(*) DESC
        LIMIT 1) AS molecule,
       (SELECT COUNT(DISTINCT chain)
        FROM nucleotide
        WHERE id IN (n1.id, n2.id, n3.id, n4.id)
       )         AS chains
FROM tetrad t
         JOIN nucleotide n1 ON t.nt1_id = n1.id
         JOIN nucleotide n2 ON t.nt2_id = n2.id
         JOIN nucleotide n3 ON t.nt3_id = n3.id
         JOIN nucleotide n4 ON t.nt4_id = n4.id;

CREATE VIEW quadruplex_view AS
SELECT q.id,
       q.onzm,
       q.subtype,
       COUNT(*)  AS count,
       (SELECT molecule
        FROM tetrad_view
        WHERE quadruplex_id = q.id
        GROUP BY molecule
        ORDER BY COUNT(*) DESC
        LIMIT 1) AS molecule,
       (SELECT chains
        FROM tetrad_view
        WHERE quadruplex_id = q.id
        GROUP BY chains
        ORDER BY COUNT(*) DESC
        LIMIT 1) AS chains
FROM quadruplex q
         JOIN tetrad_view t
              ON q.id = t.quadruplex_id
GROUP BY q.id
HAVING COUNT(*) > 1;

CREATE VIEW tetrad_growth_view AS
SELECT p.release_date, COUNT(DISTINCT t.id) as numberOfTetrad
FROM pdb p
         JOIN nucleotide n ON p.id = n.pdb_id
         JOIN tetrad t ON n.id = t.nt1_id
GROUP BY p.release_date
ORDER BY p.release_date DESC;

CREATE VIEW quadruplex_growth_view AS
SELECT p.release_date, COUNT(DISTINCT q.id) as numberOfQuadruplex
FROM pdb p
         JOIN nucleotide n ON p.id = n.pdb_id
         JOIN tetrad t ON n.id = t.nt1_id
         JOIN quadruplex q ON t.quadruplex_id = q.id
GROUP BY p.release_date
ORDER BY p.release_date DESC;

CREATE VIEW helix_growth_view AS
SELECT p.release_date, COUNT(DISTINCT h.id) as numberOfHelix
FROM pdb p
         JOIN nucleotide n ON p.id = n.pdb_id
         JOIN tetrad t ON n.id = t.nt1_id
         JOIN quadruplex q ON t.quadruplex_id = q.id
         JOIN helix_quadruplex hq ON hq.quadruplex_id = q.id
         JOIN helix h ON h.id = hq.helix_id
GROUP BY p.release_date
ORDER BY p.release_date DESC;

CREATE VIEW structure_growth_view AS
SELECT p.release_date, COUNT(*) AS numberOfStructure
FROM pdb p
GROUP BY p.release_date
ORDER BY p.release_date DESC;
