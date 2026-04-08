$onText
GAMS knows a concept called *ordered sets*
(https://www.gams.com/53/docs/UG_OrderedSets.html?search=ordered%20set).
Ordered sets know the sequence of their elements. They also know
the order of the element, i.e., which element is the first, second, etc.

Ordered sets are useful to model time periods that have a natural order.
$offText

Set
    t           time periods
    /t0, t1, t2, t3/
    tfirst(t)   first time period
    tlast(t)    last time period
;

$onText
Dynamically set the first and last period elements using
the order of the element (ord) and the cardinality of the
set (card), i.e., the number of elements in the set.
$offText
tfirst(t)$(ord(t) eq 1) = yes;
tlast(t)$(ord(t) eq card(t)) = yes;

display tfirst, tlast;

$onText
We can use lags and leads in ordered sets
simply using -1 and +1.
$offText

Parameter
    a(t)    some dynamic parameter
;
a(tfirst) = 1;

$onText
Use a loop over the set of periods to fill the
parameter over all periods.
$offText

loop(t$(ord(t) gt 1),
    a(t) = 2*a(t-1);
);
display a;


    