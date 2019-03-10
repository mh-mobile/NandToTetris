import Foundation

class ReturnCommand {

    init() {

    }

}

extension ReturnCommand: Command {

    func convert() -> String {
        let asm = """
                  // return
                  @SP
                  AM=M-1
                  D=M
                  @ARG
                  A=M
                  M=D
                  D=A
                  @SP
                  M=D+1
                  @LCL
                  D=M
                  @R13
                  M=D

                  @1
                  A=D-A
                  D=M
                  @THAT
                  M=D
                  @R13
                  D=M
                  @2
                  A=D-A
                  D=M
                  @THIS
                  M=D
                  @R13
                  D=M
                  @3
                  A=D-A
                  D=M
                  @ARG
                  M=D
                  @R13
                  D=M
                  @4
                  A=D-A
                  D=M
                  @LCL
                  M=D
                  @R13
                  D=M
                  @5
                  A=D-A
                  A=M
                  0;JMP
                  """
        return asm
    }

}