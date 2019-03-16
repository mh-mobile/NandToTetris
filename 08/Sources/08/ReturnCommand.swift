import Foundation

class ReturnCommand {

    init() {

    }

}

extension ReturnCommand: Command {

    func convert() -> String {
        let asm = """
                  // return

                  // copy the return address
                  @LCL
                  D=M
                  @5
                  A=D-A
                  D=M
                  @R14
                  M=D

                  @SP
                  M=M-1
                  A=M
                  D=M
                  @ARG
                  A=M
                  M=D

                  // SP
                  @ARG
                  D=M+1
                  @SP
                  M=D

                  // THAT (LCL - 1)
                  @LCL
                  D=M
                  @1
                  A=D-A
                  D=M
                  @THAT
                  M=D

                  // THIS (LCL - 2)
                  @LCL
                  D=M
                  @2
                  A=D-A
                  D=M
                  @THIS
                  M=D

                  // ARG (LCL - 3)
                  @LCL
                  D=M
                  @3
                  A=D-A
                  D=M
                  @ARG
                  M=D

                  // LCL (LCL - 4)
                  @LCL
                  D=M
                  @4
                  A=D-A
                  D=M
                  @LCL
                  M=D

                  @R14 
                  A=M
                  0;JMP
                  """

        return asm
    }

}