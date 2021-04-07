require './calculator.rb'


def lexer_run
  puts "LEXER RUN TEST"
  puts "=============="
  lexer = Lexer.new
  lexer.line = "2 + 2 - 3"
  puts lexer.run
  puts "-----"
  lexer.line = ""
  puts lexer.run
  puts "-----"
  lexer.line = "(2+     ) 3.14 -"
  puts lexer.run
  puts "-----"
  begin
    lexer.line = "abcde"
    puts lexer.run
  rescue Exception => e
    puts e.inspect
  end
  puts "-----"
  puts
end


def token_equals
  puts "TOKEN TEST"
  puts "=========="
  a = Token.new("aaa", "kindA")
  a2 = Token.new("aaa", "kindA")
  b = Token.new("aaa", "kindB")
  c = Token.new("ccc", "kindA")
  puts a.to_s + " == " + a2.to_s + " : " + ( a == a2 ).to_s
  puts a.to_s + " == " + b.to_s + " : " + ( a == b ).to_s
  puts a.to_s + " == " + c.to_s + " : " + ( a == c ).to_s

  puts
end


def parser_match
  puts "PARSER MATCH TEST"
  puts "==========="

  parser = Parser.new
  parser.tokens = [Token.new("first", "kindA"), Token.new("second", "kindB")]
  
  begin
    parser.match("kindA")
    puts "Case 1 ok..."
	parser.match("kindX")
	puts "Case 2 was suppposed to raise an error!"
  rescue Parser::BadToken => e
    puts e.inspect
    puts "Case 2 ok..."
  end
  puts
end


def parser_translate
  puts "PARSER TRANSLATE TEST"
  puts "====================="
  
  lexer = Lexer.new
  parser = Parser.new

  test = "2+2-3"
  lexer.line = test
  parser.tokens = lexer.run
  puts test + " becomes:"
  print parser.parse, "\n"
  puts "-----"

  test = "(2)   -4 * (1 + 3)"
  lexer.line = test
  parser.tokens = lexer.run
  puts test + " becomes:"
  print parser.parse, "\n"
  puts "-----"

  test = ""
  lexer.line = test
  parser.tokens = lexer.run
  puts "using an empty input:"
  begin
    print parser.parse, "\n"
  rescue Parser::BadToken => e
    puts e.inspect
  end
  puts "-----"

  test = "1 2 3"
  lexer.line = test
  parser.tokens = lexer.run
  puts test + " becomes:"
  begin
    print parser.parse, "\n"
  rescue Parser::BadToken => e
    puts e.inspect
  end
  puts "-----"

  puts

end

def stack_run

  puts "STACK RUN TEST"
  puts "=============="

  lex = Lexer.new
  par = Parser.new
  stk = StackMachine.new

  test = "2 + 2"
  puts test
  lex.line = test
  par.tokens = lex.run
  polish = par.parse
  puts "The result is: " + stk.run(polish).to_s
  puts "-----"

  test = "2 * (9-6)"
  puts test
  lex.line = test
  par.tokens = lex.run
  polish = par.parse
  puts "The result is: " + stk.run(polish).to_s
  puts "-----"

  test = "3.141592 * 3.141592"
  puts test
  lex.line = test
  par.tokens = lex.run
  polish = par.parse
  puts "The result is: " + stk.run(polish).to_s
  puts "-----"

  begin
    test = "abcde"
	puts test
	lex.line = test
	par.tokens = lex.run
	polish = par.parse
	puts "The result is: " + stk.run(polish).to_s
  rescue Exception => e
    puts e.inspect
  end
  puts "-----"

  begin
    test = ""
	puts test
	lex.line = test
	par.tokens = lex.run
	polish = par.parse
	puts "The result is: " + stk.run(polish).to_s
  rescue Exception => e
    puts e.inspect
  end
  puts "-----"

  begin
    test = "2 + 2 /"
	puts test
	lex.line = test
	par.tokens = lex.run
	polish = par.parse
	puts "The result is: " + stk.run(polish).to_s
  rescue Exception => e
    puts e.inspect
  end
  puts "-----"

  begin
    test = "1 2 3"
	puts test
	lex.line = test
	par.tokens = lex.run
	polish = par.parse
	puts "The result is: " + stk.run(polish).to_s
  rescue Exception => e
    puts e.inspect
  end
  puts "-----"

  puts
end

lexer_run
token_equals
parser_match
parser_translate
stack_run
