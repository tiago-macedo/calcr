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
  
  class LexerError < ::RuntimeError
  end
  class IvalidChar < LexerError
  end

  attr_accessor :line
  attr_reader :idx
  
  @@One_character_tokens =  {
                              "+" => "operator",
                              "-" => "operator",
                              "*" => "operator",
                              "/" => "operator",
                              "(" => "open-parenthesis",
                              ")" => "close-parenthesis"
                            }
  
  def initialize
  	@idx = 0
  end
  
  def line=(newline)
    @line = newline
    @idx = 0
  end
  
  def next
    whitespace

    if @idx >= @line.length
  	return Token.new("", "end")
    end
    
    char = @line[@idx]
    if char >= '0' && char <= '9'
      return number
    end
    
    @idx += 1

    if @@One_character_tokens[char]
      return Token.new(char, @@One_character_tokens[char])
    end

  	raise IvalidChar, "Invalid character: " + char
  end
  
  private
  
  def number
  	lexeme = integer
  	if @line[@idx] && @line[@idx] == '.'
  	  lexeme << '.'
  	  @idx += 1
  	  lexeme << integer
  	end
  	return Token.new(lexeme, "number")
  end
  
  def integer
  	lexeme = ""
  	while @line[@idx] && @line[@idx] >= '0' && @line[@idx] <= '9'
  	  lexeme << @line[@idx]
  	  @idx += 1
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

