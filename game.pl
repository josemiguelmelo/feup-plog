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


player(a1).
player(b1).
next_player(a1, b1).
next_player(b1, a1).

piece(a1).
piece(a2).
piece(a3).
piece(b1).
piece(b2).
piece(b3).
piece(p1).
piece(p2).
piece(vv).

next_piece(a1, p1, a2).
next_piece(a2, p1, a3).
next_piece(b1, p1, b2).
next_piece(b2, p1, b3).
next_piece(a1, vv, a1).
next_piece(b1, vv, b1).


remove_piece(a1, a1, vv).
remove_piece(a1, a2, p1).
remove_piece(a1, a3, a3).
remove_piece(a1, vv, vv).
remove_piece(a1, p1, p1).
remove_piece(a1, p2, p2).

remove_piece(a1, b1, b1).
remove_piece(a1, b2, b2).
remove_piece(a1, b3, b3).




remove_piece(b1, b1, vv).
remove_piece(b1, b2, p1).
remove_piece(b1, b3, b3).
remove_piece(b1, vv, vv).
remove_piece(b1, p1, p1).
remove_piece(b1, p2, p2).

remove_piece(b1, a1, a1).
remove_piece(b1, a2, a2).
remove_piece(b1, a3, a3).


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


% move line
move_line([], Y, BoardAux, Player, FinalAux):-
	append( BoardAux, [], FinalAux).

move_line([P|Line], 0, BoardAux, Player, FinalAux):-
	next_piece(Player, P , NextPiece),
	append(BoardAux, [NextPiece], Aux),
	Yaux is -1,
	move_line(Line, Yaux, Aux, Player, FinalAux).

move_line([P|Line], Y, BoardAux, Player, FinalAux):-
	append(BoardAux, [P], Aux),
	Yaux is Y-1,
	move_line(Line, Yaux, Aux, Player, FinalAux).

% move pawn to (X, Y)
move([], X, Y, BoardAux, FinalBoard, Player):-
	append([], BoardAux, FinalBoard).

move([Line|Tail], 0, Y, BoardAux, FinalBoard, Player):-
	move_line(Line, Y, [], Player, FinalLine),
	append(BoardAux, [FinalLine], Aux),
	Xaux is -1,
	move(Tail, Xaux, Y, Aux, FinalBoard, Player).

move([Line|Tail], X, Y, BoardAux, FinalBoard, Player):-
	append(BoardAux, [Line], Aux),
	Xaux is X-1,
	move(Tail, Xaux, Y, Aux, FinalBoard, Player).


% remove spawn from board. 
remove_spawn_line([], BoardAux, Player, FinalLine):-
	append([], BoardAux, FinalLine).

remove_spawn_line([P|Line], BoardAux,Player, FinalLine):-
	remove_piece(Player, P, NewPiece),
	append(BoardAux, [NewPiece], Aux),
	remove_spawn_line(Line, Aux, Player, FinalLine).


remove_spawn([], BoardAux, FinalBoard, Player):-
	append([], BoardAux, FinalBoard).

remove_spawn([Line|Tail], BoardAux, FinalBoard, Player):-
	remove_spawn_line(Line, [], Player, FinalLine),
	append(BoardAux, [FinalLine], Aux),
	remove_spawn(Tail, Aux, FinalBoard, Player).

% return the value to insert at position where to move to
nextPositionValue(Board, X, Y, Value, Pawn):-
	nth0(X, Board, Line), nth0(Y, Line, Element),
	(Element==vv -> Value is Pawn; P).

% read from terminal position where to move to
choose_move_player(Board, Player, XDest, YDest) :-
    write('Move Dest Line (number): '),
    read(XDest), skip_line,
    write('Move Dest Column (letter): '),
    read(YDest), skip_line,
    checkPosition(Board, XDest, YDest).


% game auxiliar function, no init
game_aux(Board, Player):-
	printBoard(Board),nl,nl,
	write(Player) , write(' '), write('turn. '), nl,
	choose_move_player(Board, Player, X, Y),
	remove_spawn(Board, [], FinalBoard, Player),
	write(FinalBoard),nl,
	move(FinalBoard, X,Y, [], FinalBoard1, Player),
	next_player(Player, NextPlayer),
	game_aux(FinalBoard1, NextPlayer).

% game function with init
game(Board):-
	initBoard(Board),
	game_aux(Board, a1).