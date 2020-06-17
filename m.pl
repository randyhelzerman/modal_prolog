prove(X,_W) :- axiom(X).

prove(X,W) :-
    clause((X:-Y)),
    prove(Y,W).

prove((X,Y),W) :-
    prove(X,W),
    prove(Y,W).

prove((X;Y),W) :-
    prove(X,W)
    ;
    prove(Y,W).

prove((\+ X),W) :-
    \+ prove(X,W).

prove(X,W1) :-
    clause((X :- D=V1)),
    select(D=L1, W1,W2),
    select(V1,L1,L2),
    \+ (member(V2,L2),
`	prove(\+ X, [D=[V2]|W2])).
    
prove(<>(O,X),W1) :-
    accessible(O, W1,W2),
    prove(X, W2).

prove([](O,X),W) :-
    \+ prove(\+ <>(O, \+X), W).

alternative(R1,D=V1,[D=[V2]|R2]) :-
    select(D=L1, R1,R2),
    select(V1,L1,L2),
    member(V2,L2).

axiom(true).

clause((colored :-
	red
	;
	green)).

clause((red :- color=red)).
clause((green :- color=red)).

% belief of fred
red(c1)   :- color_c1 = red.

blue(t1)  :- color_t1 = blue.
green(t1) :- color_t1 = green.

default_world(bel(fred),[]). 

accessible(bel(fred), W0, Wn) :-
    default_world(bel(fred),W1),
    append(W0,W1,W2),
    
    % Fred believes the car is red.
    W3=[color_c1 | W2],
    
    % Fred believes the truck is blue or green.    
    W4 = [[color_t1=blue,colodr_t1=green]|W3],
    
    Wn=W4.
