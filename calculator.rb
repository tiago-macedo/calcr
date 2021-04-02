=begin

/===============\
| The language: |
\===============/

white_space : (' ' | '\t')* 

integer    : [0-9]+
float      : {integer}.{integer}
scientific : ({integer} | {float}) (e | E) '-'? {integer}

number     : {integer} | {float} | {scientific}
operator   : '+' | '-' | '*' | '/'
'('
')'

/==============\
| The grammar: |
\==============/

S -> expr

expr -> expr + term
      | expr - term
	  | term

term -> term * fact
      | term / fact
	  | fact

fact -> NUM
      | '(' expr ')'

=end

class Calculator
	def initialize()
		@parser = Parser.new
		@lexer = Lexer.new
	end
end

class Parser
	def parse(input)
	end
end

class Lexer
	attr_accessor :line
	attr_reader :idx
	
	def initialize
		@idx = 0
	end

	def next
		puts @idx
		whitespace
		p @idx
		if @idx >= @line.length
			return Token.new("", "end")
		end
		char = @line[@idx]
		ascii = char.ord
		if ascii >= 48 && ascii <= 57 # [0-9]
			return number
		end
		@idx += 1
		case char
			when '+', '-', '*', '/'
				return Token.new(char, "operator")
			when '('
				return Token.new(char, "(")
			when ')'
				return Token.new(char, ")")
			else
				puts "LEXER ERROR: " + char
		end
	end
	
	def number
		lexeme = integer
		if @line[@idx] == '.'
			lexeme << '.'
			@idx += 1
			lexeme << integer
		end
		return Token.new(lexeme, "number")
	end
	
	def integer
		lexeme = ""
		ascii = @line[@idx].ord
		while ascii >= 48 && ascii <= 57 # [0-9]
			lexeme << @line[@idx]
			@idx += 1
			ascii = @line[@idx].ord
		end
		return lexeme
	end
	
	def whitespace
		while @line[@idx] == ' ' || @line[@idx] == "\t"
			@idx += 1
		end
	end
end

class Token
	attr_reader :lexeme, :kind
	def initialize(lexeme, kind)
		@lexeme = lexeme
		@kind = kind
	end
end

lexer = Lexer.new
string = "  1+399 * (4 + 7.5 -	3)	"
lexer.line = string
puts "length = " + string.length.to_s
token = lexer.next
while token.kind != "end"
	puts "lexeme: " + token.lexeme + " | kind: " + token.kind
	token = lexer.next
end
puts "line: \"" + lexer.line + "\""
puts "idx:    " + lexer.idx.to_s
