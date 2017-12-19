:-lib(ic).

compute(PatternList,AlienDictionary,Sum) :- ( foreach(Word,AlienDictionary),
                                                fromto(0,Low,High,Sum),
                                                param(PatternList) do 
                                                string_chars(Word,CharList),
                                                match(CharList,PatternList,D),
                                                (D == 0 ->  High #= Low + 0; High #= Low + 1) ).

trans_pattern([], P) :- P = [].
trans_pattern(['('|S] , P) :- P = [G|PR],
                             trans_pattern_group(S, SR, G),
                             trans_pattern(SR, PR).
trans_pattern([X|S], P) :- P = [X|PR],
                           trans_pattern(S, PR).

trans_pattern_group([')'|S], SR, G) :- G = [], S = SR.
trans_pattern_group([X|S], SR, G) :- G = [X|GR],
                                     trans_pattern_group(S, SR, GR).


match([], [] , 1).
match([A|As], [L|Ps],D) :- (member(A,L) ->  match(As, Ps, D); D = 0,true).

main(WordLength,AlienDictionary,Pattern) :- string_chars(Pattern,PatternCharList),
                                            trans_pattern(PatternCharList,PatternList),
                                            compute(PatternList,AlienDictionary,Sum),!,
                                            writeln("Total words in alien dictionary which match given pattern :"),
                                            writeln(Sum). 