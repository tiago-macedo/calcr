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

S -> expr END { run($1) }

expr -> term expr~ { $$ = $1 $2 }

expr~ -> + term expr~ { $$ = $2 '+' $3 }
       | - term expr~ { $$ = $2 '-' $3 }
	   | ø      { $$ = nil }

term -> fact term~ { $$ = $1 $2 }

term~ -> * fact term~ { $$ = $2 '*' $3 }
       | / fact term~ { $$ = $2 '/' $3 }
	   | ø

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

  def parse
    @idx = 0
    return start
  end

  private
  
  def join(a, b)
    if not b and not a
      return nil
    elsif not b
      return a
    elsif not a
      return b
    end
    # both a and b are here
    b.each do |element|
      if element
        a << element
      end
    end
	return a
  end

  def start
    return expr
	match("end")
  end

  def expr
    v1 = term
    v2 = expr_
	return join(v1, v2)
  end

  def expr_
    plus  = Token.new("+", "operator")
    minus = Token.new("-", "operator")
    if @tokens[@idx] == plus
      match "operator"
      v2 = term
	  v3 = expr_
      return join(join(v2, [plus]), v3)
    elsif @tokens[@idx] == minus
      match "operator"
      v2 = term
	  v3 = expr_
      return join(join(v2, [minus]), v3)
    end
    return nil
  end
  
  def term
    v1 = fact
    v2 = term_
	return join(v1, v2)
  end
  
  def term_
    times = Token.new("*", "operator")
    over  = Token.new("/", "operator")
    if @tokens[@idx] == times
      match "operator"
      v2 = fact
	  v3 = term_
      return join(join(v2, [times]), v3)
    elsif @tokens[@idx] == over
      match "operator"
      v2 = fact
	  v3 = term_
      return join(join(v2, over), v3)
    end
    return nil
  end
  
  def fact
    case @tokens[@idx].kind
      when "open-parenthesis"
        match "open-parenthesis"
        v2 = expr
        match "close-parenthesis"
		return v2
      when "number"
        match "number"
        return [@tokens[@idx-1]]
      else
        raise BadToken, "expected a factor, got " + @tokens[@idx].to_s
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
  
  def run
    tokens = []
    loop do
      token = next_token
      tokens << token
      break if token.kind == "end"
    end
	return tokens
  end
  
  def next_token
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
  
  def inspect
    to_s
  end

end


class StackMachine

  class StackError < ::RuntimeError
  end

  class BadToken < StackError
  end

  attr_reader :stack

  def initialize
    @stack = []
  end

  def run(input)
    input.each do |token|
      case token.kind
		when  "number"
		  @stack << token.lexeme.to_f

		when "operator"
		  v2 = @stack.pop
		  v1 = @stack.pop
		  case token.lexeme
		    when "+"
			 @stack << v1 + v2 
		    when "-"
			 @stack << v1 - v2 
		    when "*"
			 @stack << v1 * v2 
		    when "/"
			 @stack << v1 / v2
		  end

		else
          raise BadToken, token.to_s
      end
	end

	return @stack.pop
  end

end
