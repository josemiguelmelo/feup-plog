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
