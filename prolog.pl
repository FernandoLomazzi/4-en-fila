%Tablero inicial
%tableroInicial(T).
tableroInicial([
[-,-,-,-,-,-,-],
[-,-,-,-,-,-,-],
[-,-,-,-,-,-,-],
[-,-,-,-,-,-,-],
[-,-,-,-,-,-,-],
[-,-,-,-,-,-,-]
]).
%6x7
%a y b jugadores, - vacío.
%Esquina superior izquierda pos (1,1).

%Ingresa una ficha en la posicion C
% tableroInicial(T), ingresarFicha(T,1,a,T2),ingresarFicha(T2,1,b,T3),ingresarFicha(T3,4,a,T4).
% ingresarFicha([[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-]],1,a,T2).
ingresarFicha(T,C,FICHA,T2) :- columnaDisp(T,C), filaDisp(T,C,F), setT(T,FICHA,F,C,T2),!.
%Retorna la fila disponible de una columna C.
% filaDisp([[-,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-]],1,F).
% filaDisp([[-,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,a,-,-,-],[a,-,-,a,-,-,-],[a,-,-,b,-,-,-]],4,F).
filaDisp(T,C,F) :- listaColumna(T,C,LC), ultOcurrencia(LC,-,F).
%Devuelve una lista con la columna solicitada
% listaColumna([[b,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-]],1,L).
% listaColumna([[-,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,a,-,-,-],[a,-,-,a,-,-,-],[a,-,-,b,-,-,-]],4,L).
listaColumna([],_,[]) :- !.
listaColumna([X|Xs],C,[Y|Ys]) :- get(X, C, Y), listaColumna(Xs,C,Ys).
%Da ultima ocurrencia de simbolo S en lista
% listaColumna([[b,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-]],1,L), ultOcurrencia(L,-,P).
% listaColumna([[-,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,-,-,-,-],[a,-,-,a,-,-,-],[a,-,-,a,-,-,-],[a,-,-,b,-,-,-]],4,L), ultOcurrencia(L,-,P).
ultOcurrencia([S|Xs],S,N) :- !, ultOcurrencia(Xs,S,N2), N is N2+1.
ultOcurrencia(L,S,0).
%Setea posicion en tablero
% tableroInicial(T), setT(T,a,6,6,T2), setT(T2,b,6,7,T3).
% tableroInicial(T), setT(T,b,1,0,T2).
setT(T,FICHA,F,C,T2) :- get(T,F,T3), set(T3,C,FICHA,T4), set(T,F,T4,T2).
%setea i con V
% set([-,-,-,-,-,-,-],1,a,R), set(R,7,b,R2), set(R2,4,a,R3).
set([_|T], 1, V, [V|T]) :- !.
set([X|Xs],N, V, [X|T]) :- N2 is N-1, set(Xs,N2,V,T).
%Devuelve pos i
% set([-,-,-,-,-,-,-],1,a,R), set(R,7,b,R2), set(R2,4,a,R3), get(R3,1,V1), get(R3,2,V2), get(R3,7,V3).
get([X|_],1,X) :- !.
get([_|Xs],N,Y) :- N2 is N-1, get(Xs,N2,Y).
%Devuelve las columnas disponibles. 
%Si la primer posición de la columna está vacía -> Columna disponible
% tableroInicial(T),columnaDisp(T,C).
% columnaDisp([[b,-,-,-,a,-,-],[a,-,-,-,a,-,-],[a,-,-,-,b,-,-],[a,-,a,-,b,-,-],[a,-,b,-,a,-,-],[a,-,a,-,b,-,-]],C).
columnaDisp([X|Xs],C) :- vacio(X,C).
%Devuelve las posiciones de la lista VACIAS
% vacio([b,-,-,-,a,-,-],C).
% vacio([a,b,a,b,-,a,-],C).
vacio([X|_],1) :- X=(-).
vacio([_|Xs],P2) :- vacio(Xs,P),P2 is P+1.

%devueleve ficha en F,C
% contenido([[b,-,-,-,a,-,-],[a,-,-,-,a,-,-],[a,-,-,-,b,-,-],[a,-,a,-,b,-,-],[a,-,b,-,a,-,-],[a,-,a,-,b,-,-]],[1,1],F).
% contenido([[b,-,-,-,a,-,-],[a,-,-,-,a,-,-],[a,-,-,-,b,-,-],[a,-,a,-,b,-,-],[a,-,b,-,a,-,-],[a,-,a,-,b,-,-]],[6,3],F).
contenido(T,[F,C],FICHA) :- get(T,F,T2), get(T2,C,FICHA).

%Dice si hay ganador en tablero, si lo hay es la FICHA y en listaPOS posiciones ganador
% Vertical: conecta4([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,a,-],[-,-,-,b,a,b,-],[-,-,-,a,a,b,-],[-,b,a,a,a,b,b]],G,L).
% Vertical: conecta4([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,b,-],[-,-,-,b,a,b,-],[-,-,a,a,a,b,-],[-,b,a,a,a,b,b]],G,L).
% Horizontal: conecta4([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,b,-,-,-,-,-],[-,b,-,-,-,-,-],[b,b,a,a,a,a,-],[a,a,b,b,b,a,a]],G,L).
% Diagonal: conecta4([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,a,-,-],[-,b,-,a,b,-,-],[b,b,a,a,b,a,-],[a,a,b,b,b,a,a]],G,L).
% Diagonal: conecta4([[-,b,-,-,-,-,-],[-,a,b,-,-,-,-],[-,b,a,b,-,-,-],[-,a,b,a,b,-,-],[b,b,a,a,b,-,-],[a,a,b,b,a,a,a]],G,L).
% No ganador: conecta4([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,b,a,b,-],[-,-,a,a,a,b,-],[-,b,a,a,a,b,b]],G,L).
conecta4(T,a,L) :- between(1,7,C), filaDisp(T,C,F), F2 is F+1, between(F2,6,F3), esGanadora(T,a,L,F3,C),!.
conecta4(T,b,L) :- between(1,7,C), filaDisp(T,C,F), F2 is F+1, between(F2,6,F3), esGanadora(T,b,L,F3,C),!.
%Gana horizontal
esGanadora(T,FICHA,[[I,J],[I,J2],[I,J3],[I,J4]],I,J) :- contenido(T,[I,J],FICHA),J2 is J+1,contenido(T,[I,J2],FICHA),J3 is J+2,contenido(T,[I,J3],FICHA),J4 is J+3,contenido(T,[I,J4],FICHA),!.
%Gana vertical
esGanadora(T,FICHA,[[I,J],[I2,J],[I3,J],[I4,J]],I,J) :- contenido(T,[I,J],FICHA),I2 is I+1,contenido(T,[I2,J],FICHA),I3 is I+2,contenido(T,[I3,J],FICHA),I4 is I+3,contenido(T,[I4,J],FICHA),!.
%Gana diag ppal
esGanadora(T,FICHA,[[I,J],[I2,J2],[I3,J3],[I4,J4]],I,J) :- contenido(T,[I,J],FICHA),I2 is I+1,J2 is J+1,contenido(T,[I2,J2],FICHA),I3 is I+2,J3 is J+2,contenido(T,[I3,J3],FICHA),I4 is I+3,J4 is J+3,contenido(T,[I4,J4],FICHA),!.
%Gana diag sec
esGanadora(T,FICHA,[[I,J],[I2,J2],[I3,J3],[I4,J4]],I,J) :- contenido(T,[I,J],FICHA),I2 is I+1,J2 is J-1,contenido(T,[I2,J2],FICHA),I3 is I+2,J3 is J-2,contenido(T,[I3,J3],FICHA),I4 is I+3,J4 is J-3,contenido(T,[I4,J4],FICHA),!.

%True si hay empate y tablero lleno
% empate([[-,b,-,-,-,-,-],[-,a,b,-,-,-,-],[-,b,a,b,-,-,-],[-,a,b,a,b,-,-],[b,b,a,a,b,-,-],[a,a,b,b,a,a,a]]).
% empate([[-,-,-,-,-,-,-],[-,a,b,-,-,-,-],[-,b,a,b,-,-,-],[-,a,b,a,b,-,-],[b,b,a,a,b,-,-],[a,a,b,b,a,a,a]]).
% empate([[b,a,b,b,b,b,a],[a,b,a,a,a,b,a],[b,a,b,b,b,a,b],[a,b,a,a,a,b,a],[b,a,b,b,b,a,b],[a,b,a,a,a,b,a]]).
% empate([[b,a,b,b,b,a,b],[a,b,a,a,a,b,a],[b,a,b,b,b,a,b],[a,b,a,a,a,b,a],[b,a,b,b,b,a,b],[a,b,a,a,a,b,a]]).
empate(T) :- not(conecta4(T,A,L)), not(columnaDisp(T,C)).

%Si hay jugada ganadora, devuelve la columna
% jugadaGanadora([[-,-,-,-,-,-,-],[-,a,b,-,-,-,-],[-,b,a,b,-,-,-],[-,a,b,a,b,-,-],[b,b,a,a,b,-,-],[a,a,b,b,a,a,a]],G,C).
% jugadaGanadora([[-,-,-,-,-,-,-],[-,a,b,-,-,-,-],[-,b,a,-,-,-,-],[-,a,b,-,b,-,-],[-,b,a,-,b,b,b],[a,a,b,-,a,a,a]],G,C).
% jugadaGanadora([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,a,-,-,-,-],[-,-,b,-,a,-,b],[a,a,b,-,b,a,a]],G,C).
jugadaGanadora(T,a,C) :- columnaDisp(T,C), ingresarFicha(T,C,a,T2), conecta4(T2,a,L).
jugadaGanadora(T,b,C) :- columnaDisp(T,C), ingresarFicha(T,C,b,T2), conecta4(T2,b,L).

%Si hay jugada ganadora para el rival, no la hago
% jugadaSegura([[-,-,-,-,-,-,-],[-,a,b,-,-,-,-],[-,b,a,b,-,-,-],[-,a,b,a,b,-,-],[b,b,a,a,b,-,-],[a,a,b,b,a,a,a]],G,C).
% jugadaSegura([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,b],[-,-,-,-,-,-,b],[-,a,a,a,-,-,b]],G,C).
jugadaSegura(T,a,C) :- columnaDisp(T,C), ingresarFicha(T,C,a,T2), not(jugadaGanadora(T2,b,C2)).
jugadaSegura(T,b,C) :- columnaDisp(T,C), ingresarFicha(T,C,b,T2), not(jugadaGanadora(T2,a,C2)).

%Si C juego gano
% jugadaDefinitiva([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,b],[-,a,a,-,-,-,b]],G,C).
% jugadaDefinitiva([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,a],[-,-,-,-,a,a,b],[-,-,-,a,b,b,b],[-,a,-,b,b,a,b]],G,C).
% jugadaDefinitiva([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[a,b,a,b,a,b,a],[b,a,b,a,b,a,b],[a,b,a,b,a,b,a]],G,C).
% jugadaDefinitiva([[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,-,-,-,-],[-,-,-,a,-,-,-],[-,b,a,b,a,-,-],[b,a,b,a,b,a,-]],G,C).
jugadaDefinitiva(T,a,C) :- jugadaGanadora(T,a,C),!.
jugadaDefinitiva(T,a,C) :- columnaDisp(T,C), ingresarFicha(T,C,a,T2), not(jugadaGanadora(T2,b,C2)), not(jugadaSegura(T2,b,C3)).
jugadaDefinitiva(T,b,C) :- jugadaGanadora(T,b,C),!.
jugadaDefinitiva(T,b,C) :- columnaDisp(T,C), ingresarFicha(T,C,b,T2), not(jugadaGanadora(T2,a,C2)), not(jugadaSegura(T2,a,C3)).

jugadaSeguraPro(T,a,C) :- columnaDisp(T,C), ingresarFicha(T,C,a,T2), not(jugadaDefinitiva(T2,b,C2)).
jugadaSeguraPro(T,b,C) :- columnaDisp(T,C), ingresarFicha(T,C,b,T2), not(jugadaDefinitiva(T2,a,C2)).

jugadaIA(T,FICHA,C,normal) :- jugadaDefinitiva(T,FICHA,C),print("x"),!.
jugadaIA(T,FICHA,C,normal) :- jugadaSeguraPro(T,FICHA,C).
jugadaIA(T,FICHA,C,normal) :- jugadaSegura(T,FICHA,C).
jugadaIA(T,FICHA,C,normal) :- columnaDisp(T,C).
jugadaIA(T,FICHA,C,dificil) :- jugadaDefinitiva(T,FICHA,C),!.
jugadaIA(T,FICHA,C,dificil) :- !,jugadaSeguraPro(T,FICHA,C).
jugadaIA(T,FICHA,C,dificil) :- !,jugadaSegura(T,FICHA,C).
jugadaIA(T,FICHA,C,dificil) :- columnaDisp(T,C).

