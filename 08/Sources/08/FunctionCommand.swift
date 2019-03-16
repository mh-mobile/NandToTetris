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

        var lines = [String]()
        for i in 0..<numLocals {
           let line = """
                      @SP
                      A=M
                      M=0
                      @SP
                      M=M+1
                      """
            lines.append(line)
        }

        let localAsm = lines.count == 0 ? "" : lines.joined(separator: "\n")

        let asm = """
                  // function
                  (\(functionName))
                  \(localAsm)
                  """
        return asm
    }

}