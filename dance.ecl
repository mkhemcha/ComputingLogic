:- lib(ic).
:- lib(branch_and_bound).

model(NumSurprising, MinpossibleScore, ListofPoints, Numgooglers,Triplets, AtleastmaxScore) :-
        length(Triplets, Numgooglers),
        ( foreach(Triplet, Triplets),
        foreach(Point, ListofPoints),
        fromto(0, NumSurprisingPrev, NumSurprisingCurr, NumSurprising),
        fromto(0, AtleastmaxScorePrev, AtleastmaxScoreCurr, AtleastmaxScore),
        param(MinpossibleScore) do
        Triplet = [FirstScore, SecondScore, ThirdScore],
        Triplet :: 0..10,
        FirstScore #=< SecondScore, SecondScore #=< ThirdScore,
        ThirdScore - FirstScore #=< 2,
        ThirdScore + SecondScore + FirstScore #= Point,
        NumSurprisingCurr #= NumSurprisingPrev + (ThirdScore - FirstScore #= 2),
        AtleastmaxScoreCurr #= AtleastmaxScorePrev + (ThirdScore >= MinpossibleScore ) ),
        flatten(Triplets, Vars),
        Cost #= -AtleastmaxScore,
        bb_min(labeling(Vars), Cost,
        bb_options{strategy: continue}).
       

main(Numgooglers,NumSurprising,MinpossibleScore,ListofPoints) :- 
                                model(NumSurprising,MinpossibleScore,ListofPoints,Numgooglers,Triplets,AtleastmaxScore),
                                writeln("Triplets Possible : "),
                                (foreach(X,Triplets) do 
                                                writeln(X)),
                                writeln(""),
                                writeln("No of triplets with atleast maxScore : "),
                                printf("%w", AtleastmaxScore).