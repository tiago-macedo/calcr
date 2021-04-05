require './calculator.rb'


def run_lexer(lexer)
  token = lexer.next
  while token.kind != "end"
    print token.lexeme, "(", token.kind, ") "
  	token = lexer.next
  end
  print "\n"
end

def lexer_test
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

end

lexer_test
