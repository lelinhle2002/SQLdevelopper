create or replace function LISTEENSEIGNANTS return sys_refcursor as 
curEns sys_refcursor ; 
begin 
open curEns for select NOM, GRADE FROM ENSEIGNANT WHERE NBHDISP >0;
return curEns ; 
end LISTEENSEIGNANTS ; 