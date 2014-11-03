% get element at position N
nth0(0, [Head|_], Head) :- !.

nth0(N, [_|Tail], Elem) :-
    nonvar(N),
    M is N-1,
    nth0(M, Tail, Elem).

nth0(N,[_|T],Item) :-       % Clause added KJ 4-5-87 to allow mode
    var(N),         % nth0(-,+,+)
    nth0(M,T,Item),
    N is M + 1.




%print board
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
%----------------------------------------


% initialize board with initial values
initBoard(Board):-
	append([],[
	[p1, p1, p1, p1, a1],
	[p1, p1, p1, p1, p1],
	[p1, p1, p1, p1, p1],
	[p1, p1, p1, p1, p1],
	[b1, p1, p1, p1, p1]
	], Board).
%-------------------------------------

% move pawns

%replace value at position
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

% check if position is valid
checkPosition(Board, X, Y):-
	nth0(X, Board, Line), nth0(Y, Line, Element),
	(Element == vv ; Element == p1).


move([], Xinitial,Yinitial, Xfinal,Yfinal, BoardAux, FinalBoard, Counter, Player):-
	append(BoardAux,[], FinalBoard).
% falta ver para que valor a alterar
move([Line|Tail], Xinitial,Yinitial, Xfinal,Yfinal, BoardAux, FinalBoard, Counter, Player):-
	Xinitial > 0 , Yinitial > 0, Xfinal > 0 , Yfinal > 0,
	Xinitial < 6 , Yinitial < 6, Xfinal < 6 , Yfinal < 6,
	(Counter==Xinitial -> 
			
		replace(Line, Yinitial, Player, FinalLine),
		C is Counter+1,
		append(BoardAux,[FinalLine], Aux),
		move(Tail, Xinitial,Yinitial, Xfinal,Yfinal, Aux, FinalBoard, C, Player);


		append(BoardAux,[Line], Aux), 
		C is Counter+1,
		move(Tail, Xinitial,Yinitial, Xfinal,Yfinal, Aux, FinalBoard, C, Player)
	).

% return the value to insert at position where to move to
nextPositionValue(Board, X, Y, Value, Pawn):-
	nth0(X, Board, Line), nth0(Y, Line, Element),
	(Element==vv -> Value is Pawn; P).

% read from terminal position where to move to
choose_move_player(Board, Player, XDest, YDest) :-
	repeat,
    write('Move Dest Line (number): '),
    read(XDest), skip_line,
    write('Move Dest Column (letter): '),
    read(YDest), skip_line,
    checkPosition(Board, XDest, YDest).

player(a1).
player(b1).
next_player(player1, player2).
next_player(player2, player1).

% game auxiliar function, no init
game_aux(Board, Player):-
	printBoard(Board),nl,nl,
	write(Player) , write(' '), write('turn. '), nl,
	choose_move_player(Board, Player, X, Y),
	move(Board, X,Y, X,Y, [], FinalBoard, 0,Player),
	next_player(Player, NextPlayer),
	game_aux(FinalBoard, NextPlayer).

% game function with init
game(Board):-
	initBoard(Board),
	game_aux(Board, player1).