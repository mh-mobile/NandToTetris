enum CommandPushPopType {
    case push
    case pop
}

enum CommandType {
    case C_ARITHMETRIC
    case C_PUSH
    case C_POP
    case C_LABEL
    case C_GOTO
    case C_IF
    case C_FUNCTION
    case C_RETURN
    case C_CALL
}

enum CommandArithmeticType: String {
    case add
    case sub
    case neg
    case eq 
    case gt
    case lt 
    case and
    case or 
    case not
}
