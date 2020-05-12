function output = prova(input)

%esiste già la variabile nella workspace?
ise = evalin( 'base', 'exist(''k'',''var'') == 0' );
%se non esiste la creo,quindi setto il valore iniziale
if ise
    k = 0;
%altrimenti leggo il valore dalla workspace
else
    k = evalin('base', 'k');
end
output = input * k
%salvo il nuovo valore nella workspace
assignin('base','k',k+1) 
end

