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
                  @\(numArgs + 5)
                  D=D-A
                  @ARG
                  M=D

                  @SP
                  D=M
                  @LCL
                  M=D

                  @\(functionName)
                  0;JMP
                  
                  (\(functionName)$return-address)
                  """
        return asm
    }

}