CREATE USER qbase;
ALTER USER qbase WITH PASSWORD 'Jellux37';

GRANT ALL ON DATABASE qbase TO qbase;

\connect qbase;

GRANT ALL ON pdb TO qbase;
GRANT ALL ON nucleotide TO qbase;
GRANT ALL ON tetrade TO qbase;
GRANT ALL ON quadruplex TO qbase;
GRANT ALL ON quadruplex_tetrade TO qbase;
GRANT ALL ON base_pair TO qbase;
GRANT ALL ON intertetrade_parameters TO qbase;
