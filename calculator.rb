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

S -> expr { run($1) }

expr -> expr + term { $$ = $1 + $2 + "+" }
      | expr - term { $$ = $1 + $2 + "-" }
	  | term        { $$ = $1 }

term -> term * fact { $$ = $1 + $2 + "*" }
      | term / fact { $$ = $1 + $2 + "/" }
	  | fact        { $$ = $1 }

fact -> NUM          { $$ = $1 }
      | '(' expr ')' { $$ = $2 }

=end

class Calculator
  def initialize()
	@parser = Parser.new
	@lexer = Lexer.new
  end
end

class Parser

  class ParserError < ::RuntimeError
  end

  class BadToken < ParserError
  end
  
  attr_accessor :tokens
  attr_reader :idx

  def initialize
    @idx = 0
  end

  def match(expected)
    if @tokens[@idx].kind == expected
      @idx += 1
    else
      raise BadToken, "expected " + expected + ", got " + @tokens[@idx].to_s
    end
  end

  def parse(input)
    @idx = 0
    S(input)
  end

  def S(input)
    puts expr(input)
  end

  def expr(input)
  end
  
  def term
    
  end
  
  def fact
    case @tokens[@idx].kind
      when "open-parenthesis"
        match("open-parenthesis")
        expr
        match("close-parenthesis")
      when "number"
        return @tokens[@idx].lexeme
      else
        raise BadToken, "expected a factor, got " + @token[@idx]
    end
  end
  
end

class Lexer
  
  class LexerError < ::RuntimeError
  end
  class BadChar < LexerError
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

  	raise BadChar, "Invalid character: " + char
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

  def ==(other)
    @kind == other.kind && @lexeme == other.lexeme
  end

  def to_s
    "\"" + @lexeme + "\"(" + @kind + ")"
  end
end
