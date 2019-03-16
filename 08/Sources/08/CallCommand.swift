import Foundation

class CallCommand {

    public static var returnIndex: Int = 0

    let functionName: String
    let numArgs: Int

    init(functionName: String, numArgs: Int) {
        self.functionName = functionName
        self.numArgs = numArgs
    }
}

extension CallCommand: Command {
    func convert() -> String {

        CallCommand.returnIndex += 1
        let returnAddress: String = "\(functionName)$return-address\(CallCommand.returnIndex)"

        let asm = """
                  // call
                  @\(returnAddress)
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
                  
                  (\(returnAddress))
                  """
        return asm
    }

}