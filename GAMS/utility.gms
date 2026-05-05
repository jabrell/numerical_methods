$onText
Standard utility maximization problem formulated as
Mixed Complementarity Problem (MCP).
$offText

*######################################################
*          PARAMETER DEFINITIONS AND DATA
*######################################################
Parameter
    alpha   Cobb-Douglas coefficient X  /0.3/
    px      Price of commodity X        /1/
    py      Price of commodity Y        /2/
    INC     income                      /100/
;

*######################################################
*      VARIABLE DEFINITIONS AND EQUATION ASSIGNMENTS 
*######################################################
Positive Variable
    X       consumption of X commodity
    Y       consumption of Y commodity
    P_INC   shadow price of income
;

Equations
    zpf_X   zero-profits X consumption
    zpf_Y   zero-profits Y consumption
    mkt_inc income balance
;


zpf_X..
    P_INC*px*X  =G= alpha*(X**alpha)*(Y**(1-alpha))
;

zpf_Y..
    P_INC*pY*Y  =G= (1-alpha)*(X**alpha)*(Y**(1-alpha))
;

mkt_inc..
    INC          =G= px*X + py*Y
;

*######################################################
*                  MODEL DEFINITION
*######################################################
Model utility MCP for utility optimization
    /zpf_x.X,
     zpf_Y.Y,
     mkt_inc.P_INC
/;


*######################################################
*                      SOLVING 
*######################################################
* GAMS by default using a starting point of zero for all
* variables. That, however, leads to problems as the 
* derivative of the equation is not defined for zero.
* We, thus, set the initial values to
* something different and also define some lower bounds.
X.L = 1;
Y.L = 1;
P_INC.L = 1;

* While that is enough here, you could also choose a close
* to zero value as lower bound.
* But carefully inspect your problem if the solution is at
* one of these lower bounds.
X.LO = 1e-9;
Y.LO = 1e-9;
P_INC.LO = 1e-9;
 
solve utility using MCP;


