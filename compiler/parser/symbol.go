package parser

import (
	"bytes"
	"fmt"
	"strings"

	"github.com/PuerkitoBio/agora/compiler/token"
)

type Arity int

const (
	// Initial possible arities, until we know more about the context
	ArName Arity = iota
	ArLiteral
	ArOperator

	// Then it can be set to something more precise
	ArUnary
	ArBinary
	ArTernary
	ArStatement
	ArThis
	ArFunction
	ArImport
)

var (
	arNames = [...]string{
		ArName:      "Name",
		ArLiteral:   "Literal",
		ArOperator:  "Operator",
		ArUnary:     "Unary",
		ArBinary:    "Binary",
		ArTernary:   "Ternary",
		ArStatement: "Statement",
		ArThis:      "This",
		ArFunction:  "Function",
		ArImport:    "Import",
	}
)

func (ar Arity) String() string {
	return arNames[ar]
}

func itselfLed(s, left *Symbol) *Symbol {
	return left
}

func itselfNud(s *Symbol) *Symbol {
	return s
}

func itselfStd(s *Symbol) interface{} {
	return s
}

type Symbol struct {
	p      *Parser
	Id     string
	Val    interface{}
	Name   string
	Key    interface{}
	lbp    int
	Ar     Arity
	res    bool
	asg    bool
	tok    token.Token
	pos    token.Position
	First  interface{} // May all be []*Symbol or *Symbol
	Second interface{}
	Third  interface{}

	nudfn func(*Symbol) *Symbol
	ledfn func(*Symbol, *Symbol) *Symbol
	stdfn func(*Symbol) interface{} // May return []*Symbol or *Symbol
}

func (s Symbol) clone() *Symbol {
	return &Symbol{
		s.p,
		s.Id,
		s.Val,
		s.Name,
		s.Key,
		s.lbp,
		s.Ar,
		s.res,
		s.asg,
		s.tok,
		s.pos,
		s.First,
		s.Second,
		s.Third,
		s.nudfn,
		s.ledfn,
		s.stdfn,
	}
}

func (s *Symbol) led(left *Symbol) *Symbol {
	if s.ledfn == nil {
		s.p.error(s, "missing operator")
	}
	return s.ledfn(s, left)
}

func (s *Symbol) std() interface{} {
	if s.stdfn == nil {
		s.p.error(s, "invalid operation")
	}
	return s.stdfn(s)
}

func (s *Symbol) nud() *Symbol {
	if s.nudfn == nil {
		s.p.error(s, "undefined")
	}
	return s.nudfn(s)
}

func (s *Symbol) String() string {
	return s.indentString(0)
}

func (s *Symbol) indentString(ind int) string {
	buf := bytes.NewBuffer(nil)
	buf.WriteString(fmt.Sprintf("%-20s; %v", s.Id, s.Val))
	if s.Name != "" {
		buf.WriteString(fmt.Sprintf(" (nm: %s)", s.Name))
	}
	if s.Key != nil {
		buf.WriteString(fmt.Sprintf(" (key: %s)", s.Key))
	}
	buf.WriteString(fmt.Sprintf(" (arity: %s)", s.Ar))
	buf.WriteString("\n")

	fmtChild := func(idx int, child interface{}) {
		if child != nil {
			switch v := child.(type) {
			case []*Symbol:
				for i, c := range v {
					buf.WriteString(fmt.Sprintf("%s[%d.%d] %s", strings.Repeat(" ", (ind+1)*3), idx, i+1, c.indentString(ind+1)))
				}
			case *Symbol:
				buf.WriteString(fmt.Sprintf("%s[%d] %s", strings.Repeat(" ", (ind+1)*3), idx, v.indentString(ind+1)))
			}
		}
	}
	fmtChild(1, s.First)
	fmtChild(2, s.Second)
	fmtChild(3, s.Third)
	return buf.String()
}