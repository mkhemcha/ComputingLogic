/*
Problem

After years of study, scientists at Google Labs have discovered an alien language transmitted from a faraway planet. The alien language is very unique in that every word consists of exactly L lowercase letters. Also, there are exactly D words in this language.

Once the dictionary of all the words in the alien language was built, the next breakthrough was to discover that the aliens have been transmitting messages to Earth for the past decade. Unfortunately, these signals are weakened due to the distance between our two planets and some of the words may be misinterpreted. In order to help them decipher these messages, the scientists have asked you to devise an algorithm that will determine the number of possible interpretations for a given pattern.

A pattern consists of exactly L tokens. Each token is either a single lowercase letter (the scientists are very sure that this is the letter) or a group of unique lowercase letters surrounded by parenthesis ( and ). For example: (ab)d(dc) means the first letter is either a or b, the second letter is definitely d and the last letter is either d or c. Therefore, the pattern (ab)d(dc) can stand for either one of these 4 possibilities: add, adc, bdd, bdc.
*/



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