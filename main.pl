%Coordonnées d'une case: [x,y] avec x et y entre 1 et 6
%Coup: [depart,arrivé] ou [depart,arrivé,nouvelleCaseDuPionDéplacé]
%Lien: [caseA,caseB]

not(P) :- P, !, fail .
not(P).

pions_simple(Plateau,Pions):-nth(1,Plateau,Pions).
pions_double(Plateau,Pions):-nth(2,Plateau,Pions).
pions_triple(Plateau,Pions):-nth(3,Plateau,Pions).

affiche_elem(Plateau,Position):-pions_simple(Plateau,Pions),member(Position,Pions),write(' 1 '),!. %rouge
affiche_elem(Plateau,Position):-pions_double(Plateau,Pions),member(Position,Pions),write(' 2 '),!. %rouge
affiche_elem(Plateau,Position):-pions_triple(Plateau,Pions),member(Position,Pions),write(' 3 '),!. %rouge
affiche_elem(Plateau,Position):-write(' . ').

affiche_ligne(Plateau,Ligne):-	write('\t|'),
				affiche_elem(Plateau,[Ligne,1]),
				affiche_elem(Plateau,[Ligne,2]),
				affiche_elem(Plateau,[Ligne,3]),
				affiche_elem(Plateau,[Ligne,4]),
				affiche_elem(Plateau,[Ligne,5]),
				affiche_elem(Plateau,[Ligne,6]),
				write('|\n').

affiche_plateau(Plateau):-	write('\t+------------------+\n'),
				affiche_ligne(Plateau,6),
				affiche_ligne(Plateau,5),
				affiche_ligne(Plateau,4),
				affiche_ligne(Plateau,3),
				affiche_ligne(Plateau,2),
				affiche_ligne(Plateau,1),
				write('\t+------------------+\n').


plateau_depart([[[1,4],[1,6],[6,1],[6,6]],[[1,3],[1,5],[6,2],[6,5]],[[1,1],[1,2],[6,3],[6,4]],s]).


position_occupee(Plateau,Position):-pions_simple(Plateau,Pions),member(Position,Pions),!. %vert
position_occupee(Plateau,Position):-pions_double(Plateau,Pions),member(Position,Pions),!. %vert
position_occupee(Plateau,Position):-pions_triple(Plateau,Pions),member(Position,Pions),!. %vert

position_sur_plateau([X,Y]):-X>=1,X=<6,Y>=1,Y=<6.

deplacement_possible_vers_libre(Plateau,Trajet,[DX,DY],[AX,AY]):-	not(position_occupee(Plateau,[AX,AY])),
									not(member([[DX,DY],[AX,AY]],Trajet)),not(member([[[AX,AY],DX,DY]],Trajet)),	%Passe pas par la meme ligne
									position_sur_plateau([DX,DY]),
									position_sur_plateau([AX,AY]),
									(abs(DX-AX)+abs(DY-AY))=:=1.

deplacement_possible_vers_occupe(Plateau,Trajet,[DX,DY],[AX,AY]):-	position_occupee(Plateau,[AX,AY]),
									%not(member([[DX,DY],[AX,AY]],Trajet)),not(member([[[AX,AY],DX,DY]],Trajet)),	%Passe pas par la meme ligne
									position_sur_plateau([DX,DY]),
									position_sur_plateau([AX,AY]),
									(abs(DX-AX)+abs(DY-AY))=:=1.


coup_simple_vers_libre(Plateau,Trajet,Depart,Arrive):-	pions_simple(Plateau,Pions_simple),member(Depart,Pions_simple),	%Le pion de départ est un pion simple
							deplacement_possible_vers_libre(Plateau,TrajetInter,Depart,Arrive),Trajet=[[Depart,Arrive],TrajetInter]. %Peut etre inverser les trucs

coup_simple_vers_libre(Plateau,Trajet,Depart,Arrive):-	pions_double(Plateau,Pions_double),member(Depart,Pions_double),	%Le pion de départ est un pion double
							deplacement_possible_vers_libre(Plateau,TrajetInter2,Depart,Intermediaire),TrajetInter1=[[Depart,Intermediaire],TrajetInter2],
							deplacement_possible_vers_libre(Plateau,TrajetInter1,Intermediaire,Arrive),Trajet=[[Intermediaire,Arrive],TrajetInter1].

coup_simple_vers_libre(Plateau,Trajet,Depart,Arrive):-	pions_triple(Plateau,Pions_triple),member(Depart,Pions_triple),	%Le pion de départ est un pion triple
							deplacement_possible_vers_libre(Plateau,TrajetInter3,Depart,Intermediaire1),TrajetInter2=[[Depart,Intermediaire1],TrajetInter3],
							deplacement_possible_vers_libre(Plateau,TrajetInter2,Intermediaire1,Intermediaire2),TrajetInter1=[[Intermediaire1,Intermediaire2],TrajetInter2].
							deplacement_possible_vers_libre(Plateau,TrajetInter1,Intermediaire2,Arrive),Trajet=[[Intermediaire2,Arrive],TrajetInter1].

coup_simple_vers_occupe(Plateau,Trajet,Depart,Arrive):-	pions_simple(Plateau,Pions_simple),member(Depart,Pions_simple),	%Le pion de départ est un pion simple
							deplacement_possible_vers_occupe(Plateau,TrajetInter,Depart,Arrive),Trajet=[[Depart,Arrive],TrajetInter]. %Peut etre inverser les trucs

coup_simple_vers_occupe(Plateau,Trajet,Depart,Arrive):-	pions_double(Plateau,Pions_double),member(Depart,Pions_double),	%Le pion de départ est un pion double
							deplacement_possible_vers_libre(Plateau,TrajetInter2,Depart,Intermediaire),TrajetInter1=[[Depart,Intermediaire],TrajetInter2],
							deplacement_possible_vers_occupe(Plateau,TrajetInter1,Intermediaire,Arrive),Trajet=[[Intermediaire,Arrive],TrajetInter1].

coup_simple_vers_occupe(Plateau,Trajet,Depart,Arrive):-	pions_triple(Plateau,Pions_triple),member(Depart,Pions_triple),	%Le pion de départ est un pion triple
							deplacement_possible_vers_libre(Plateau,TrajetInter3,Depart,Intermediaire1),TrajetInter2=[[Depart,Intermediaire1],TrajetInter3],
							deplacement_possible_vers_libre(Plateau,TrajetInter2,Intermediaire1,Intermediaire2),TrajetInter1=[[Intermediaire1,Intermediaire2],TrajetInter2].
							deplacement_possible_vers_occupe(Plateau,TrajetInter1,Intermediaire2,Arrive),Trajet=[[Intermediaire2,Arrive],TrajetInter1].

%%%

%coup_valide(Plateau,Trajet, Coup):-	Coup = [Depart,Arrive],		%Coup dans remplacement
					


%coup_valide(Plateau,Trajet, Coup):-Coup = [Depart,Arrivee,Deplacement].






