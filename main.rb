require "./calculator.rb"

lexer = Lexer.new
parser = Parser.new
stack = StackMachine.new

while true
  begin
    line = gets.chomp
    lexer.line = line
    parser.tokens = lexer.run
	result = stack.run(parser.parse)
	puts "§ " + result.to_s
  rescue Interrupt
    exit
  rescue Exception => e
    puts "An error ocurred:"
	puts e.inspect
	exit 1
  end
end
