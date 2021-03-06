input_edge :-
    read(X),
    read(Y),
    add_edge(X, Y).

add_edge(stop, stop) :- !.

add_edge(X, Y) :-
    assertz(connected(X, Y)),
    input_edge.

consed( Tail, Head, [Head|Tail]).

bfs(Goal, [Visited|Rest], Path) :-           
    Visited = [Start|_],         
    Start \== Goal,
    findall(X, (connected(Start, X), \+ member(X, Visited)), [T|Extend]),
    maplist( consed(Visited), [T|Extend], VisitedExtended),  
    append( Rest, VisitedExtended, UpdatedQueue), 
    (bfs( Goal, UpdatedQueue, Path );
    removehead(UpdatedQueue, Tail), 
    bfs(Goal, Tail, Path);
    processqueue( Goal, UpdatedQueue, Path )).

processqueue(Goal, [X|Tail], Path):-
    (equalset(X, [Goal|_]),
    reverse(X, Path); 
    processqueue(Goal, Tail, Path)).

equalset(sl,sl).
equalset([A|L],L1):-del(A,L1,L2), equalset(L,L2).
equalset([],[]).

del(symbol,sl,sl).
del(A,[A|L],L):- !.
del(A,[A|L],[A|L1]):- del(A,L,L1).

removehead([_|Tail], Tail).

breadthfirst( Start, Goal, Path):-
    bfs( Goal, [[Start]], Path).

main :- 
    retractall(connected(X, Y)),
    write('Input all vertexes: '),
    input_edge,
    write('Input start vertex: '),
    read(X),
    write('Input finish vertex: '),
    read(Y), 
    breadthfirst(X, Y, Path), 
    write('Path: '), write(Path), nl.