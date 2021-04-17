# calcr

General calculator implementation in Ruby.

This was coded so I could learn Ruby, do not expect it to be functional/good/maintainable.

The idea is that it could parse expressions given by the user, printing the evaluated value.

## TODO

- [x] Lexer
  - [x] Something that identifies numbers and basic arithmetic operators and spits out tokens
  - [x] Lexer errors
- [x] Parser
- [x] Stack machine
- [x] Main loop with lexer, parser and stack machine
  - [ ] Ability to move cursor left and right
  - [ ] Arrow up/down moves through list of previous input lines
    - [ ] Save input lines
- [ ] The lesser known operators: '^' and '%'
- [ ] Scientific notation
