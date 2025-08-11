import RegexBuilder

class RegexBuilderSample {
    
    /// メールアドレス正規表現バリデーションチェック
    /// - Parameter text: メールアドレス
    /// - Returns: バリデーションチェック結果
    func isValidEmail(_ text: String) -> Bool {
        let local = Reference(Substring.self)
        let domain = Reference(Substring.self)

        let emailRegex = Regex {
            Capture(as: local) {
                OneOrMore(.word)
            }
            "@"
            Capture(as: domain) {
                OneOrMore(.word)
                "."
                OneOrMore(.word)
            }
        }

        guard let match = text.firstMatch(of: emailRegex) else {
            return false
        }

        // Debug
        print("User: \(match[local]), Domain: \(match[domain])")

        return true
    }
}

let regex = RegexBuilderSample()
let sampleEmail = "swift@example.com"
print(regex.isValidEmail(sampleEmail))
