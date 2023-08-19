?-op(140, fy, neg).
?-op(160, xfy, [and, or, imp, revimp, uparrow, downarrow, notimp, notrevimp]).
member(X, [X | _]).
member(X, [_ | Tail]) :- member(X, Tail).

remove(X, [], []).
remove(X, [X | Tail], Newtail) :- remove(X, Tail, Newtail).
remove(X, [Head | Tail], [Head | Newtail]) :- remove(X, Tail, Newtail).

conjunctive(_ and _).
conjunctive(neg(_ or _)).
conjunctive(neg(_ imp _)).
conjunctive(neg(_ revimp _)).
conjunctive(neg(_ uparrow _)).
conjunctive(_ downarrow _).
conjunctive(_ notimp _).
conjunctive(_ notrevimp _).

disjunctive(neg(_ and _)).
disjunctive(_ or _).
disjunctive(_ imp _).
disjunctive(_ revimp _).
disjunctive(_ uparrow _).
disjunctive(neg(_ downarrow _)).
disjunctive(neg(_ notimp _)).
disjunctive(neg(_ notrevimp _)).

unary(neg neg _).
unary(neg true).
unary(neg false).

components(X and Y, X, Y).
components(neg(X and Y), neg X, neg Y).
components(X or Y, X, Y).
components(neg(X or Y), neg X, neg Y).
components(X imp Y, neg X, Y).
components(neg(X imp Y), X, neg Y).
components(X revimp Y, X, neg Y).
components(neg(X revimp Y), neg X, y).
components(X uparrow Y, neg X, neg y).
components(neg(X uparrow Y), X, y).
components(X downarrow Y, neg X, neg Y).
components(neg(X downarrow Y), X, Y).
components(X notimp Y, X, neg Y).
components(neg(X notimp Y), neg X, Y).
components(X notrevimp Y, neg X, Y).
components(neg(X notrevimp Y), X, neg Y).

component(neg neg X, X).
component(neg true, false).
component(neg false, true).

singlestep([Conjunction | Rest], New) :-
    member(Formula, Conjunction),
    unary(Formula),
    component(Formula, Newformula),
    remove(Formula, Conjunction, Temporary),
    Newconjunction = [Newformula | Temporary],
    New = [Newconjunction | Rest].

singlestep([Conjunction | Rest], New) :-
    member(Beta, Conjunction),
    disjunctive(Beta),
    components(Beta, Betaone, Betatwo),
    remove(Beta, Conjunction, Temporary),
    Newconone = [Betaone | Temporary],
    Newcontwo = [Betatwo | Temporary],
    New = [Newconone, Newcontwo | Rest].

singlestep([Conjunction | Rest], [Conjunction | Newrest]) :- singlestep(Rest, Newrest).

expand(Dis, Newdis) :-
    singlestep(Dis, Temp),
    expand(Temp, Newdis).

expand(Dis, Dis).

dualclauseform(X, Y) :- expand([[X]], Y).
