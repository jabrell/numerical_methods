$onText
Mixed Complementarity Problem (MCP) for a perfect
competition model with labor and product market.

This version extends the perfect competition model
for multiple firms with capacity constraints.
Each firm owns one or more facilities that are characterized
by their production technology in terms of the labor
transformation coefficient and the installed capacity.

To establish the link between firms and the production
facilities, we use a two dimensional set that indicates
whether firm i owns facility f.
$offText

*######################################################
*          PARAMETER DEFINITIONS AND DATA
*######################################################
set
    i       firms
    /i1, i2/
    f       facilities
    /f1, f2/
*   To establish the link between firms and the production
*   facilities, we use a two dimensional set that indicates
*   whether firm i owns facility f.
*   Here: firm i1 owns f1 and firm i2 owns facility f2
    i_own_f firm i owns facility f
    /i1.f1, i2.f2/
;

Parameter
    lab     constant labor supply                   /100/
*   compare to simple perfect competition model the transformation
*   coefficient and capacity now depend on the facility
    c(f)    transformation from labor to product for facility f
    /f1 1
     f2 0.5/
    cap(f)  production capacity of facility f
    /f1 50
     f2 100/
    a       intercept demand function               /200/
    b       slope demand function                   /2/
;

*######################################################
*      VARIABLE DEFINITIONS AND EQUATION ASSIGNMENTS 
*######################################################
Positive Variable
*   supply is now reflecting how much firm "i" is producing
*   using facility "f"
    SUP(f,i)    supply by firm i using facility f
*   Capacity price is now facility specific
    PCAP(f)     capacity price of facility f
    P           product price
    PL          labor price
;

Equation
*   Zero-profit condition reflects the differentiation by facility
    zpf_SUP(f,i)    zero profits supply
*   Likewise, the capacity constraint is facility specific
    mkt_cap(f)      market clearing capacity 
    mkt_P           market clearing product
    mkt_PL          market clearing labor
;

zpf_SUP(f,i)..
*   Note that the set "i" is controlled in the equation
*   this the sum is over all facilities "f" that belong to
*   firm i
    PL/c(f) +  PCAP(f)
                =G= P
;

mkt_cap(f)..
*   Here the set "f" is controlled be the equation
*   Thus the sum goes over all "i" that associated
*   with facility "f"
    cap(f)      =G= sum(i, SUP(f,i))
;

mkt_P..
    sum((f,i), SUP(f,i))
                =G= a - b*P
;

mkt_PL..
    lab         =G= sum((f,i), SUP(f,i)/c(f))
;

*######################################################
*                  MODEL DEFINITION
*######################################################
Model perfect MCP for perfect competition model
    /zpf_SUP.SUP,
     mkt_CAP.PCAP
     mkt_P.P,
     mkt_PL.PL
/;

P.L = 1;
PL.L = 1;
SUP.L(f,i) = 100;
PCAP.L(f) = 1;

*!!!!! Important: Fix the supply to zero if a firm does not own the capacity
SUP.FX(f,i)$(not i_own_f(i,f)) = 0;

solve perfect using MCP;
    