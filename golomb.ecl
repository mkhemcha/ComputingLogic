%golomb ruler

:- lib(ic_global).
:- import alldifferent/1 from ic_global.
:- lib(ic).
:- lib(branch_and_bound).


main(Nummarkers,OptimalRuler) :- length(OptimalRuler, Nummarkers),
	                             %Maximum mark (Source : wikipedia)
                                 Maxpoint is 2^(Nummarkers-1)-1,
                                 %OptimalRuler Mark Ranges
	                             OptimalRuler :: [0..Maxpoint],
                                 %Fix First mark at 0
	                             append([0|_], [Xn], OptimalRuler),
                                 %Markers should be in increasing order
	                             ordered(<, OptimalRuler),
                                 %Calculate difference between markers
	                             distances(OptimalRuler, DifferenceList),
                                 %Max difference will <= Maxpoint
	                             DifferenceList::[1..Maxpoint],
                                 %all marker differences should be distinct as per requirement of Golumb ruler
	                             alldifferent(DifferenceList),
	                             % difference will also be in increasing order wrt to each particular marker
                                 append([D1|_], [Dn], Diffs),
	                             D1 #< Dn,
                                 % Here the cost function is the last marker . We have to minimize last marker
                                 bb_min(labeling(OptimalRuler), Xn, bb_options{strategy:step}).

%Compute difference of each point from other points
distances([], []).
distances([X|Ys], DifferenceList) :-
	distances(X, Ys, DifferenceList, D1),
	distances(Ys, D1).

%Compute difference of a particular point from other points
distances(_, [], D, D).
distances(X, [Y|Ys], [Sub|D1], D0) :-
Sub #= Y-X,
distances(X, Ys, D1, D0).