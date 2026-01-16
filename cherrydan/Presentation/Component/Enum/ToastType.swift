import Foundation

enum ToastType {
    case error(Error)
    case errorWithTaskName(String)
    case errorWithMessage(String)
    case success(String, ButtonConfig?)

    var text: LocalizedStringResource {
        switch self {
        case .error(let error):
            if let apiError = error as? APIError {
                LocalizedStringResource(stringLiteral: apiError.localizedDescription)
            } else {
                LocalizedStringResource(stringLiteral: error.localizedDescription)
            }
        case .errorWithTaskName(let task):
            "일시적인 오류로 \(task)에 실패했어요. 잠시 후 다시 시도해 주세요."
        case .errorWithMessage(let message):
            LocalizedStringResource(stringLiteral: message)
        case .success(let message,_):
            LocalizedStringResource(stringLiteral: message)
        }
    }
}
