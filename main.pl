%Typage:
%Coordonnées d'une case: [x,y] avec x et y entre 1 et 6
%Coup: [depart,arrivé] ou [depart,arrivé,nouvelleCaseDuPionRemplacé]
%Lien: [caseA,caseB]

%plateau_depart(-Plateau): Défini le plateau de départ
plateau_depart([[[4,1],[6,1],[1,6],[6,6]],[[3,1],[5,1],[2,6],[5,6]],[[1,1],[2,3],[3,6],[4,6]],s]).

%domaine(-_):Defini le domaine de validité des abscisses et ordonnées
domaine(1).
domaine(2).
domaine(3).
domaine(4).
domaine(5).
domaine(6).

%Définit l'ordre du domaine
plusun(1,2).
plusun(2,3).
plusun(3,4).
plusun(4,5).
plusun(5,6).

%pions_xxxxx(+Plateau,-Pions)
pions_simple(Plateau,Pions):-nth(1,Plateau,Pions).
pions_double(Plateau,Pions):-nth(2,Plateau,Pions).
pions_triple(Plateau,Pions):-nth(3,Plateau,Pions).
joueur(Plateau,Joueur):-nth(4,Plateau,Joueur).

%affiche_elem(+Plateau,+Position)
affiche_elem(Plateau,Position):-pions_simple(Plateau,Pions),member(Position,Pions),write(' 1 '),!.
affiche_elem(Plateau,Position):-pions_double(Plateau,Pions),member(Position,Pions),write(' 2 '),!.
affiche_elem(Plateau,Position):-pions_triple(Plateau,Pions),member(Position,Pions),write(' 3 '),!.
affiche_elem(_,_):-write(' . ').

%affiche_ligne(+Plateau,+Ligne)
affiche_ligne(Plateau,Ligne):-
	write('\t|'),
	affiche_elem(Plateau,[1,Ligne]),
	affiche_elem(Plateau,[2,Ligne]),
	affiche_elem(Plateau,[3,Ligne]),
	affiche_elem(Plateau,[4,Ligne]),
	affiche_elem(Plateau,[5,Ligne]),
	affiche_elem(Plateau,[6,Ligne]),
	write('|\n').

%affiche_plateau(+Plateau)
affiche_plateau(Plateau):-
	write('\t+------------------+\n'),
	affiche_ligne(Plateau,6),
	affiche_ligne(Plateau,5),
	affiche_ligne(Plateau,4),
	affiche_ligne(Plateau,3),
	affiche_ligne(Plateau,2),
	affiche_ligne(Plateau,1),
	write('\t+------------------+\n').


%position_sur_plateau([?X,?Y]): Défini si une position est sur le plateau ou non.
position_sur_plateau([X,Y]):-domaine(X),domaine(Y).

%position_occupee(+Plateau,?Position): Défini si une position est déjà occupée par un pion.
position_occupee(Plateau,Position):-position_sur_plateau(Position),pions_simple(Plateau,Pions),member(Position,Pions).
position_occupee(Plateau,Position):-position_sur_plateau(Position),pions_double(Plateau,Pions),member(Position,Pions).
position_occupee(Plateau,Position):-position_sur_plateau(Position),pions_triple(Plateau,Pions),member(Position,Pions).

%position_libre(+Plateau,?Position): Défini si une position n'est pas occupé par un pion.
position_libre(Plateau,Position):-
	position_sur_plateau(Position),
	pions_simple(Plateau,Pions_simple),\+(member(Position,Pions_simple)),
	pions_double(Plateau,Pions_double),\+(member(Position,Pions_double)),
	pions_triple(Plateau,Pions_triple),\+(member(Position,Pions_triple)).


%deplacement_xxxx([?DX,?DY],[?AX,?AY]): Défini si deux positions sont distante d'un déplacement vers la droite/gauche/haut/bas.
deplacement_gauche([DX,Y],[AX,Y]):-plusun(AX,DX).
deplacement_droite([DX,Y],[AX,Y]):-plusun(DX,AX).
deplacement_haut([X,DY],[X,AY]):-plusun(AY,DY).
deplacement_bas([X,DY],[X,AY]):-plusun(DY,AY).

%deplacement_sur_plateau(?DX,?DY],[?AX,?AY]): Défini si deux positions peuvent être jointe par un déplacement en croix.
deplacement_sur_plateau([DX,DY],[AX,AY]):-deplacement_gauche([DX,DY],[AX,AY]).
deplacement_sur_plateau([DX,DY],[AX,AY]):-deplacement_droite([DX,DY],[AX,AY]).
deplacement_sur_plateau([DX,DY],[AX,AY]):-deplacement_haut([DX,DY],[AX,AY]).
deplacement_sur_plateau([DX,DY],[AX,AY]):-deplacement_bas([DX,DY],[AX,AY]).

%deplacement_possible_vers_libre(+Plateau,+Trajet,[-DX,-DY],[+AX,+AY]): 
%Défini les mouvements d'une case possible d'un pion vers une case libre en prenant en compte le trajet déjà parcouru
%(c'est a dire en évitant de passer deux fois par le même lien).
deplacement_possible_vers_libre(Plateau,Trajet,[DX,DY],[AX,AY]):-
	deplacement_sur_plateau([DX,DY],[AX,AY]),
	\+(position_occupee(Plateau,[AX,AY])),
	\+(member([[DX,DY],[AX,AY]],Trajet)),\+(member([[AX,AY],[DX,DY]],Trajet)).	%Passe pas par la meme ligne

%deplacement_possible_vers_occupee(+Plateau,+Trajet,[-DX,-DY],[+AX,+AY]): 
%Idem que deplacement_possible_vers_libre sauf que seul les déplacements vers des cases occupées sont autorisés.
deplacement_possible_vers_occupee(Plateau,Trajet,[DX,DY],[AX,AY]):-
	deplacement_sur_plateau([DX,DY],[AX,AY]),
	position_occupee(Plateau,[AX,AY]),
	\+(member([[DX,DY],[AX,AY]],Trajet)),\+(member([[AX,AY],[DX,DY]],Trajet)).	%Passe pas par la meme ligne

%coup_simple_vers_libre(+Plateau,+TrajetAvant,?TrajetApres,?Depart,?Arrive)
%Defini les coups possibles sans remplacement sans rebonds. La case finale est une case libre 
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


%coup_simple_vers_occupee(+Plateau,+TrajetAvant,?TrajetApres,?Depart,?Arrive)
%Idem que coup_simple_vers_libre sauf que la case finale est occupee (sert pour definir les coups avec rebonds)
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


%%% Ces predicats servent à définir si une position de remplacement est valide pour un pion

%ligne_contient_pions(+Plateau,?Ligne)
%Defini si une ligne contient est libre ou non
ligne_contient_pions(Plateau,Ligne):-position_occupee(Plateau,[1,Ligne]).
ligne_contient_pions(Plateau,Ligne):-position_occupee(Plateau,[2,Ligne]).
ligne_contient_pions(Plateau,Ligne):-position_occupee(Plateau,[3,Ligne]).
ligne_contient_pions(Plateau,Ligne):-position_occupee(Plateau,[4,Ligne]).
ligne_contient_pions(Plateau,Ligne):-position_occupee(Plateau,[5,Ligne]).
ligne_contient_pions(Plateau,Ligne):-position_occupee(Plateau,[6,Ligne]).

%lignes_dessus_contiennent_pions(+Plateau,?Ligne)
%Defini si les lignes au dessus de Ligne (et contenant Ligne) sont occupee
lignes_dessus_contiennent_pions(Plateau,Ligne):-ligne_contient_pions(Plateau,Ligne).
lignes_dessus_contiennent_pions(Plateau,Ligne):-plusun(Ligne2,Ligne),lignes_dessus_contiennent_pions(Plateau,Ligne2).

%lignes_dessous_contiennent_pions(+Plateau,?Ligne)
%Idem que lignes_dessus_contiennent_pions mais pour les lignes en dessous
lignes_dessous_contiennent_pions(Plateau,Ligne):-ligne_contient_pions(Plateau,Ligne).
lignes_dessous_contiennent_pions(Plateau,Ligne):-plusun(Ligne,Ligne2),lignes_dessus_contiennent_pions(Plateau,Ligne2).

%position_apres_remplacement_valide(+Plateau,[?X,?Y])
%Defini si une position après remplacement est valide en fonction du plateau et du joueur qui joue le coup
position_apres_remplacement_valide(Plateau,[X,Y]):-
	nth(4,Plateau,s),	%c'est à Sud de jouer
	lignes_dessus_contiennent_pions(Plateau,Y),
	position_libre(Plateau,[X,Y]).

position_apres_remplacement_valide(Plateau,[X,Y]):-
	nth(4,Plateau,n),	%c'est à Nord de jouer
	lignes_dessous_contiennent_pions(Plateau,Y),
	position_libre(Plateau,[X,Y]).

%%% Prédicats "End-User"

%coup_sans_remplacement(+Plateau,?TrajetAvant,?TrajetApres, [?Depart,?Arrive])
%Defini un coup entier sans remplacement
coup_sans_remplacement(Plateau,TrajetAvant,TrajetApres, [Depart,Arrive]):-
	coup_simple_vers_libre(Plateau,TrajetAvant,TrajetApres,Depart,Arrive).

coup_sans_remplacement(Plateau,TrajetAvant,TrajetApres, [Depart,Arrive]):-
	coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetInter,Depart,Intermediare),
	coup_sans_remplacement(Plateau,TrajetInter,TrajetApres,[Intermediare,Arrive]).
	

%coup_sans_remplacement(+Plateau,?TrajetAvant,?TrajetApres, [?Depart,?Arrive])
%Defini un coup entier avec remplacement
coup_avec_remplacement(Plateau,TrajetAvant,TrajetApres, [Depart,Arrive,Remplacement]):-
	coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetApres,Depart,Arrive),
	position_apres_remplacement_valide(Plateau,Remplacement).

coup_avec_remplacement(Plateau,TrajetAvant,TrajetApres, [Depart,Arrive,Remplacement]):-
	coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetInter,Depart,Intermediaire),
	coup_avec_remplacement(Plateau,TrajetInter,TrajetApres,[Intermediaire,Arrive,Remplacement]).


%%%

appliquer_coup(+PlateauIN,-PlateauOUT,[Depart,Arrive]):- 
	pions_simple(PlateauIN,ListPionIN),
	member(Depart,ListPionIN),
	delete(ListPionIN,Depart,ListPionTemp),
	append(ListPionTemp,[Arrive],ListPionOUT),
	pions_double(PlateauIN,Pions2),
	pions_triple(PlateauIN,Pions3),
	joueur(PlateauIN,Joueur),
	PlateauOUT=[ListPionOUT,Pions2,Pions3,Joueur].
	
appliquer_coup(+PlateauIN,-PlateauOUT,[Depart,Arrive]):-
	pions_double(PlateauIN,ListPionIN),
	member(Depart,ListPionIN),
	delete(ListPionIN,Depart,ListPionTemp),
	append(ListPionTemp,[Arrive],ListPionOUT),
	pions_simple(PlateauIN,Pions1),
	pions_triple(PlateauIN,Pions3),
	joueur(PlateauIN,Joueur),
	PlateauOUT=[Pions1,ListPionOUT,Pions3,Joueur].

appliquer_coup(+PlateauIN,-PlateauOUT,[Depart,Arrive]):-
	pions_triple(PlateauIN,ListPionIN),
	member(Depart,ListPionIN),
	delete(ListPionIN,Depart,ListPionTemp),
	append(ListPionTemp,[Arrive],ListPionOUT),
	pions_simple(PlateauIN,Pions1),
	pions_double(PlateauIN,Pions2),
	joueur(PlateauIN,Joueur),
	PlateauOUT=[Pions1,Pions2,ListPionOUT,Joueur].



%appliquer_coup(+PlateauIN,-PlateauOUT,[Depart,Arrive,Remplacement]):-


%%% UI
  
gyges(yes):-
	%logo(yes),
	menu(yes).

% http://www.network-science.de/ascii/
logo(yes):-
	write('     ___                       ___           ___           ___     \n'),
	write('    /\\__\\                     /\\__\\         /\\__\\         /\\__\\    \n'),
	write('   /:/ _/_         ___       /:/ _/_       /:/ _/_       /:/ _/_   \n'),
	write('  /:/ /\\  \\       /|  |     /:/ /\\  \\     /:/ /\\__\\     /:/ /\\  \\  \n'),
	write(' /:/ /::\\  \\     |:|  |    /:/ /::\\  \\   /:/ /:/ _/_   /:/ /::\\  \\ \n'),
	write('/:/__\\/\\:\\__\\    |:|  |   /:/__\\/\\:\\__\\ /:/_/:/ /\\__\\ /:/_/:/\\:\\__\\\n'),
	write('\\:\\  \\ /:/  /  __|:|__|   \\:\\  \\ /:/  / \\:\\/:/ /:/  / \\:\\/:/ /:/  /\n'),
	write(' \\:\\  /:/  /  /::::\\  \\    \\:\\  /:/  /   \\::/_/:/  /   \\::/ /:/  / \n'),
	write('  \\:\\/:/  /   ~~~~\\:\\  \\    \\:\\/:/  /     \\:\\/:/  /     \\/_/:/  /  \n'),
	write('   \\::/  /         \\:\\__\\    \\::/  /       \\::/  /        /:/  /   \n'),
	write('    \\/__/           \\/__/     \\/__/         \\/__/         \\/__/    \n').

menu(yes):-
	write('\n1. Humain vs Machine\n'),
	write('2. Humain vs Humain\n'),
	write('3. Machine vs Machine\n\n'),
	write('Mode de jeu ? '),
	read(Mode),
	jouer_mode(Mode).
	
jouer_mode(1):-
	jouer_mode_1(P).
jouer_mode(2).
jouer_mode(3).

jouer_mode_1(P):-
	plateau_depart(P),
	affiche_plateau(P),
	write('Case de départ ? '),
	read(X),
	write('Case d’arrivée ? '),
	read(Y),
	jouer_mode_1(P,T,X,Y).

jouer_mode_1(P,T,X,Y):-
	position_libre(P,Y),
	coup_sans_remplacement(P,[],T,[X,Y]).
	%appliquer_coup(P,P2,[X,Y]),
	%jouer_mode_1(P2).
	%!.
	
jouer_mode_1(P,T,X,Y):-
	position_occupee(P,Y),
	write('Case de remplacement ? '),
	read(R),
	coup_avec_remplacement(P,[],T,[X,Y,R]).
	%appliquer_coup(P,P2,[X,Y,R]),
	%jouer_mode_1(P2).
	%!.
