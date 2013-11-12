%{

//TODO Put your favorite license here
		
// yacc source generated by ebnf2y[1]
// at 2013-10-28 21:55:18.384979255 -0400 EDT
//
//  $ ebnf2y -start=Module -o agora.y compiler/agora.ebnf
//
// CAUTION: If this file is a Go source file (*.go), it was generated
// automatically by '$ go tool yacc' from a *.y file - DO NOT EDIT in that case!
// 
//   [1]: http://github.com/cznic/ebnf2y

package main //TODO real package name

//TODO required only be the demo _dump function
import (
	"bytes"
	"fmt"
	"strings"

	"github.com/cznic/strutil"
)

%}

%union {
	item interface{} //TODO insert real field(s)
}

%token	BINARY_OP
%token	BOOLEAN
%token	FLOAT
%token	IDENTIFIER
%token	INTEGER
%token	STR
%token	UNARY_OP

%type	<item> 	/*TODO real type(s), if/where applicable */
	BINARY_OP
	BOOLEAN
	FLOAT
	IDENTIFIER
	INTEGER
	STR
	UNARY_OP

%token	TOK1	/*TODO Name for ":=" */
%token	TOK2	/*TODO Name for "--" */
%token	TOK3	/*TODO Name for "++" */

%type	<item> 	/*TODO real type(s), if/where applicable */
	TOK1
	TOK2
	TOK3

%token FUNC

%type	<item> 	/*TODO real type(s), if/where applicable */
	ArgumentList
	Assignment
	BasicLit
	Block
	Block1
	Call
	Call1
	Call11
	CompositeLit
	Element
	ElementIndex
	ElementList
	ElementList1
	Expression
	ExpressionList
	ExpressionList1
	ExpressionStmt
	FieldName
	Function
	FunctionBody
	FunctionLit
	IdentifierList
	IdentifierList1
	IncDecStmt
	IncDecStmt1
	IndexSelector
	Key
	Literal
	LiteralValue
	LiteralValue1
	LiteralValue11
	Module
	Module1
	Operand
	OperandName
	Parameter
	ParameterList
	ParameterList1
	Parameters
	Parameters1
	Parameters11
	PrimaryExpr
	QualifiedIdent
	Selector
	ShortVarDecl
	Signature
	SimpleStmt
	Start
	Statement
	UnaryExpr
	Value

/*TODO %left, %right, ... declarations */

%start Start

%%

ArgumentList:
	ExpressionList
	{
		$$ = $1 //TODO 1
	}

Assignment:
	ExpressionList '=' ExpressionList
	{
		$$ = []Assignment{$1, "=", $3} //TODO 2
	}

BasicLit:
	INTEGER
	{
		$$ = $1 //TODO 3
	}
|	FLOAT
	{
		$$ = $1 //TODO 4
	}
|	STR
	{
		$$ = $1 //TODO 5
	}
|	BOOLEAN
	{
		$$ = $1 //TODO 6
	}

Block:
	'{' Block1 '}'
	{
		$$ = []Block{"{", $2, "}"} //TODO 7
	}

Block1:
	/* EMPTY */
	{
		$$ = []Block1(nil) //TODO 8
	}
|	Block1 Statement ';'
	{
		$$ = append($1.([]Block1), $2, ";") //TODO 9
	}

Call:
	'(' Call1 ')'
	{
		$$ = []Call{"(", $2, ")"} //TODO 10
	}

Call1:
	/* EMPTY */
	{
		$$ = nil //TODO 11
	}
|	ArgumentList Call11
	{
		$$ = []Call1{$1, $2} //TODO 12
	}

Call11:
	/* EMPTY */
	{
		$$ = nil //TODO 13
	}
|	','
	{
		$$ = "," //TODO 14
	}

CompositeLit:
	LiteralValue
	{
		$$ = $1 //TODO 15
	}

Element:
	Key ':' Value
	{
		$$ = []Element{$1, ":", $3} //TODO 16
	}

ElementIndex:
	Expression
	{
		$$ = $1 //TODO 17
	}

ElementList:
	Element ElementList1
	{
		$$ = []ElementList{$1, $2} //TODO 18
	}

ElementList1:
	/* EMPTY */
	{
		$$ = []ElementList1(nil) //TODO 19
	}
|	ElementList1 ',' Element
	{
		$$ = append($1.([]ElementList1), ",", $3) //TODO 20
	}

Expression:
	UnaryExpr
	{
		$$ = $1 //TODO 21
	}
|	Expression BINARY_OP UnaryExpr
	{
		$$ = []Expression{$1, $2, $3} //TODO 22
	}

ExpressionList:
	Expression ExpressionList1
	{
		$$ = []ExpressionList{$1, $2} //TODO 23
	}

ExpressionList1:
	/* EMPTY */
	{
		$$ = []ExpressionList1(nil) //TODO 24
	}
|	ExpressionList1 ',' Expression
	{
		$$ = append($1.([]ExpressionList1), ",", $3) //TODO 25
	}

ExpressionStmt:
	Expression
	{
		$$ = $1 //TODO 26
	}

FieldName:
	IDENTIFIER
	{
		$$ = $1 //TODO 27
	}

Function:
	Signature FunctionBody
	{
		$$ = []Function{$1, $2} //TODO 28
	}

FunctionBody:
	Block
	{
		$$ = $1 //TODO 29
	}

FunctionLit:
	FUNC Function
	{
		$$ = []FunctionLit{"func", $2} //TODO 30
	}

IdentifierList:
	IDENTIFIER IdentifierList1
	{
		$$ = []IdentifierList{$1, $2} //TODO 31
	}

IdentifierList1:
	/* EMPTY */
	{
		$$ = []IdentifierList1(nil) //TODO 32
	}
|	IdentifierList1 ',' IDENTIFIER
	{
		$$ = append($1.([]IdentifierList1), ",", $3) //TODO 33
	}

IncDecStmt:
	Expression IncDecStmt1
	{
		$$ = []IncDecStmt{$1, $2} //TODO 34
	}

IncDecStmt1:
	TOK3 /* "++" */
	{
		$$ = "++" //TODO 35
	}
|	TOK2 /* "--" */
	{
		$$ = "--" //TODO 36
	}

IndexSelector:
	'[' Expression ']'
	{
		$$ = []IndexSelector{"[", $2, "]"} //TODO 37
	}

Key:
	FieldName
	{
		$$ = $1 //TODO 38
	}
|	ElementIndex
	{
		$$ = $1 //TODO 39
	}

Literal:
	BasicLit
	{
		$$ = $1 //TODO 40
	}
|	CompositeLit
	{
		$$ = $1 //TODO 41
	}
|	FunctionLit
	{
		$$ = $1 //TODO 42
	}

LiteralValue:
	'{' LiteralValue1 '}'
	{
		$$ = []LiteralValue{"{", $2, "}"} //TODO 43
	}

LiteralValue1:
	/* EMPTY */
	{
		$$ = nil //TODO 44
	}
|	ElementList LiteralValue11
	{
		$$ = []LiteralValue1{$1, $2} //TODO 45
	}

LiteralValue11:
	/* EMPTY */
	{
		$$ = nil //TODO 46
	}
|	','
	{
		$$ = "," //TODO 47
	}

Module:
	Module1
	{
		$$ = $1 //TODO 48
	}

Module1:
	/* EMPTY */
	{
		$$ = []Module1(nil) //TODO 49
	}
|	Module1 Statement ';'
	{
		$$ = append($1.([]Module1), $2, ";") //TODO 50
	}

Operand:
	Literal
	{
		$$ = $1 //TODO 51
	}
|	OperandName
	{
		$$ = $1 //TODO 52
	}
|	'(' Expression ')'
	{
		$$ = []Operand{"(", $2, ")"} //TODO 53
	}

OperandName:
	IDENTIFIER
	{
		$$ = $1 //TODO 54
	}
|	QualifiedIdent
	{
		$$ = $1 //TODO 55
	}

Parameter:
	IDENTIFIER
	{
		$$ = $1 //TODO 56
	}

ParameterList:
	Parameter ParameterList1
	{
		$$ = []ParameterList{$1, $2} //TODO 57
	}

ParameterList1:
	/* EMPTY */
	{
		$$ = []ParameterList1(nil) //TODO 58
	}
|	ParameterList1 ',' Parameter
	{
		$$ = append($1.([]ParameterList1), ",", $3) //TODO 59
	}

Parameters:
	'(' Parameters1 ')'
	{
		$$ = []Parameters{"(", $2, ")"} //TODO 60
	}

Parameters1:
	/* EMPTY */
	{
		$$ = nil //TODO 61
	}
|	ParameterList Parameters11
	{
		$$ = []Parameters1{$1, $2} //TODO 62
	}

Parameters11:
	/* EMPTY */
	{
		$$ = nil //TODO 63
	}
|	','
	{
		$$ = "," //TODO 64
	}

PrimaryExpr:
	Operand
	{
		$$ = $1 //TODO 65
	}
|	PrimaryExpr Selector
	{
		$$ = []PrimaryExpr{$1, $2} //TODO 66
	}
|	PrimaryExpr IndexSelector
	{
		$$ = []PrimaryExpr{$1, $2} //TODO 67
	}
|	PrimaryExpr Call
	{
		$$ = []PrimaryExpr{$1, $2} //TODO 68
	}

QualifiedIdent:
	IDENTIFIER '.' IDENTIFIER
	{
		$$ = []QualifiedIdent{$1, ".", $3} //TODO 69
	}

Selector:
	'.' IDENTIFIER
	{
		$$ = []Selector{".", $2} //TODO 70
	}

ShortVarDecl:
	IdentifierList TOK1 /* ":=" */ ExpressionList
	{
		$$ = []ShortVarDecl{$1, ":=", $3} //TODO 71
	}

Signature:
	Parameters
	{
		$$ = $1 //TODO 72
	}

SimpleStmt:
	ExpressionStmt
	{
		$$ = $1 //TODO 73
	}
|	IncDecStmt
	{
		$$ = $1 //TODO 74
	}
|	Assignment
	{
		$$ = $1 //TODO 75
	}
|	ShortVarDecl
	{
		$$ = $1 //TODO 76
	}

Start:
	Module
	{
		_parserResult = $1 //TODO 77
	}

Statement:
	SimpleStmt
	{
		$$ = $1 //TODO 78
	}

UnaryExpr:
	PrimaryExpr
	{
		$$ = $1 //TODO 79
	}
|	UNARY_OP UnaryExpr
	{
		$$ = []UnaryExpr{$1, $2} //TODO 80
	}

Value:
	Expression
	{
		$$ = $1 //TODO 81
	}
|	LiteralValue
	{
		$$ = $1 //TODO 82
	}

%%

//TODO remove demo stuff below

var _parserResult interface{}

type (
	ArgumentList interface{}
	Assignment interface{}
	BasicLit interface{}
	Block interface{}
	Block1 interface{}
	Call interface{}
	Call1 interface{}
	Call11 interface{}
	CompositeLit interface{}
	Element interface{}
	ElementIndex interface{}
	ElementList interface{}
	ElementList1 interface{}
	Expression interface{}
	ExpressionList interface{}
	ExpressionList1 interface{}
	ExpressionStmt interface{}
	FieldName interface{}
	Function interface{}
	FunctionBody interface{}
	FunctionLit interface{}
	IdentifierList interface{}
	IdentifierList1 interface{}
	IncDecStmt interface{}
	IncDecStmt1 interface{}
	IndexSelector interface{}
	Key interface{}
	Literal interface{}
	LiteralValue interface{}
	LiteralValue1 interface{}
	LiteralValue11 interface{}
	Module interface{}
	Module1 interface{}
	Operand interface{}
	OperandName interface{}
	Parameter interface{}
	ParameterList interface{}
	ParameterList1 interface{}
	Parameters interface{}
	Parameters1 interface{}
	Parameters11 interface{}
	PrimaryExpr interface{}
	QualifiedIdent interface{}
	Selector interface{}
	ShortVarDecl interface{}
	Signature interface{}
	SimpleStmt interface{}
	Start interface{}
	Statement interface{}
	UnaryExpr interface{}
	Value interface{}
)
	
func _dump() {
	s := fmt.Sprintf("%#v", _parserResult)
	s = strings.Replace(s, "%", "%%", -1)
	s = strings.Replace(s, "{", "{%i\n", -1)
	s = strings.Replace(s, "}", "%u\n}", -1)
	s = strings.Replace(s, ", ", ",\n", -1)
	var buf bytes.Buffer
	strutil.IndentFormatter(&buf, ". ").Format(s)
	buf.WriteString("\n")
	a := strings.Split(buf.String(), "\n")
	for _, v := range a {
		if strings.HasSuffix(v, "(nil)") || strings.HasSuffix(v, "(nil),") {
			continue
		}
	
		fmt.Println(v)
	}
}

// End of demo stuff