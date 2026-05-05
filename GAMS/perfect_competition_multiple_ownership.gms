$onText
Mixed Complementarity Problem (MCP) for a perfect
competition model with labor and product market.

This version extends the perfect competition model
for multiple firms with capacity constraints.
Each firm owns one or more facilities that are characterized
by their production technology in terms of the labor
transformation coefficient and the installed capacity.

This version uses a parameter to determine the ownership
share of firm "i" in the capacity of facility "f"
$offText

*######################################################
*          PARAMETER DEFINITIONS AND DATA
*######################################################
set
    i       firms
    /i1, i2/
    f       facilities
    /f1, f2/
;

Parameter
    lab         constant labor supply                   /100/
*   compare to simple perfect competition model the transformation
*   coefficient and capacity now depend on the facility
    c(f)        transformation from labor to product for facility f
    /f1 1
     f2 0.5/
    cap(f)      production capacity of facility f
    /f1 50
     f2 100/
    a           intercept demand function               /200/
    b           slope demand function                   /2/
*   the ownership coefficient determines how much of the capacity
*   of facility "f" can be used by firm "f"
*   Note: The default value in GAMS is always zero
    owner(f,i)  ownership share of firm i for facility f
    /f1.i1   1
     f2.i2   1/
;

*######################################################
*      VARIABLE DEFINITIONS AND EQUATION ASSIGNMENTS 
*######################################################
Positive Variable
*   supply is now reflecting how much firm "i" is producing
*   using facility "f"
    SUP(f,i)    supply by firm i using facility f
*   Capacity price is now reflecting how scarce the share owned by
*   firm i in capacity of facility f is for that firm
    PCAP(f,i)     capacity price of facility f
    P           product price
    PL          labor price
;

Equation
*   Zero-profit condition reflects the differentiation by facility
    zpf_SUP(f,i)    zero profits supply
*   Likewise, the capacity constraint is facility specific
    mkt_cap(f,i)    market clearing capacity 
    mkt_P           market clearing product
    mkt_PL          market clearing labor
;

zpf_SUP(f,i)..
    PL/c(f) +  PCAP(f,i)
                =G= P
;

mkt_cap(f,i)..
    owner(f,i)*cap(f)
                =G= SUP(f,i)
;

mkt_P..
*   Sum over the supply od all firms and facilities
    sum((f,i), SUP(f,i))
                =G= a - b*P
;

mkt_PL..
*   sum over all firms and facilites
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
PCAP.L(f,i) = 1;

solve perfect using MCP;
    