create view NbHdispenseParEnseignant as
select enseignant.idenseign, SUM(decode(creneau.typec, 'CM',1.5,'TD',1,0)) as NBH
from enseigner
inner join ENSEIGNANT on ENSEIGNANT.IDENSEIGN = enseigner.IDENSEIGN
inner join creneau on creneau.grpc = enseigner.grpc
group by ENSEIGNANT.IDENSEIGN;


select *
from nbhdispenseparenseignant
order by idenseign asc;
commit;