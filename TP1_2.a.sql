-- Ex2a
select c.GRPC, EFF
from (GROUPE g
inner join CRENEAU c on g.GRPC = c.GRPC)
where (c.MATC like 'InM1101'
and c.DEBSEMC like '19/09/16'
and c.JOURC like 'mercredi'
and c.HEUREDC like '11:00');

commit