import Foundation

class CallCommand {
    let functionName: String
    let numArgs: Int

    init(functionName: String, numArgs: Int) {
        self.functionName = functionName
        self.numArgs = numArgs
    }
}

extension CallCommand: Command {

    func convert() -> String {
        let asm = """
                  // call
                  @\(functionName)$return-address
                  D=A
                  @SP
                  A=M
                  M=D
                  @SP
                  M=M+1

                  @LCL
                  D=M
                  @SP
                  A=M
                  M=D
                  @SP
                  M=M+1

                  @ARG
                  D=M
                  @SP
                  A=M
                  M=D
                  @SP
                  M=M+1

                  @THIS
                  D=M
                  @SP
                  A=M
                  M=D
                  @SP
                  M=M+1

                  @THAT
                  D=M
                  @SP
                  A=M
                  M=D
                  @SP
                  M=M+1

                  @SP
                  D=M
                  @LCL
                  M=D

                  @5
                  D=A
                  @LCL
                  D=M-D
                  @R13
                  M=D
                  @\(numArgs)
                  D=A
                  @R13
                  D=M-D
                  @ARG
                  M=D

                  @\(functionName)
                  0;JMP
                  
                  (\(functionName)$return-address)
                  """
        return asm
    }

}