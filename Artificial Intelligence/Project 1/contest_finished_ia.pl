% Student exercise profile
:- set_prolog_flag(occurs_check, error).        % disallow cyclic terms
:- set_prolog_stack(global, limit(8 000 000)).  % limit term space (8Mb)
:- set_prolog_stack(local,  limit(2 000 000)).  % limit environment space

%This program wants to help a generic user in order to point the user to a correct taking of medicinal(s)
%@copyright Raffaele Pane, Alfonso Moggio, Raffaele Mele 
%IA course contest we based on SWISH Prolog; prof.ssa Amato 
%****************************************************************************************************%
									%Knowledge Base%	
%Each user is identified by username in the KB; we used for a generic user, like Raffaele Verdi, the following
%user-code: short-name+short-surname+two generic numbers
	
username(giacvall12).
username(raffverdi57).
username(angrossi69).
username(nicorazz99).

medicinal(froben).
medicinal(bronchenolo).
medicinal(tachipirina).
medicinal(acetamol).

%Here we have a related predicate that links a generic user with the list of allergens
%The same method has been used for a generic medicinal, linked to its ingredients
%This could be just a simulation of a real application of this AI

related(giacvall12,[paracetamolo,fibrinogeno]).
related(raffverdi57,[benzidamina, penicillina]).
related(angrossi69,[bilastina, zinco]).
related(nicorazz99,[zinco,fibrinogeno]).


related(froben, [paracetamolo, bilastina]).
related(bronchenolo, [solfiti, zinco]).
related(tachipirina, [fibrinogeno, benzidamina]).
related(acetamol, [zinco,paracetamolo]).

%****************************************************************************************************%
%Core-predicate of the system; Evaluates if, for a user U, a medicinal can be deadly
deadly_med(U,M):-
      
    custom_list(U,L1),					% builds lists from facts
    flatten(L1,Q1),						% flatten(+NestedList, -FlatList) Is true if FlatList is a non-nested version of NestedList. 
   	%write(Q1), nl,						% Note that empty lists are removed
    custom_list(M,L2),
    flatten(L2,Q2),
    write("The medicinal contains: "),
    write(Q2), nl,
    match_lists(Q1,Q2).
   

%matching list: if L1 and L2 (lists) have common elements (used for deadly_med)
match_lists(L1,L2):-
    member(E,L1),
    member(E,L2).

%Check if a X user is present of the KB
is_id(X):-
    username(X).

%Builds lists from facts    
custom_list(U,L) :- 
    findall([X,Y],(related(U,[X,Y])),L).

%Check if X is member of a given list
member(X,[X|_]).
member(X,[_|T]):-
    member(X,T).

%***************************************************************************************************************%
%Utility predicate: they are used to simulate a kind but effective chat between the machine and the user
% 'nl' stays for 'new line' 

hello:-
    write("Greetings, I'm here to assist you"), nl,
    write("Please, type your user-code in order to check your identity.."), nl.

ok_id(X):-
    is_id(X)->(     
    write("***User identified successfully***"), nl,
    write("Welcome: "), write(X), nl
    );
    bad_id(),
    endme.
    
%If the user is not registrated in the system, the user can't be identified 
bad_id():-
    %not(is_id(X)),
    write("***GENERIC ERROR: ~bad_login_user_not_identifed***").
    

ask_med:-
    write("Type medicinal(s) you are currently taking..").

ok_med:-
    write("You can take this medicinal without consequences"), nl.

bad_med:-
    write("***WARNING: THIS MEDICINAL CAN BE DANGEROUS; please ask to your doctor before taking***"), nl.
%******************************************************************************************************%
/*
 * get_med builds a list from user input
*/

get_med([Med|List]):-
    read(Med),
    dif(Med,stop),
    get_med(List).

get_med([]).

endme:-!,fail.
%******************************************************************************************************%
/*
 * Start has been created to simulate the interaction between the system and users; there are utility
 * predicates like 'hello', 'bad_med', ' ok_med' to show the user the result of the elaboration.
 * At the end, there is 'repeat/0' to not terminate the chat after a single interaction
*/

start:-
    nl,
    hello,
    read(R),
    ok_id(R)->(   
    ask_med,
    get_med([X]),
    write("Medicinal: "),
    write(X),nl,
    custom_list(R,L),
    flatten(L,Q),
    write("This user is allergic to: "),
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
    
  
              
               

    
    
  


