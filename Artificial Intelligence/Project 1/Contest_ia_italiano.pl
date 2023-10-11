% Student exercise profile
:- set_prolog_flag(occurs_check, error).        % disallow cyclic terms
:- set_prolog_stack(global, limit(8 000 000)).  % limit term space (8Mb)
:- set_prolog_stack(local,  limit(2 000 000)).  % limit environment space

%Questo programma è stato realizzato per aiutare un generico utente ad una corretta assunzione di medicinali
%@copyright Raffaele Pane, Alfonso Moggio, Raffaele Mele 
%Contest del corso di Intelligenza Artificiale basato su SWISH Prolog; prof.ssa Amato 
%****************************************************************************************************%
									%Base di Conoscenza%	
%Ogni utente è identificato da un codice utente nella Base di Conoscenza. La nostra scelta è stata quella di utilizzare
%per un generico utente, come ad esempio Raffaele Verdi, un codice utente 
%così strutturato: nome_abbreviato + cognome_abbreviato + 2 numeri casuali (raffverdi57)
	
username(giacvall12).
username(raffverdi57).
username(angrossi69).
username(nicorazz99).

medicinal(froben).
medicinal(bronchenolo).
medicinal(tachipirina).
medicinal(acetamol).

%Qui sotto troviamo dei predicati chiamati "related" che si occupano di creare un collegamento tra un generico
%utente e la lista degli allergeni ad egli associati. Lo stesso metodo è stato applicato per associare ad un 
%generico medicinale la lista degli ingredienti che lo compongono.
%La seguente è semplicemente una simulazione di una reale applicazione di questa AI.

related(giacvall12,[paracetamolo,fibrinogeno]).
related(raffverdi57,[benzidamina, penicillina]).
related(angrossi69,[bilastina, zinco]).
related(nicorazz99,[zinco,fibrinogeno]).


related(froben, [paracetamolo, bilastina]).
related(bronchenolo, [solfiti, zinco]).
related(tachipirina, [fibrinogeno, benzidamina]).
related(acetamol, [zinco,paracetamolo]).

%****************************************************************************************************%
%Predicato di base del sistema; Valuta se, per un utente U, un medicinale può essere nocivo
deadly_med(U,M):-
      
    custom_list(U,L1),
    flatten(L1,Q1),
   	%write(Q1), nl,
    custom_list(M,L2),
    flatten(L2,Q2),
    write("Il medicinale contiene: "),
    write(Q2), nl,
    match_lists(Q1,Q2).
   

%Matching list: verifica se le liste L1 ed L2 abbiano elementi comuni (utilizzato per il deadly_med)
match_lists(L1,L2):-
    member(E,L1),
    member(E,L2).

%Controlla se un utente X è presente nella Base di Conoscenza
is_id(X):-
    username(X).

%Costruisce liste dai fatti    
custom_list(U,L) :- 
    findall([X,Y],(related(U,[X,Y])),L).

%Controlla se X sia membro di una data lista
member(X,[X|_]).
member(X,[_|T]):-
    member(X,T).

%***************************************************************************************************************%
%Utility predicate: sono utilizzati per simulare un'effettiva conversazione che potrebbe verificarsi tra 
%l'utente e la macchina.
% 'nl' sta a significare 'nuovo rigo' 

hello:-
    write("Ciao, sono qui per assisterti"), nl,
    write("Per favore, inserisci il tuo codice utente per autenticarti..."), nl.

ok_id(X):-
    is_id(X)->(     
    write("***Utente identificato con successo***"), nl,
    write("Benvenuto: "), write(X), nl
    );
    bad_id(),
    endme.
    
%Se l'utente non risulta registrato nel sistema non potrà essere identificato
bad_id():-
    %not(is_id(X)),
    write("***ERRORE GENERICO: ~bad_login_user_not_identifed***").
    

ask_med:-
    write("Indica il medicinale che hai intenzione di assumere...").

ok_med:-
    write("Puoi assumere questo medicinale senza conseguenze"), nl.

bad_med:-
    write("***ATTENZIONE: QUESTO MEDICINALE POTREBBE ESSERE NOCIVO; contatta il tuo medico prima di assumerlo***"), nl.
%******************************************************************************************************%
/*
 * get_med costruisce una lista mediante input dell'utente
*/

get_med([Med|List]):-
    read(Med),
    dif(Med,stop),
    get_med(List).

get_med([]).

endme:-!,fail.
%******************************************************************************************************%
/*
 * Start è stata realizzata per simulare un'interazione tra il sistema ed un utente; sono presenti predicati
 * utili quali 'hello', 'bad_med', ' ok_med' per mostrare all'utente il risultato dell'elaborazione.
 * In fondo, è presente un 'repeat/0' per non far terminare la chat dopo una singola interazione.
*/

start:-
    nl,
    hello,
    read(R),
    ok_id(R)->(   
    ask_med,
    get_med([X]),
    write("Medicinale: "),
    write(X),nl,
    custom_list(R,L),
    flatten(L,Q),
    write("L'utente è allergico a: "),
    write(Q), nl,
    deadly_med(R,X)->
    	(   
    	bad_med, nl
    	);
         (   
    	ok_med, nl
         )
         ),        
    repeat, start.
       
%******************************************************************************************************%
    