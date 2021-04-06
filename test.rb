require './calculator.rb'


def run_lexer(lexer)
  token = lexer.next
  while token.kind != "end"
    print token, "\t"
  	token = lexer.next
  end
  print "\n"
end

def lexer
  puts "LEXER TEST"
  puts "=========="
  my_lexer = Lexer.new
  
  begin
    my_lexer.line = "  1+399 * (4 + 7.5 -	3)	"
    run_lexer my_lexer
  rescue Exception => e
    puts e.inspect
  end
  puts "----------"

  begin
    my_lexer.line = "1 + 2 + 3 + 4"
    run_lexer my_lexer
  rescue Exception => e
    puts e.inspect
  end
  puts "----------"

  begin
    my_lexer.line = ""
    run_lexer my_lexer
  rescue Exception => e
    puts e.inspect
  end
  puts "----------"

  begin
    my_lexer.line = "abcde"
    run_lexer my_lexer
  rescue Exception => e
    puts e.inspect
  end
  puts "----------"

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
  puts "PARSER TEST"
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

lexer
token_equals
parser_match
