%Typage:
%Coordonnées d'une case: [x,y] avec x et y entre 1 et 6
%Coup: [depart,arrivé] ou [depart,arrivé,nouvelleCaseDuPionRemplacé]
%Lien: [caseA,caseB]

%plateau_depart(-Plateau): Défini le plateau de départ [[simples], [doubles], [triples], joueur_courant]
plateau_depart([[[4,1],[6,1],[2,6],[6,6]],[[3,1],[5,1],[1,6],[5,6]],[[1,1],[2,1],[3,6],[4,6]],s]).
%plateau_depart([[[1,6],[3,1],[3,5],[5,5]],[[2,6],[4,4],[5,1],[5,3]],[[4,1],[3,4],[6,1],[6,6]],s]).
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

joueurInverse(Plateau,n):-
	joueur(Plateau,s).
joueurInverse(Plateau,s):-
	joueur(Plateau,n).

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

%%%%

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
lignes_dessous_contiennent_pions(Plateau,Ligne):-ligne_contient_pions(Plateau,Ligne).
lignes_dessous_contiennent_pions(Plateau,Ligne):-plusun(Ligne2,Ligne),lignes_dessous_contiennent_pions(Plateau,Ligne2).

%lignes_dessous_contiennent_pions(+Plateau,?Ligne)
%Idem que lignes_dessus_contiennent_pions mais pour les lignes en dessous
lignes_dessus_contiennent_pions(Plateau,Ligne):-ligne_contient_pions(Plateau,Ligne).
lignes_dessus_contiennent_pions(Plateau,Ligne):-plusun(Ligne,Ligne2),lignes_dessus_contiennent_pions(Plateau,Ligne2).

%%%%%%%%

position_sur_depart(Plateau,[X,1]):-
	joueur(Plateau,s),
	position_occupee(Plateau,[X,1]).

position_sur_depart(Plateau,[X,Y]):-
	joueur(Plateau,s),
	position_occupee(Plateau,[X,Y]),
	plusun(YmoinsUn,Y),
	\+lignes_dessous_contiennent_pions(Plateau,YmoinsUn).

position_sur_depart(Plateau,[X,6]):-
	joueur(Plateau,n),
	position_occupee(Plateau,[X,6]).

position_sur_depart(Plateau,[X,Y]):-
	joueur(Plateau,n),
	position_occupee(Plateau,[X,Y]),
	plusun(Y,YplusUn),
	\+lignes_dessus_contiennent_pions(Plateau,YplusUn).


position_sur_derniere_ligne(Plateau,[_,Y]):-
	joueur(Plateau,n),
	Y=1.

position_sur_derniere_ligne(Plateau,[_,Y]):-
	joueur(Plateau,s),
	Y=6.

%coup_simple_vers_libre(+Plateau,+TrajetAvant,?TrajetApres,?Depart,?Arrive)
%Defini les coups possibles sans remplacement sans rebonds. La case finale est une case libre 
coup_simple_vers_libre(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_simple(Plateau,Pions_simple),member(Depart,Pions_simple),	%Le pion de départ est un pion simple
	position_sur_derniere_ligne(Plateau,Depart),
	Arrive=v,
	TrajetApres=[[Depart,Arrive]|TrajetAvant].

coup_simple_vers_libre(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_double(Plateau,Pions_double),member(Depart,Pions_double),	%Le pion de départ est un pion double
	deplacement_possible_vers_libre(Plateau,TrajetAvant,Depart,Intermediaire),TrajetInter=[[Depart,Intermediaire]|TrajetAvant],
	position_sur_derniere_ligne(Plateau,Intermediaire),
	Arrive=v,
	TrajetApres=[[Depart,Arrive]|TrajetInter].

coup_simple_vers_libre(Plateau,TrajetAvant,TrajetApres,Depart,Arrive):-
	pions_triple(Plateau,Pions_triple),member(Depart,Pions_triple),	%Le pion de départ est un pion triple
	deplacement_possible_vers_libre(Plateau,TrajetAvant,Depart,Intermediaire1),TrajetInter1=[[Depart,Intermediaire1]|TrajetAvant],
	deplacement_possible_vers_libre(Plateau,TrajetInter1,Intermediaire1,Intermediaire2),TrajetInter2=[[Intermediaire1,Intermediaire2]|TrajetInter1],
	position_sur_derniere_ligne(Plateau,Intermediaire2),
	Arrive=v,
	TrajetApres=[[Depart,Arrive]|TrajetInter2].


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

%position_apres_remplacement_valide(+Plateau,[?X,?Y])
%Defini si une position après remplacement est valide en fonction du plateau et du joueur qui joue le coup
position_apres_remplacement_valide(Plateau,[X,Y]):-
	joueur(Plateau,s),	%c'est à Sud de jouer
	lignes_dessus_contiennent_pions(Plateau,Y),
	position_libre(Plateau,[X,Y]).

position_apres_remplacement_valide(Plateau,[X,Y]):-
	joueur(Plateau,n),	%c'est à Nord de jouer
	lignes_dessous_contiennent_pions(Plateau,Y),
	position_libre(Plateau,[X,Y]).

%appliquer_coup(+PlateauIN,-PlateauOUT,[Depart,Arrive]):-

appliquer_coup(Plateau,Plateau,[_,v]):-!. %Si c'est un coup final, on touche pas le plateau

appliquer_coup(PlateauIN,PlateauOUT,[Depart,Arrive]):- 
	pions_simple(PlateauIN,ListPionIN),
	member(Depart,ListPionIN),
	delete(ListPionIN,Depart,ListPionTemp),
	append(ListPionTemp,[Arrive],ListPionOUT),
	pions_double(PlateauIN,Pions2),
	pions_triple(PlateauIN,Pions3),
	joueurInverse(PlateauIN,Joueur),
	PlateauOUT=[ListPionOUT,Pions2,Pions3,Joueur],!.
	
appliquer_coup(PlateauIN,PlateauOUT,[Depart,Arrive]):-
	pions_double(PlateauIN,ListPionIN),
	member(Depart,ListPionIN),
	delete(ListPionIN,Depart,ListPionTemp),
	append(ListPionTemp,[Arrive],ListPionOUT),
	pions_simple(PlateauIN,Pions1),
	pions_triple(PlateauIN,Pions3),
	joueurInverse(PlateauIN,Joueur),
	PlateauOUT=[Pions1,ListPionOUT,Pions3,Joueur],!.

appliquer_coup(PlateauIN,PlateauOUT,[Depart,Arrive]):-
	pions_triple(PlateauIN,ListPionIN),
	member(Depart,ListPionIN),
	delete(ListPionIN,Depart,ListPionTemp),
	append(ListPionTemp,[Arrive],ListPionOUT),
	pions_simple(PlateauIN,Pions1),
	pions_double(PlateauIN,Pions2),
	joueurInverse(PlateauIN,Joueur),
	PlateauOUT=[Pions1,Pions2,ListPionOUT,Joueur],!.


appliquer_coup(PlateauIN,PlateauOUT,[Depart,Arrive,Remplacement]):-
	appliquer_coup(PlateauIN,PlateauTMP,[Arrive,Remplacement]),
	appliquer_coup(PlateauTMP,PlateauTMP2,[Depart,Arrive]),
	joueurInverse(PlateauTMP2,Joueur),
	pions_simple(PlateauTMP2,Pions1),
	pions_double(PlateauTMP2,Pions2),
	pions_triple(PlateauTMP2,Pions3),
	PlateauOUT=[Pions1,Pions2,Pions3,Joueur],!.


%%% Prédicats "End-User"

%coup_sans_remplacement(+Plateau,?TrajetAvant,?TrajetApres, [?Depart,?Arrive])
%Defini un coup entier sans remplacement
coup_sans_remplacement_recursif(Plateau,TrajetAvant,TrajetApres, [Depart,Arrive]):-
	coup_simple_vers_libre(Plateau,TrajetAvant,TrajetApres,Depart,Arrive).

coup_sans_remplacement_recursif(Plateau,TrajetAvant,TrajetApres, [Depart,Arrive]):-
	coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetInter,Depart,Intermediare),
	coup_sans_remplacement_recursif(Plateau,TrajetInter,TrajetApres,[Intermediare,Arrive]).
coup_sans_remplacement(Plateau,Trajet, [Depart,Arrive]):-
	position_sur_depart(Plateau,Depart),
	coup_sans_remplacement_recursif(Plateau,[],Trajet, [Depart,Arrive]).

%coup_sans_remplacement(+Plateau,?TrajetAvant,?TrajetApres, [?Depart,?Arrive])
%Defini un coup entier avec remplacement
coup_avec_remplacement_recursif(Plateau,TrajetAvant,TrajetApres, [Depart,Arrive,Remplacement]):-
	coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetTMP,Depart,Arrive),
	appliquer_coup(Plateau,PlateauTMP,[Depart,Arrive]),
	position_apres_remplacement_valide(PlateauTMP,Remplacement),
	TrajetApres=[[Remplacement,Remplacement]|TrajetTMP].

coup_avec_remplacement_recursif(Plateau,TrajetAvant,TrajetApres, [Depart,Arrive,Remplacement]):-
	coup_simple_vers_occupee(Plateau,TrajetAvant,TrajetInter,Depart,Intermediaire),
	coup_avec_remplacement_recursif(Plateau,TrajetInter,TrajetApres,[Intermediaire,Arrive,Remplacement]).

coup_avec_remplacement(Plateau,Trajet,[Depart,Arrive,Remplacement]):-
	position_sur_depart(Plateau,Depart),
	coup_avec_remplacement_recursif(Plateau,[],Trajet, [Depart,Arrive,Remplacement]).

coup(Plateau,Trajet,Coup):-
	coup_sans_remplacement(Plateau,Trajet,Coup).

coup(Plateau,Trajet,Coup):-
	coup_avec_remplacement(Plateau,Trajet,Coup).


%%%

coup_imparable(Plateau,Trajet,Coup):-
	coup(Plateau,Trajet,Coup),
	appliquer_coup(Plateau,PlateauOUT,Coup),
	\+coup(PlateauOUT,_,[_,v]).

coup_peut_gagner_en_2_coups(Plateau,Trajet,Coup):-
	coup(Plateau,Trajet,Coup),
	appliquer_coup(Plateau,PlateauTMP,Coup),
	\+coup(PlateauTMP,_,[_,v]),	%L'ennemi ne gagne pas au prochain coup
	coup(PlateauTMP,_,CoupEnnemi),
	appliquer_coup(PlateauTMP,PlateauOUT,CoupEnnemi),
	coup(PlateauOUT,_,[_,v]).	%On peut gagner au second tour


tous_les_plateaux_seront_battus(_,[]).
tous_les_plateaux_seront_battus([Plateau|ListPlateau]):-
	coup(Plateau,_,[_,v]),
	tous_les_plateaux_seront_battus(ListPlateau).

coup_va_gagner_en_2_coups(Plateau,Trajet,Coup):-
	coup(Plateau,Trajet,Coup),
	appliquer_coup(Plateau,PlateauTMP,Coup),
	\+coup(PlateauTMP,_,[_,v]),	%L'ennemi ne gagne pas au prochain coup
	setof(PlateauOUT,PlateauTMP^T^(coup(PlateauTMP,T,CoupEnnemi),appliquer_coup(PlateauTMP,PlateauOUT,CoupEnnemi)),ListPlateau),
	tous_les_plateaux_seront_battus(ListPlateau).
	

coup_humain(Plateau,Trajet,Coup):-
    coup(Plateau,Trajet,Coup),!.

coup_machine(Plateau,Trajet,[Depart,v]):-
   coup(Plateau,Trajet,[Depart,v]),!.

%coup_machine(Plateau,Trajet,Coup):-
%   coup_va_gagner_en_2_coups(Plateau,Trajet,Coup),!.

coup_machine(Plateau,Trajet,Coup):-
   coup_peut_gagner_en_2_coups(Plateau,Trajet,Coup),!.

coup_machine(Plateau,Trajet,Coup):-
   coup_imparable(Plateau,Trajet,Coup),!.

coup_machine(Plateau,Trajet,Coup):-
   coup(Plateau,Trajet,Coup),!.


%%% UI
  
gyges(Theme):-
	abolish(plateau/1),
	abolish(tour/1),
	abolish(type_joueur/2),
	logo,
	menu(Theme).

% http://www.network-science.de/ascii/
logo:-
	nl,
	write('     ___                       ___           ___           ___     '), nl,
	write('    /\\__\\                     /\\__\\         /\\__\\         /\\__\\    '), nl,
	write('   /:/ _/_         ___       /:/ _/_       /:/ _/_       /:/ _/_   '), nl,
	write('  /:/ /\\  \\       /|  |     /:/ /\\  \\     /:/ /\\__\\     /:/ /\\  \\  '), nl,
	write(' /:/ /::\\  \\     |:|  |    /:/ /::\\  \\   /:/ /:/ _/_   /:/ /::\\  \\ '), nl,
	write('/:/__\\/\\:\\__\\    |:|  |   /:/__\\/\\:\\__\\ /:/_/:/ /\\__\\ /:/_/:/\\:\\__\\'), nl,
	write('\\:\\  \\ /:/  /  __|:|__|   \\:\\  \\ /:/  / \\:\\/:/ /:/  / \\:\\/:/ /:/  /'), nl,
	write(' \\:\\  /:/  /  /::::\\  \\    \\:\\  /:/  /   \\::/_/:/  /   \\::/ /:/  / '), nl,
	write('  \\:\\/:/  /   ~~~~\\:\\  \\    \\:\\/:/  /     \\:\\/:/  /     \\/_/:/  /  '), nl,
	write('   \\::/  /         \\:\\__\\    \\::/  /       \\::/  /        /:/  /   '), nl,
	write('    \\/__/           \\/__/     \\/__/         \\/__/         \\/__/    '), nl.

menu(Theme):-
	nl,
	write('1. Humain vs Machine'), nl,
	write('2. Humain vs Humain'), nl,
	write('3. Machine vs Machine'), nl,
	nl,
	write('Mode de jeu ? '),
	read(Mode),
	jouer_mode(Mode,Theme).
	%jouer_mode(1).

%afficher_case(+Theme,+Plateau,+Trajet,+Position)
afficher_case(1,Plateau,Trajet,Position):-
	member(Coup,Trajet),
	member(Position,Coup),
	pions_simple(Plateau,Pions),
	member(Position,Pions),
	format("\033\[31m1 \033\[00m",[]),
	!.
afficher_case(1,Plateau,Trajet,Position):-
	member(Coup,Trajet),
	member(Position,Coup),
	pions_double(Plateau,Pions),
	member(Position,Pions),
	format("\033\[31m2 \033\[00m",[]),
	!.
afficher_case(1,Plateau,Trajet,Position):-
	member(Coup,Trajet),
	member(Position,Coup),
	pions_triple(Plateau,Pions),
	member(Position,Pions),
	format("\033\[31m3 \033\[00m",[]),
	!.
afficher_case(1,_Plateau,Trajet,Position):-
	member(Coup,Trajet),
	member(Position,Coup),
	format("\033\[31m· \033\[00m",[]),
	!.
afficher_case(1,Plateau,_Trajet,Position):-
	pions_simple(Plateau,Pions),
	member(Position,Pions),
	write('1 '),
	!.
afficher_case(1,Plateau,_Trajet,Position):-
	pions_double(Plateau,Pions),
	member(Position,Pions),
	write('2 '),
	!.
afficher_case(1,Plateau,_Trajet,Position):-
	pions_triple(Plateau,Pions),
	member(Position,Pions),
	write('3 '),
	!.
afficher_case(1,_Plateau,_Trajet,_Position):-
	write('· '),
	!.
afficher_case(2,Plateau,_Trajet,Position):-
	pions_simple(Plateau,Pions),
	member(Position,Pions),
	write('(1)'),
	!.
afficher_case(2,Plateau,_Trajet,Position):-
	pions_double(Plateau,Pions),
	member(Position,Pions),
	write('(2)'),
	!.
afficher_case(2,Plateau,_Trajet,Position):-
	pions_triple(Plateau,Pions),
	member(Position,Pions),
	write('(3)'),
	!.
afficher_case(2,_,_Trajet,_):-
	write('( )').

%afficher_ligne(+Theme,+Plateau,+Trajet,+Ligne)
afficher_ligne(1,Plateau,Trajet,Ligne):-
	write('║ '),
	afficher_case(1,Plateau,Trajet,[1,Ligne]),
	afficher_case(1,Plateau,Trajet,[2,Ligne]),
	afficher_case(1,Plateau,Trajet,[3,Ligne]),
	afficher_case(1,Plateau,Trajet,[4,Ligne]),
	afficher_case(1,Plateau,Trajet,[5,Ligne]),
	afficher_case(1,Plateau,Trajet,[6,Ligne]),
	write('║\n').
afficher_ligne(2,Plateau,_Trajet,Ligne):-
	afficher_case(2,Plateau,_Trajet,[1,Ligne]), write('—'),
	afficher_case(2,Plateau,_Trajet,[2,Ligne]), write('—'),
	afficher_case(2,Plateau,_Trajet,[3,Ligne]), write('—'),
	afficher_case(2,Plateau,_Trajet,[4,Ligne]), write('—'),
	afficher_case(2,Plateau,_Trajet,[5,Ligne]), write('—'),
	afficher_case(2,Plateau,_Trajet,[6,Ligne]), nl.

%afficher_plateau(+Theme,+Plateau)
afficher_plateau(1,Plateau,Trajet):-
	nl,
	write('  ╔═════════════╗'), nl,
	write('6 '), afficher_ligne(1,Plateau,Trajet,6),
	write('5 '), afficher_ligne(1,Plateau,Trajet,5),
	write('4 '), afficher_ligne(1,Plateau,Trajet,4),
	write('3 '), afficher_ligne(1,Plateau,Trajet,3),
	write('2 '), afficher_ligne(1,Plateau,Trajet,2),
	write('1 '), afficher_ligne(1,Plateau,Trajet,1),
	write('  ╚═════════════╝'), nl,
	write('    1 2 3 4 5 6  '), nl, nl.
afficher_plateau(2,Plateau,_Trajet):-
	nl,
	write('6 '), afficher_ligne(2,Plateau,_Trajet,6),
	write('   |   |   |   |   |   | '), nl,
	write('5 '), afficher_ligne(2,Plateau,_Trajet,5),
	write('   |   |   |   |   |   | '), nl,
	write('4 '), afficher_ligne(2,Plateau,_Trajet,4),
	write('   |   |   |   |   |   | '), nl,
	write('3 '), afficher_ligne(2,Plateau,_Trajet,3),
	write('   |   |   |   |   |   | '), nl,
	write('2 '), afficher_ligne(2,Plateau,_Trajet,2),
	write('   |   |   |   |   |   | '), nl,
	write('1 '), afficher_ligne(2,Plateau,_Trajet,1),
	write('   1   2   3   4   5   6  \n').

parser_nombre(v,v):-!.
parser_nombre(AA,[A1,A2]):-
	A1 is AA // 10,
	A2 is AA mod 10.
	
parser_nombre2(v,v):-!.
parser_nombre2(AA,[A1,A2]):-
	AA is A1 * 10 + A2.

convertir_notation(AA*BB,[AA2,BB2]):-
	parser_nombre(AA,AA2),
	parser_nombre(BB,BB2).
convertir_notation(AA*BB=CC,[AA2,BB2,CC2]):-
	parser_nombre(AA,AA2),
	parser_nombre(BB,BB2),
	parser_nombre(CC,CC2).
	
convertir_notation2(AA*BB,[AA2,BB2]):-
	parser_nombre2(AA,AA2),
	parser_nombre2(BB,BB2).
convertir_notation2(AA*BB=CC,[AA2,BB2,CC2]):-
	parser_nombre2(AA,AA2),
	parser_nombre2(BB,BB2),
	parser_nombre2(CC,CC2).

saisie_humain(C):-
	write('Coup (AA*BB ou AA*BB=CC) ? '),
	read(Cext),
	convertir_notation(Cext,C).
	
calculer_coup(humain,P,T,C):-
	saisie_humain(C),
	coup_humain(P,T,C).
calculer_coup(machine,P,T,C):-
	coup_machine(P,T,C),
	convertir_notation2(Notation_externe, C),
	write('La machine joue '), write(Notation_externe), write('.'), nl.
	%sleep(1).

jouer_mode(1,Theme):-
	asserta(type_joueur(1,humain)),
	asserta(type_joueur(2,machine)),
	jouer(Theme).
jouer_mode(2,Theme):-
	asserta(type_joueur(1,humain)),
	asserta(type_joueur(2,humain)),
	jouer(Theme).
jouer_mode(3,Theme):-
	asserta(type_joueur(1,machine)),
	asserta(type_joueur(2,machine)),
	jouer(Theme).	

jouer(Theme):-
	plateau_depart(P),
	asserta(plateau(P)),
	asserta(tour(1)),
	afficher_plateau(Theme,P,[]),
	repeat,
		plateau(P1),
		tour(I),
		type_joueur(I,J),
		write('Le joueur '), write(I), write(' ('), write(J), write(') a la main.'), nl,
		calculer_coup(J,P1,T,C),
		appliquer_coup(P1,P2,C),
		afficher_plateau(Theme,P2,T),
		nth(2,C,Y),
		%((Y \= v) ->
			retract(plateau(P1)),
			asserta(plateau(P2)),
			retract(tour(I)),
			I2 is (I mod 2) + 1,
			asserta(tour(I2)),
		%),
	Y = v,
	write('★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆'), nl,
	write('Le joueur '), write(I), write(' gagne la partie'), nl,
	write('★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆'), nl,
	!.

% Coups interessants:
%51*53.
%31*42.
%11*55.
%41*64.
%21*23.


