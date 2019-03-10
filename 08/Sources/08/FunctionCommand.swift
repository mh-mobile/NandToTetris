import Foundation

class FunctionCommand {
    let functionName: String
    let numLocals: Int

    init(functionName: String, numLocals: Int) {
        self.functionName = functionName
        self.numLocals = numLocals
    }
}

extension FunctionCommand: Command {

    func convert() -> String {
        let asm = """
                  // function
                  (\(functionName))
                  @R13
                  M=0
                  (\(functionName)_INIT)
                  @R13
                  D=M
                  @\(numLocals)
                  D=D-A
                  @\(functionName)_INIT_START
                  D;JLT
                  @\(functionName)_INIT_END
                  0;JMP
                  (\(functionName)_INIT_START)
                  @0
                  D=A
                  @SP
                  A=M
                  M=D
                  @SP
                  M=M+1
                  @R13
                  M=M+1
                  @\(functionName)_INIT
                  0;JMP
                  (\(functionName)_INIT_END)
                  """
        return asm
    }

}