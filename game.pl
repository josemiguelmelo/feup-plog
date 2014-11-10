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

carry(a1, a1, 1).
carry(a0, a1, 1).
carry(a0, a0, 0).
carry(a1, a0, 0).

carry(b1, b1, 1).
carry(b0, b1, 1).
carry(b0, b0, 0).
carry(b1, b0, 0).


piece(a1).
piece(a2).
piece(a3).
piece(b1).
piece(b2).
piece(b3).
piece(p1).
piece(p2).
piece(vv).

% next piece on board when pawn carrying another piece
next_piece(a1, p1, a2).
next_piece(a2, p1, a3).
next_piece(a1, p2, a3).
next_piece(b1, p1, b2).
next_piece(b2, p1, b3).
next_piece(b1, p2, b3).
next_piece(a1, vv, a1).
next_piece(b1, vv, b1).


% next piece on board when pawn not carrying another piece
next_piece(a0, p1, a1).
next_piece(a0, p2, a2).
next_piece(b0, p1, b1).
next_piece(b0, p2, b2).
next_piece(a0, vv, a0).
next_piece(b0, vv, b0).


% remove pawn when not carrying a piece
remove_piece(a0, a1, p1).
remove_piece(a0, a2, p2).
remove_piece(a0, a3, a3).
remove_piece(a0, vv, vv).
remove_piece(a0, p1, p1).
remove_piece(a0, p2, p2).
remove_piece(a0, b1, b1).
remove_piece(a0, b2, b2).
remove_piece(a0, b3, b3).

remove_piece(b0, a1, a1).
remove_piece(b0, a2, a2).
remove_piece(b0, a3, a3).
remove_piece(b0, vv, vv).
remove_piece(b0, p1, p1).
remove_piece(b0, p2, p2).
remove_piece(b0, b1, p1).
remove_piece(b0, b2, p2).
remove_piece(b0, b3, b3).

% remove pawn when carrying a piece
remove_piece(a1, a1, vv).
remove_piece(a1, a2, p2).
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


% end game Counter - counts number of towers a player has
inc_counter(a1, a3, Aux, Counter):- Counter is Aux+1 .
inc_counter(b1, b3, Aux, Counter):- Counter is Aux+1 .

inc_counter(a1, vv, Aux, Counter):- Counter = Aux.
inc_counter(a1, p1, Aux, Counter):- Counter = Aux.
inc_counter(a1, p2, Aux, Counter):- Counter = Aux.
inc_counter(a1, a1, Aux, Counter):- Counter = Aux.
inc_counter(a1, a2, Aux, Counter):- Counter = Aux.
inc_counter(a1, b1, Aux, Counter):- Counter = Aux.
inc_counter(a1, b2, Aux, Counter):- Counter = Aux.
inc_counter(a1, b3, Aux, Counter):- Counter = Aux.

inc_counter(b1, vv, Aux, Counter):- Counter = Aux.
inc_counter(b1, p1, Aux, Counter):- Counter = Aux.
inc_counter(b1, p2, Aux, Counter):- Counter = Aux.
inc_counter(b1, a1, Aux, Counter):- Counter = Aux.
inc_counter(b1, a2, Aux, Counter):- Counter = Aux.
inc_counter(b1, a3, Aux, Counter):- Counter = Aux.
inc_counter(b1, b1, Aux, Counter):- Counter = Aux.
inc_counter(b1, b2, Aux, Counter):- Counter = Aux.


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


%element at position X, Y
elementAt_Line([], Y, Element):- Element is 0.
elementAt_Line([P|Line], 0, P).
elementAt_Line([P| Line], Y, Element):-
	Yaux is Y-1,
	elementAt_Line(Line, Yaux, Element).

elementAt([Line|Tail], 0, Y, Element):-
	elementAt_Line(Line, Y, Element).

elementAt([], X, Y, Element):-
	Element is 0.

elementAt([Line|Tail], X, Y, Element):-
	Xaux is X-1,
	elementAt(Tail, Xaux, Y, Element).


% move pawns

%replace value at position
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).


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

% read from terminal position where to move to
choose_move_player(Board, Player, XDest, YDest, Carry) :-
	repeat,
	write('Carry 1 piece? (1 - Yes / 0 - No) '),
	read(Carry), skip_line,
    write('Move Dest Line (number): '),
    read(XDest), skip_line,
    write('Move Dest Column (letter): '),
    read(YDest), skip_line.


% end game checker. end_game stores number of towers build by the player Player
end_game_line([], Player, CounterAux, Counter):- Counter=CounterAux.
end_game_line([P|Line], Player, CounterAux, Counter):-
	inc_counter(Player, P, CounterAux, CounterFinalAux),
	end_game_line(Line, Player, CounterFinalAux, Counter).

end_game([], Player, CounterAux, FinalCounter):- FinalCounter = CounterAux.
end_game([Line|Tail], Player, CounterAux, FinalCounter):-
	end_game_line(Line, Player, CounterAux, CounterFinalAux),
	end_game(Tail, Player, CounterFinalAux, FinalCounter).



checkMove(Board, X, Y):-
	X >0 , X< 6, Y >0 , Y < 6,
	elementAt(Board, X, Y, Element),
	Element\=b1, Element\=b2, Element\=b0.


% game auxiliar function (no init board)
game_aux(Board, Player, 3):-
	next_player(Player, NextPlayer),
	write(NextPlayer), write(' won this game!'), nl.

game_aux(Board, Player, EndGame):-
	printBoard(Board),nl,nl,
	write(Player) , write(' '), write('turn. '), nl,
	choose_move_player(Board, Player, X, Y, Carry),
	 % carry a piece with pawn or not
	carry(Player, CarryPlayer, Carry),
	checkMove(Board, X, Y),
	% remove player spawn and move to another position
	remove_spawn(Board, [], FinalBoard, CarryPlayer),
	move(FinalBoard, X,Y, [], FinalBoard1, CarryPlayer),

	% end game checker
	end_game(FinalBoard1, Player, 0, TowerNumber),

	next_player(Player, NextPlayer),
	game_aux(FinalBoard1, NextPlayer, TowerNumber).

% game function with init
game(Board):-
	initBoard(Board),
	game_aux(Board, a1, 0).