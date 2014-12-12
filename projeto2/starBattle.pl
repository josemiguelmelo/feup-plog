:- use_module(library(clpfd)).
:- use_module(library(lists)).

element_at(X,[X|_],1).
element_at(X,[_|L],K) :- element_at(X,L,K1), K is K1 + 1.

removeHead([_|Tail], Tail).

not(X):- X, !, fail.
not(X).

removeDiagonals(List, 1).

removeDiagonals(List, Count):-
	element(1, List, First),
	element(2, List, Second),

	Second #\= First+1,
	Second #\= First-1,

	removeHead(List, Tail),

	length(Tail, NewCount),

	removeDiagonals(Tail, NewCount).


getStarRegions([], [], AuxList, AuxList).

getStarRegions([FirstStar | StarsTail], [FirstList | ListTail], AuxList, FinalList):-
	element(FirstStar, FirstList, FirstStarRegion),

	append(AuxList, [FirstStarRegion], NewFinalList),

	getStarRegions(StarsTail, ListTail, NewFinalList, FinalList).


checkLengthsAux(StarsCount, RegionCount):-
	StarsCount == RegionCount.

checkLengthsAux(StarsCount, RegionCount):-	
	write('ERROR: There should be as many stars as rows in the board.'), nl,
	fail.

checkLengthsInternal(Stars,[]).
checkLengthsInternal(Stars, [RegionHead | RegionTail]):-
	length(Stars, StarsCount),
	length(RegionHead, RegionCount),
	checkLengthsAux(StarsCount, RegionCount), !,
	checkLengthsInternal(Stars, RegionTail).

checkLengths(Stars, List):-
	length(Stars, StarsCount),
	length(List, RegionCount),
	StarsCount == RegionCount.
checkLengths(Stars, List):-
	write('ERROR: There should be as many stars as rows in the board.'), nl,
	fail.

printBoard(B) :-
    printBoardAux(B).
 
printBoardAux([]).
 
printBoardAux( [X | B] ) :-
    printLine(X),
    printBoardAux(B).
 
printLine([]):-
    nl.
 
printLine([X | B]) :-
    print(X),
    print(' | '),
    printLine(B).

solvePuzzle(Stars, Region) :-
	checkLengths(Stars, Region), !,
	checkLengthsInternal(Stars, Region), !,

	length(Stars, StarsCount),
	domain(Stars, 1, StarsCount),

	all_different(Stars),

	removeDiagonals(Stars, StarsCount),

	getStarRegions(Stars, Region, [], StarRegions),

	all_different(StarRegions),

	labeling([], Stars).

%solvePuzzle([First, Second, Third, Fourth], [[1, 2, 1, 1], [1, 1, 1, 3], [4, 1, 1, 1], [1, 1, 1, 1]]).
%solvePuzzle([First, Second, Third, Fourth, Fifth], [[1, 1, 2, 2, 2], [1, 2, 2, 3, 2], [1, 2, 2, 2, 2], [4, 2, 4, 2, 5], [4, 4, 4, 5, 5]]).
