import Foundation

class Parser {
    var commands = [String]()
    var pos = -1



    init(paths: [String]) {
        commands.append("bootstrap")
        paths.forEach {
            if let text = try? String(contentsOfFile: $0) {
                let array = text.components(separatedBy: "\n")
                for (_, data) in array.enumerated() {
                    let componentsByComments = data.components(separatedBy: "//")
                    guard componentsByComments.count > 0 else {
                        continue
                    }
                    let trim = componentsByComments[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    if trim == "" {
                        continue
                    }
                    commands.append(trim)
                }
            } else {
                print("no file path")
            }
        }
    }

    func hasMoreCommands() -> Bool {
        return pos + 1 < commands.count        
    }

    func advance() {
        pos += 1
    }

    private func commandDatas() -> (label: String, arg1: String?, arg2: Int?) {
         let command = commands[pos]
        let datas = command.components(separatedBy: " ")
        let label = datas[0]
        var arg1: String?
        var arg2: Int?

        if datas.count > 1 {
            arg1 = datas[1]
        }

        if datas.count > 2 {
            let data = datas[2]
            guard let num = Int(data) else {
                fatalError("fail to convert to num.")
            }
            arg2 = num
        }

        return (label: label, arg1: arg1, arg2: arg2)
    }

    func commandType() -> CommandType {
        let commandData = self.commandDatas()
        switch commandData.label {
        case "add", "sub", "neg", "eq", "gt", "lt", "and", "or","not":
            return .C_ARITHMETRIC
        case "push":
            return .C_PUSH
        case "pop":
            return .C_POP
        case "label":
            return .C_LABEL
        case "goto":
            return .C_GOTO
        case "if-goto":
            return .C_IF
        case "function":
            return .C_FUNCTION
        case "call":
            return .C_CALL
        case "return":
            return .C_RETURN
        case "bootstrap":
            return .C_BOOTSTRAP
        default:
            fatalError("(\(commandData.label)): unkown command error.")
        }
        
    }

    func label() -> String {
        return commandDatas().label
    }

    func arg1() -> String {
        guard let arg1 = commandDatas().arg1 else {
            fatalError("fail to convert arg1.")
        }
        return arg1
    }

    func arg2() -> Int {
        guard let arg2 = commandDatas().arg2 else {
            fatalError("fail to convert arg2.")
        }
        return arg2
    }
}