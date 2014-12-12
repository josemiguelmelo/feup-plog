:-use_module(library(random)).
:-use_module(library(sockets)).


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

% player representation
player(a1).
player(b1).

% changes player
next_player(a1, b1).
next_player(b1, a1).

% returns player representation according to Carry parameter. carry(current representation, final representation, Carry)
carry(a1, a1, 1).
carry(a0, a1, 1).
carry(a0, a0, 0).
carry(a1, a0, 0).

carry(b1, b1, 1).
carry(b0, b1, 1).
carry(b0, b0, 0).
carry(b1, b0, 0).

% piece representation
piece(a0).
piece(a1).
piece(a2).
piece(a3).
piece(b0).
piece(b1).
piece(b2).
piece(b3).
piece(p1).
piece(p2).
piece(vv).

% next piece on board when pawn carrying another piece
next_piece(a0, vv, a0).
next_piece(b0, vv, b0).

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
next_piece(a0, a4, a3).

next_piece(b0, p1, b1).
next_piece(b0, p2, b2).
next_piece(b0, b4, b3).



% remove pawn when not carrying a piece
remove_piece(a0, a1, p1).
remove_piece(a0, a2, p2).
remove_piece(a0, a3, a4).
remove_piece(a0, a4, a4).
remove_piece(a0, vv, vv).
remove_piece(a0, p1, p1).
remove_piece(a0, p2, p2).
remove_piece(a0, b1, b1).
remove_piece(a0, b2, b2).
remove_piece(a0, b3, b3).
remove_piece(a0, b4, b4).

remove_piece(b0, a1, a1).
remove_piece(b0, a2, a2).
remove_piece(b0, a3, a3).
remove_piece(b0, a4, a4).
remove_piece(b0, vv, vv).
remove_piece(b0, p1, p1).
remove_piece(b0, p2, p2).
remove_piece(b0, b1, p1).
remove_piece(b0, b2, p2).
remove_piece(b0, b3, b4).
remove_piece(b0, b4, b4).

% remove pawn when carrying a piece
remove_piece(a1, a1, vv).
remove_piece(a1, a2, p2).
remove_piece(a1, a3, a4).
remove_piece(a1, a4, a4).
remove_piece(a1, vv, vv).
remove_piece(a1, p1, p1).
remove_piece(a1, p2, p2).
remove_piece(a1, b1, b1).
remove_piece(a1, b2, b2).
remove_piece(a1, b3, b3).
remove_piece(a1, b4, b4).

remove_piece(b1, b1, vv).
remove_piece(b1, b2, p1).
remove_piece(b1, b3, b4).
remove_piece(b1, b4, b4).
remove_piece(b1, vv, vv).
remove_piece(b1, p1, p1).
remove_piece(b1, p2, p2).
remove_piece(b1, a1, a1).
remove_piece(b1, a2, a2).
remove_piece(b1, a3, a3).
remove_piece(b1, a4, a4).


% end game Counter - counts number of towers a player has
inc_counter(a1, a3, Aux, Counter):- Counter is Aux+1 .
inc_counter(b1, b3, Aux, Counter):- Counter is Aux+1 .
inc_counter(a1, a4, Aux, Counter):- Counter is Aux+1 .
inc_counter(b1, b4, Aux, Counter):- Counter is Aux+1 .

inc_counter(a1, vv, Aux, Counter):- Counter = Aux.
inc_counter(a1, p1, Aux, Counter):- Counter = Aux.
inc_counter(a1, p2, Aux, Counter):- Counter = Aux.
inc_counter(a1, a1, Aux, Counter):- Counter = Aux.
inc_counter(a1, a2, Aux, Counter):- Counter = Aux.
inc_counter(a1, b1, Aux, Counter):- Counter = Aux.
inc_counter(a1, b2, Aux, Counter):- Counter = Aux.
inc_counter(a1, b3, Aux, Counter):- Counter = Aux.
inc_counter(a1, b4, Aux, Counter):- Counter = Aux.

inc_counter(b1, vv, Aux, Counter):- Counter = Aux.
inc_counter(b1, p1, Aux, Counter):- Counter = Aux.
inc_counter(b1, p2, Aux, Counter):- Counter = Aux.
inc_counter(b1, a1, Aux, Counter):- Counter = Aux.
inc_counter(b1, a2, Aux, Counter):- Counter = Aux.
inc_counter(b1, a3, Aux, Counter):- Counter = Aux.
inc_counter(b1, a4, Aux, Counter):- Counter = Aux.
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
elementAt_Line([], Y, Element):- fail.
elementAt_Line([P|Line], 0, P).
elementAt_Line([P| Line], Y, Element):-
	Yaux is Y-1,
	elementAt_Line(Line, Yaux, Element).

elementAt([Line|Tail], 0, Y, Element):-
	elementAt_Line(Line, Y, Element).
elementAt([], X, Y, Element):- fail.
elementAt([Line|Tail], X, Y, Element):-
	Xaux is X-1,
	elementAt(Tail, Xaux, Y, Element).

% not predicate
not(X):- X, !, fail.
not(X).




% get list and number of current availables moves

% available horizontal moves
availableMoves_hor(Board, Player, X, Y, Counter, List, FinalCounter, FinalList):-
	elementAt(Board, X, Y, Elem),
	(Elem==vv; Elem==p1 ; Elem==p2),
	CounterAux is Counter+1,
	append(List, [[X, Y]], ListAux),
	YAux is Y-1,
	YAux >= -1,
	availableMoves_hor(Board, Player, X, YAux, CounterAux, ListAux, FinalCounter, FinalList).
availableMoves_hor(Board, Player, X, Y, Counter, List, FinalCounter, FinalList):-
	YAux is Y-1,
	YAux >= -1,
	availableMoves_hor(Board, Player, X, YAux, Counter, List, FinalCounter, FinalList).
availableMoves_hor(Board, Player, X, Y, Counter, List, FinalCounter, FinalList):-
	FinalCounter is Counter,
	append([], List, FinalList).


% available vertical moves
availableMoves_ver(Board, Player, X, Y, Counter, List, FinalCounter, FinalList):-
	elementAt(Board, X, Y, Elem),
	(Elem==vv; Elem==p1 ; Elem==p2),
	CounterAux is Counter+1,
	append(List, [[X, Y]], ListAux),
	Xaux is X-1,
	Xaux >= -1,
	availableMoves_ver(Board, Player, Xaux, Y, CounterAux, ListAux,  FinalCounter, FinalList).
availableMoves_ver(Board, Player, X, Y, Counter, List, FinalCounter, FinalList):-
	Xaux is X-1,
	Xaux >= -1,
	availableMoves_ver(Board, Player, Xaux, Y, Counter, List, FinalCounter, FinalList).
availableMoves_ver(Board, Player, X, Y, Counter, List, FinalCounter, FinalList):-
	FinalCounter is Counter,
	append([], List, FinalList).

% calls availableMoves_hor and availableMoves_ver to count number of available moves.
availableMoves(Board, Player, AvailMoves, MovesList):-
	currentPlayerPosition(Board, Player, 0, 0, CurrentX, CurrentY),
	availableMoves_hor(Board, Player, CurrentX, 5, 0, [], FinalCounterHor, FinalListHor),
	availableMoves_ver(Board, Player, 5, CurrentY, 0, [], FinalCounterVer, FinalListVer),
	AvailMoves is FinalCounterHor + FinalCounterVer,
	append(FinalListHor, FinalListVer, MovesList).




% possible positions in board, used to determine player position in board
elementPlayer(vv, vv).
elementPlayer(p1, p1).
elementPlayer(p2, p2).
elementPlayer(a0, a1).
elementPlayer(a1, a1).
elementPlayer(a2, a1).
elementPlayer(a3, a1).
elementPlayer(a4, a4).
elementPlayer(b0, b1).
elementPlayer(b1, b1).
elementPlayer(b2, b1).
elementPlayer(b3, b1).
elementPlayer(b4, b4).

% get player current position in board
currentPlayerPosition_Line(Board, Player, CounterX, CounterY, X, Y):-
	elementAt(Board, CounterX, CounterY, Element),
	elementPlayer(Element, P),
	P = Player,
	X is CounterX, Y is CounterY.

currentPlayerPosition(Board, Player, CounterX, CounterY, X, Y):-
	currentPlayerPosition_Line(Board, Player, CounterX, CounterY, X, Y), !.
currentPlayerPosition(Board, Player, CounterX, CounterY, X, Y):-
	NewCounterY is CounterY+1,
	NewCounterY < 5,
	currentPlayerPosition(Board, Player, CounterX, NewCounterY, X, Y), !.
currentPlayerPosition(Board, Player, CounterX, CounterY, X, Y):-
	NewCounterX is CounterX+1,
	NewCounterX < 5,
	NewCounterY is 0,
	currentPlayerPosition(Board, Player, NewCounterX, NewCounterY, X, Y) , !.
currentPlayerPosition(Board, Player, CounterX, CounterY, X, Y):-
	!,fail.



% move pawns

%replace value at position
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).


% move line
move_line([], Y, BoardAux, Player, FinalAux):-
	append( BoardAux, [], FinalAux).

move_line([P|Line], 0, BoardAux, Player, FinalAux):-
	next_piece(Player, P, NextPiece),
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
    write('Move Dest Line (number): '),
    read(XDest), skip_line,
    write('Move Dest Column (number): '),
    read(YDest), skip_line,
    write('Carry 1 piece? (1 - Yes / 0 - No) '),
	read(Carry), skip_line,
	checkMove(Board, XDest, YDest, Player, Carry).


% end game checker. end_game stores number of towers build by the player Player
end_game_line([], Player, CounterAux, Counter):- Counter=CounterAux.
end_game_line([P|Line], Player, CounterAux, Counter):-
	inc_counter(Player, P, CounterAux, CounterFinalAux),
	end_game_line(Line, Player, CounterFinalAux, Counter).

end_game([], Player, CounterAux, FinalCounter):- FinalCounter = CounterAux.
end_game([Line|Tail], Player, CounterAux, FinalCounter):-
	end_game_line(Line, Player, CounterAux, CounterFinalAux),
	end_game(Tail, Player, CounterFinalAux, FinalCounter).

%compare lists
compare([],_).
compare([A1|Tail1], [A2|Tail2]):-
	A1 = A2,
	compare(Tail1, Tail2).

% check if move to position X,Y is possible. Last parameter (0-> not carrying ; 1 -> carrying)
checkMove(Board, X, Y, Player, 0, Stream):-
	X >= 0 , X<5, Y >=0 , Y < 5,
	elementAt(Board, X, Y, Element),
	% check if position is not occupied by opponent
	atom_chars(Element, ElementList),
	not(compare(ElementList, [a,'0'])),
	not(compare(ElementList, [a,'1'])),
	not(compare(ElementList, [a,'2'])),
	not(compare(ElementList, [b,'0'])),
	not(compare(ElementList, [b,'1'])),
	not(compare(ElementList, [b,'2'])),

	% check if it's not a diagonal movement
	currentPlayerPosition(Board, Player, 0, 0, CurrentX, CurrentY),
	(CurrentX == X ; CurrentY == Y).

checkMove(Board,X,Y,Player, 0, Stream):-
	format(Stream, '~q.~n', 'fail'),
	write('fail'),flush_output(Stream),fail.


checkMove(Board, X, Y, Player, 1, Stream):-
	X >= 0 , X<5, Y >=0 , Y < 5,
	elementAt(Board, X, Y, Element),
	% check if position is not occupied by opponent
	atom_chars(Element, ElementList),
	not(compare(ElementList, [a,'0'])),
	not(compare(ElementList, [a,'1'])),
	not(compare(ElementList, [a,'2'])),
	not(compare(ElementList, [b,'0'])),
	not(compare(ElementList, [b,'1'])),
	not(compare(ElementList, [b,'2'])),

	% check if it's not a diagonal movement

	currentPlayerPosition(Board, Player, 0, 0, CurrentX, CurrentY),
	(CurrentX == X ; CurrentY == Y),

	% if current position has 2+ pieces or none
    elementAt(Board, CurrentX, CurrentY, Elem),
    atom_chars(Elem, ElementList1),
	not(compare(ElementList1, [a,'0'])),
	not(compare(ElementList1, [a,'2'])),
	not(compare(ElementList1, [a,'3'])),

	not(compare(ElementList1, [b,'0'])),
	not(compare(ElementList1, [b,'2'])),
	not(compare(ElementList1, [b,'3'])).

checkMove(Board,X,Y,Player, 1, Stream):-
	format(Stream, '~q.~n', 'fail'),
	write('fail'),
	flush_output(Stream), fail.
	


% automatic move (used by computer) - last parameter (1-> horizontal ; 0-> vertical)
move_pc(FinalBoard2, Player, CurrentX, CurrentY, Position, FinalBoard3, CarryPlayer1, Carry, 1):-
	checkMove(FinalBoard2, CurrentX, Position, Player, Carry),

	remove_spawn(FinalBoard2, [], Board2, CarryPlayer1),
	move(Board2, CurrentX, Position, [], FinalBoard3, CarryPlayer1).
	
move_pc(FinalBoard2, Player, CurrentX, CurrentY, Position, FinalBoard3, CarryPlayer1, Carry, 0):-
	checkMove(FinalBoard2, Position, CurrentY, Player, Carry),
	
	remove_spawn(FinalBoard2, [], Board2, CarryPlayer1),

	move(Board2, Position, CurrentY, [], FinalBoard3, CarryPlayer1).


pc_play(Board, Player, FinalBoard):-	
	random(0, 2, Horizontal),
	random(0, 2, Carry),
	random(0, 5, Position),
	currentPlayerPosition(Board, Player, 0, 0, CurrentX, CurrentY),
	carry(Player, CarryPlayer, Carry),
	move_pc(Board, Player, CurrentX, CurrentY, Position, FinalBoard, CarryPlayer, Carry, Horizontal).




% exit Option

game_aux(Board, Player, EndGame, 0).

% 1 vs 1

game_aux(Board, Player, 2, 1):-
	printBoard(Board),
	next_player(Player, NextPlayer),
	write(NextPlayer), write(' won this game!'), nl,
	game(B).

game_aux(Board, Player, EndGame, 1):-
	printBoard(Board),nl,nl,
	write(Player) , write(' '), write('turn. '), nl,

	availableMoves(Board, Player,AvailMoves, MovesList),
	
	write('Possible Moves = '), write(AvailMoves), nl, 
	write('List Moves :'),nl, write(MovesList),nl,nl,

	choose_move_player(Board, Player, X, Y, Carry),
	 % carry a piece with pawn or not
	carry(Player, CarryPlayer, Carry),

	% remove player spawn and move to another position
	remove_spawn(Board, [], FinalBoard, CarryPlayer),
	move(FinalBoard, X,Y, [], FinalBoard1, CarryPlayer),

	% end game checker
	end_game(FinalBoard1, Player, 0, TowerNumber),
	next_player(Player, NextPlayer),
	game_aux(FinalBoard1, NextPlayer, TowerNumber,1).


% 1 vs PC

game_aux(Board, Player, 2, 2):-
	printBoard(Board),
	write(Player), write(' won this game!'), nl,
	game(B).

game_aux(Board, Player, EndGame, 2):-
	printBoard(Board),nl,nl,
	write(Player) , write(' '), write('turn. '), nl,
	choose_move_player(Board, Player, X, Y, Carry),
	 % carry a piece with pawn or not
	carry(Player, CarryPlayer, Carry),
	% remove player spawn and move to another position

	remove_spawn(Board, [], FinalBoard, CarryPlayer),

	move(FinalBoard, X,Y, [], FinalBoard1, CarryPlayer),
	% end game checker
	end_game(FinalBoard1, Player, 0, TowerNumber),

	next_player(Player, NextPlayer),

	% PC movement
	repeat,
	pc_play(FinalBoard1, NextPlayer, FinalBoard3),

	% change player
	next_player(NextPlayer, NextPlayer2),

	game_aux(FinalBoard3, NextPlayer2, TowerNumber,2).


% PC vs PC
game_aux(Board, Player, 2, 3):-
	next_player(Player, NextPlayer),
	printBoard(Board),
	write(NextPlayer), write(' won this game!'), nl,
	game(B).

game_aux(Board, Player, EndGame, 3):-
	read(IN),
	printBoard(Board),nl,nl,
	write(Player) , write(' '), write('turn. '), nl,

	repeat,
	pc_play(Board, Player, Board2),
	end_game(Board2, Player, 0, TowerNumber),

	next_player(Player, NextPlayer),

	printBoard(Board2),nl,nl,
	write(NextPlayer) , write(' '), write('turn. '), nl,

	% PC movement
	repeat,
	pc_play(Board2, NextPlayer, Board3),

	% change player
	next_player(NextPlayer, NextPlayer2),

	game_aux(Board3, NextPlayer2, TowerNumber,3).


% main menu function
main_menu(Option):-
	repeat,
	write('1) 1 vs 1'),nl,
	write('2) 1 vs PC'),nl,
	write('3) PC vs PC'),nl,
	write('0) Exit'),nl,nl,
	write('Option: '),
	read(Option), skip_line.

% game function with init
game(Board):-
	main_menu(Option),
	Option>=0, Option < 4,
	initBoard(Board),
	game_aux(Board, a1, 0, Option).






game_aux(Board, Player, 2, 1, X, Y, Carry, FinalBoard, Stream):-
	printBoard(Board),
	next_player(Player, NextPlayer),
	write(NextPlayer), write(' won this game!'), nl,
	game(B).

game_aux(Board, Player, EndGame, 1, X, Y, Carry, FinalBoard, Stream):-
	printBoard(Board),nl,nl,
	write(Player) , write(' '), write('turn. '), nl,


	checkMove(Board, X, Y, Player, Carry, Stream),

	carry(Player, CarryPlayer, Carry),

	% remove player spawn and move to another position
	remove_spawn(Board, [], FB, CarryPlayer),
	move(FB, X,Y, [], FinalBoard, CarryPlayer).




port(60070).

% launch me in sockets mode
server:-
	port(Port),
	socket_server_open(Port, Socket),
	socket_server_accept(Socket, _Client, Stream, [type(text)]),
	write('Accepted connection'), nl,

	serverLoop(Stream),
	socket_server_close(Socket).


% board, player, x, y, carry,

% wait for commands
serverLoop(Stream) :-
	repeat,
	read(Stream, ClientMsg),
	write('Received: '), write(ClientMsg), nl,
	parse_input(ClientMsg, MyReply, Stream),
	format(Stream, '~q.~n', [MyReply]),
	write('Wrote: '), write(MyReply), nl,
	flush_output(Stream),
	(ClientMsg == quit; ClientMsg == end_of_file), !.

parse_input(comando(Board, Player, X, Y, Carry), Answer, Stream) :-
	comando(Board, Player, X, Y, Carry, Answer,Stream).
	
parse_input(quit, ok-bye) :- !.
		

comando(Board, Player, X, Y, Carry, Answer, Stream) :-
	game_aux(Board, Player, 0, 1, X, Y, Carry, Answer, Stream).
