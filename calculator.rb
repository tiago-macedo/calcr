=begin
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
		c = @line[@idx]
		case c
			when ' ', '\t', '\n'
				whitespace
			else
				puts "LEXER ERROR MESSAGE"
		end
	end

	def whitespace
		while @line[@idx] == ' ' || @line[@idx] == '\t' || @line[@idx] == '\n'
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
lexer.line = "   a	"
lexer.next
puts "line: \"" + lexer.line + "\""
puts "idx:    " + lexer.idx.to_s
