-- Ex2b
select distinct(c.MATC),(c.TYPEC), c.GRPC, ((to_date(HEUREFC, 'HH24:MI')-to_date(HEUREDC, 'HH24:MI'))*24) as DUREE
from CRENEAU c
where c.MATC is not null;

commit