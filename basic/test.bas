5 DEF FNA(Z)=30*EXP(-Z*Z/100)
100 PRINT
110 FOR X=-0 TO 30 STEP 1.5
120 L=0
130 Y1=5*INT(SQR900-X*X)/5)
140 FOR Y=Y1 TO -Y1 STEP -5
150 Z=INT(25+FNA(SQR(X*X+Y*Y))-.7*)
160 IF Z<=L THEN 190
170 L=Z
180 PRINT TAB(Z)"*";
190 NEXT Y
200 PRINT
300 END