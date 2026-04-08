*######################################################
*          PARAMETER DEFINTIONS AND DATA
*######################################################

* Comments start with * in the first column of a line
* Multi-line comments are wrapped into $onText/$offText

$onText
Definitions always start with a keyword (set, parameter, variable...)
followed by one or serveral item to be defined.


An item is defined by the GAMS name of the item followed by
an explanatory string. The explanatory string is optional
but you always should make use of it. In particular, use them
to keep track of the units of your items.

GAMS allows to define the item together with the data it
contains. If you do so the data are wrapped between
slashed (/) and separated by commas.

Every GAMS statement ends with a semi-colon.

GAMS is flexible regarding indentation and code formatting. To
keep an overview over your code, however, make use of indentation.
$offText

Set
    i production sites
    /seattle, san_diego/,
    j consumption sites
    /new_york, chicago, topeka/
;

$onText
Parameters are the exogenous data that you feed into your problem.
The syntax is the same as for sets, there are different ways to
define and assign data to them.

- Scalars: Are parameters that do not depend on any set
- Parameters: Are parameters that depend on sets.
- Tables: Are an data input format to allow for mulit-dimensional
        parameters.
        
Parameters is the most general approach as it allows to also declare
Scalars and the values for multi-dimensional data.
Be careful with tables, as they require strict allignment of the column
values.

If parameters relate to a set, the relation is given parentheses. The order
matters and GAMS will check input data whether the reference is correct
(-> Domain violation for element)
$offText

Scalar
    cf          transport cost [$ per 1000 mi]   /90/
;

Parameters
    
    capacity(i)      capacity of plant i [t] /
        seattle     350
        san_diego   600
    /,
    demand(j)  demand at market j [t]
    /   new_york    325
        chicago     300
        topeka      275
    /
;
    
Table distance(i,j)  distance in thousands of miles
                  new_york       chicago      topeka
    seattle          2.5           1.7          1.8
    san_diego        2.5           1.8          1.4
;

$onText
Also possible
parameter
    distance(i,j)   distance in thousands of miles /
        seattle.new_york    2.5,
        san_diego.new_york  2.5,
        seattle.chicago     1.7
        ...
    /
;
$offText

$onText
It is possible to define parameters and assign the data
later on.
$offText

Parameter
    c(i,j)      tranport cost from production site i to demand site j [1000 $]
;

c(i,j) = cf*distance(i,j)/1000;


*######################################################
*      VARIABLE DEFINTIONS AND EQUATION ASSIGNMENTS 
*######################################################
$onText
Variable definitions follow the same rules as other items.
The can be free in sign or "Postive".

Note that the value of your objective function must be
free in sign.

Remember our convention: Variables are named in CAPITAL letters.
$offText

Variable
    COST        objective value: Total transport cost [$]
;

Positive Variable
    X(i,j)      quantity shipped from production site i to demand site j [t]
;


$onText
Equation definitions follow the same rules as other items.

Convention:
    - We name equations in lower cases
    - If you have an interpreation for your equaltion it helps to use prefixes
      for the names:
        - mkt_ -> Market clearing interpretation
        - zpf_ -> Zero-profit interpretation
$offText

Equation
    obj         objective function: Definition of total transport cost [1000 $]
    mkt_cap(i)  market clearing: production capacity at production site i [t]
    mkt_dem(j)  market clearing: product market clearning at demand site j [t]
;

$onText
Equations get assigned a relation that relates the left- and right-hand side
using an operator (=G=, =E=, =L=).

Convention:
    - We avoid using =L=
    
An equation assignment starts with the name of the equation including its
references to sets followed by ".."

For readability, it helps to put a short comment on top of the equation
shortly stating what the equation is doing.
$offText

* Objective: Total cost
obj..
    COST            =E= sum((i,j), c(i,j)*X(i,j))
;

* Production capacity constraint
mkt_cap(i)..
    capacity(i)     =G= sum(j, X(i,j))
;

* Satisfy demand at each site
mkt_dem(j)..
    sum(i, X(i,j))  =G= demand(j)
;


*######################################################
*                  MODEL DEFINITION
*######################################################
$onText
A model is a collection of equations and follows the usual
way of defining and item.
$offText

model transport GAMS tutorial transport model /
    obj,
    mkt_cap,
    mkt_dem
/;

*######################################################
*                      SOLVING 
*######################################################
$onText
A model is solved using the "solve" statement. The
statement requires the name, the direction (minimum/maximum)
and the name of the objective function.
$offText
solve transport using LP minimizing COST;

$onText
You can display the value (Level, .L) and marginal (.M)
of and variable and quation using the display statement.

The value show up in the .lst file created when the file is
executed.

However, it is usually more convenient to use the gdx
file generated by the model run (remember to set this
above in the command line interface).
$offText
display X.L, mkt_cap.M;

$onText
Often it is useful to write some report variables. For this you can
simply define new parameters and assign them values.

Remember:
-   To get the level (i.e., value) of a variable you must use .L
-   To get the marginal (i.e., dual variable) of an equation you must use .M
$offtext

Parameter
    total_production(i) total production of supply site j [t]
    demand_price(j)     final demand price at demand site i [CHF per t]
;

total_production(i) = sum(j, X.L(i,j));
demand_price(j) = mkt_dem.M(j);

display total_production, demand_price;







    









