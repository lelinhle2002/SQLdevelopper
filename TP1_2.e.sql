select salle.nsalle, salle.tsal, salle.capacite
from SALLE
inner join affecter on affecter.nsalle = salle.nsalle
where affecter.jourc like 'mardi'
and affecter.debsemc like '05/12/16'
and affecter.heuredc like '09:30'
order by salle.nsalle;
commit;