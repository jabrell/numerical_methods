$onText
Mixed Complementarity Problem (MCP) for a perfect
competition model with labor and product market.
$offText

*######################################################
*          PARAMETER DEFINITIONS AND DATA
*######################################################
set
    i       firms
    /i1/
;

Parameter
    lab         constant labor supply                   /100/
    c(i)        transformation from labor to product for firm i
    /i1 1/
    a           intercept demand function               /200/
    b           slope demand function                   /2/
;

*######################################################
*      VARIABLE DEFINITIONS AND EQUATION ASSIGNMENTS 
*######################################################
Positive Variable
    SUP(i)      supply by firm i using facility f
    P           product price
    PL          labor price
;

Equation
    zpf_SUP(i)    zero profits supply
    mkt_P         market clearing product
    mkt_PL        market clearing labor
;

zpf_SUP(i)..
    PL/c(i)     =G= P
;

mkt_P..
    sum(i, SUP(i))
                =G= a - b*P
;

mkt_PL..
    lab         =G= sum(i, SUP(i)/c(i))
;

*######################################################
*                  MODEL DEFINITION
*######################################################
Model perfect MCP for perfect competition model
    /zpf_SUP.SUP,
     mkt_P.P,
     mkt_PL.PL
/;

P.L = 1;
PL.L = 1;
SUP.L(i) = 100;

solve perfect using MCP;
    