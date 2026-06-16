%option yylineno 

%{
#include <stdio.h>
%}

%%

[0-9]+     {
			printf("%3d\t:\t%4s\n", yylineno, yytext);		
			}

.|\n       ;


%%

int main(void) {
	yylex();
	printf("\n");
	return 0;
}




