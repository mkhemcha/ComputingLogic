/*
Problem
You're watching a show where Googlers (employees of Google) dance, and then each dancer is given a triplet of scores by three judges. Each triplet of scores consists of three integer scores from 0 to 10 inclusive. The judges have very similar standards, so it's surprising if a triplet of scores contains two scores that are 2 apart. No triplet of scores contains scores that are more than 2 apart.
For example: (8, 8, 8) and (7, 8, 7) are not surprising. (6, 7, 8) and (6, 8, 8) are surprising. (7, 6, 9) will never happen.
The total points for a Googler is the sum of the three scores in that Googler's triplet of scores. The best result for a Googler is the maximum of the three scores in that Googler's triplet of scores. Given the total points for each Googler, as well as the number of surprising triplets of scores, what is the maximum number of Googlers that could have had a best result of at least p?
For example, suppose there were 6 Googlers, and they had the following total points: 29, 20, 8, 18, 18, 21. You remember that there were 2 surprising triplets of scores, and you want to know how many Googlers could have gotten a best result of 8 or better.
*/

:- lib(ic).
:- lib(branch_and_bound).

/*Input to models are Number of Surprising Triplets,P given in program,Triplets is a list containing score for each googler*/
model(NumSurprising, MinpossibleScore, ListofPoints, Numgooglers,Triplets, AtleastmaxScore) :-
        %length of triplet should be equal to Number of googlers
        length(Triplets, Numgooglers),
        %Constraint satisfaction for each triplet
        ( foreach(Triplet, Triplets),
        foreach(Point, ListofPoints),
        %calculate triplet with max score atleast given p
        %Constraint no of surprising triplet
        fromto(0, NumSurprisingPrev, NumSurprisingCurr, NumSurprising),
        fromto(0, AtleastmaxScorePrev, AtleastmaxScoreCurr, AtleastmaxScore),
        %If a parameter remains constant across all loop iterations it must be specified explicitly (via param)
        param(MinpossibleScore) do
        %Min Med Max score
        Triplet = [FirstScore, SecondScore, ThirdScore],
        %Triplet Range
        Triplet :: 0..10,
        %Score should be in increasing order
        FirstScore #=< SecondScore, SecondScore #=< ThirdScore,
        ThirdScore - FirstScore #=< 2,
        ThirdScore + SecondScore + FirstScore #= Point,
        %If Max-Min=2 surprising triplet
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