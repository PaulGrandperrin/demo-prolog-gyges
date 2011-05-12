%Coordonnées d'une case: [x,y] avec x et y entre 1 et 6
%Coup: [depart,arrivé] ou [depart,arrivé,nouvelleCaseDuPionDéplacé]
%Lien: [caseA,caseB]

plateau_depart([[[1,4],[1,6],[6,1],[6,6]],[[1,3],[1,5],[6,2],[6,5]],[[1,1],[1,2],[6,3],[6,4]],s]).


pions_simple(Plateau,Pions):-nth(1,Plateau,Pions).
pions_double(Plateau,Pions):-nth(2,Plateau,Pions).
pions_triple(Plateau,Pions):-nth(3,Plateau,Pions).

affiche_elem(Plateau,Position):-pions_simple(Plateau,Pions),member(Position,Pions),write(' 1 '),!. %rouge
affiche_elem(Plateau,Position):-pions_double(Plateau,Pions),member(Position,Pions),write(' 2 '),!. %rouge
affiche_elem(Plateau,Position):-pions_triple(Plateau,Pions),member(Position,Pions),write(' 3 '),!. %rouge
affiche_elem(_,_):-write(' . ').

affiche_ligne(Plateau,Ligne):-
	write('\t|'),
	affiche_elem(Plateau,[Ligne,1]),
	affiche_elem(Plateau,[Ligne,2]),
	affiche_elem(Plateau,[Ligne,3]),
	affiche_elem(Plateau,[Ligne,4]),
	affiche_elem(Plateau,[Ligne,5]),
	affiche_elem(Plateau,[Ligne,6]),
	write('|\n').

affiche_plateau(Plateau):-
	write('\t+------------------+\n'),
	affiche_ligne(Plateau,6),
	affiche_ligne(Plateau,5),
	affiche_ligne(Plateau,4),
	affiche_ligne(Plateau,3),
	affiche_ligne(Plateau,2),
	affiche_ligne(Plateau,1),
	write('\t+------------------+\n').


position_occupee(Plateau,Position):-pions_simple(Plateau,Pions),member(Position,Pions),!. %vert
position_occupee(Plateau,Position):-pions_double(Plateau,Pions),member(Position,Pions),!. %vert
position_occupee(Plateau,Position):-pions_triple(Plateau,Pions),member(Position,Pions),!. %vert

plusun(1,2).
plusun(2,3).
plusun(3,4).
plusun(4,5).
plusun(5,6).

deplacement_gauche([DX,Y],[AX,Y]):-plusun(AX,DX).
deplacement_droite([DX,Y],[AX,Y]):-plusun(DX,AX).
deplacement_haut([X,DY],[X,AY]):-plusun(AY,DY).
deplacement_bas([X,DY],[X,AY]):-plusun(DY,AY).

deplacement_sur_plateau([DX,DY],[AX,AY]):-deplacement_gauche([DX,DY],[AX,AY]).
deplacement_sur_plateau([DX,DY],[AX,AY]):-deplacement_droite([DX,DY],[AX,AY]).
deplacement_sur_plateau([DX,DY],[AX,AY]):-deplacement_haut([DX,DY],[AX,AY]).
deplacement_sur_plateau([DX,DY],[AX,AY]):-deplacement_bas([DX,DY],[AX,AY]).

deplacement_possible_vers_libre(Plateau,Trajet,[DX,DY],[AX,AY]):-
	deplacement_sur_plateau([DX,DY],[AX,AY]),
	\+(position_occupee(Plateau,[AX,AY])),
	\+(member([[DX,DY],[AX,AY]],Trajet)),\+(member([[AX,AY],[DX,DY]],Trajet)).	%Passe pas par la meme ligne

deplacement_possible_vers_occupee(Plateau,Trajet,[DX,DY],[AX,AY]):-
	deplacement_sur_plateau([DX,DY],[AX,AY]),
	position_occupee(Plateau,[AX,AY]),
	\+(member([[DX,DY],[AX,AY]],Trajet)),\+(member([[AX,AY],[DX,DY]],Trajet)).	%Passe pas par la meme ligne


coup_simple_vers_libre(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_simple(Plateau,Pions_simple),member(Depart,Pions_simple),	%Le pion de départ est un pion simple
	deplacement_possible_vers_libre(Plateau,TrajetAvant,Depart,Arrive),TrajetApres=[[Depart,Arrive]|TrajetAvant].

coup_simple_vers_libre(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_double(Plateau,Pions_double),member(Depart,Pions_double),	%Le pion de départ est un pion double
	deplacement_possible_vers_libre(Plateau,TrajetAvant,Depart,Intermediaire),TrajetInter=[[Depart,Intermediaire]|TrajetAvant],
	deplacement_possible_vers_libre(Plateau,TrajetInter,Intermediaire,Arrive),TrajetApres=[[Intermediaire,Arrive]|TrajetInter].

coup_simple_vers_libre(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_triple(Plateau,Pions_triple),member(Depart,Pions_triple),	%Le pion de départ est un pion triple
	deplacement_possible_vers_libre(Plateau,TrajetAvant,Depart,Intermediaire1),TrajetInter1=[[Depart,Intermediaire1]|TrajetAvant],
	deplacement_possible_vers_libre(Plateau,TrajetInter1,Intermediaire1,Intermediaire2),TrajetInter2=[[Intermediaire1,Intermediaire2]|TrajetInter1],
	deplacement_possible_vers_libre(Plateau,TrajetInter2,Intermediaire2,Arrive),TrajetApres=[[Intermediaire2,Arrive]|TrajetInter2].


coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_simple(Plateau,Pions_simple),member(Depart,Pions_simple),	%Le pion de départ est un pion simple
	deplacement_possible_vers_occupee(Plateau,TrajetAvant,Depart,Arrive),TrajetApres=[[Depart,Arrive]|TrajetAvant].

coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_double(Plateau,Pions_double),member(Depart,Pions_double),	%Le pion de départ est un pion double
	deplacement_possible_vers_libre(Plateau,TrajetAvant,Depart,Intermediaire),TrajetInter=[[Depart,Intermediaire]|TrajetAvant],
	deplacement_possible_vers_occupee(Plateau,TrajetInter,Intermediaire,Arrive),TrajetApres=[[Intermediaire,Arrive]|TrajetInter].

coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_triple(Plateau,Pions_triple),member(Depart,Pions_triple),	%Le pion de départ est un pion triple
	deplacement_possible_vers_libre(Plateau,TrajetAvant,Depart,Intermediaire1),TrajetInter1=[[Depart,Intermediaire1]|TrajetAvant],
	deplacement_possible_vers_libre(Plateau,TrajetInter1,Intermediaire1,Intermediaire2),TrajetInter2=[[Intermediaire1,Intermediaire2]|TrajetInter1],
	deplacement_possible_vers_occupee(Plateau,TrajetInter2,Intermediaire2,Arrive),TrajetApres=[[Intermediaire2,Arrive]|TrajetInter2].


%%%

%coup_valide(Plateau,Trajet, Coup):-	Coup = [Depart,Arrive],		%Coup dans remplacement
					


%coup_valide(Plateau,Trajet, Coup):-Coup = [Depart,Arrivee,Deplacement].

