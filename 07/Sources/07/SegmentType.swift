enum SegmentType: String {

    var symbol: String {
        switch self {
            case .constant:
                return ""
            case .pointer:
                return ""
            case .temp:
                return ""
            case .local:
                return "LCL"
            case .argument:
                return "ARG"
            case .this:
                return "THIS"
            case .that:
                return "THAT"
            case .s_static:
                return ""
        }
    }

    case constant
    case pointer
    case temp
    case local
    case argument
    case this
    case that
    case s_static
}