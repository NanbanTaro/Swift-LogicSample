@MainActor
class NumberMonitor {
    var handler: ((Int) -> Void)?
    var counter = 0
    
    /// モニタリング開始
    func start() {
        // 擬似通知
        Task {
            countPlus1()
            try await Task.sleep(for: .seconds(1))
            countPlus1()
            try await Task.sleep(for: .seconds(2))
            countPlus1()
        }
    }
    
    /// モニタリング停止
    nonisolated func stop() {
        // 停止処理
    }
    
    /// カウント+1
    private func countPlus1() {
        counter += 1
        handler?(counter)
   }
}

@MainActor
class NumberStream {
    private let monitor = NumberMonitor()
    private var continuation: AsyncStream<Int>.Continuation?
    
    /// ストリーム開始
    /// - Returns: ストリーム
    func numberStream() -> AsyncStream<Int> {
        AsyncStream { continuation in
            self.continuation = continuation

            monitor.handler = { value in
                continuation.yield(value)
            }

            continuation.onTermination = { _ in
                self.monitor.stop()
            }

            monitor.start()
        }
    }
    
    /// 処理停止
    func stop() {
        continuation?.finish()
    }
}

// メイン処理

let stream = NumberStream()

Task {
    for await number in stream.numberStream() {
        print("value: \(number)")

        if number == 3 {
            stream.stop()
        }
    }
    print("Stream Finished")
}
