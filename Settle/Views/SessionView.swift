import Combine
import SwiftUI

struct SessionView: View {
    var exercises: [Exercise]
    var title: String

    @State private var index = 0
    @State private var remaining = 0
    @State private var running = true

    private let ink = SettleColor.ink

    var body: some View {
        let item = exercises[index]
        VStack(alignment: .leading, spacing: 16) {
            LoopingVideo(name: item.video)
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack {
                Text("\(index + 1) of \(exercises.count)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(ink.opacity(0.55))
                Spacer()
                Text(running ? "\(remaining)s" : "Paused")
                    .font(.subheadline.monospacedDigit().weight(.semibold))
                    .foregroundStyle(ink.opacity(0.55))
            }

            Text(item.name)
                .font(.title2.weight(.bold))
                .foregroundStyle(ink)
            Text(item.cue)
                .font(.body)
                .foregroundStyle(ink.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                Button("Back") { step(-1) }
                    .buttonStyle(.bordered)
                Button(running ? "Pause" : "Resume") { running.toggle() }
                    .buttonStyle(.borderedProminent)
                Button("Next") { step(1) }
                    .buttonStyle(.bordered)
            }
            .tint(ink)

            Spacer(minLength: 0)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(SettleColor.paper.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if remaining == 0 { remaining = item.seconds }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard running else { return }
            if remaining > 1 {
                remaining -= 1
            } else if index + 1 < exercises.count {
                step(1)
            } else {
                running = false
                remaining = 0
            }
        }
    }

    private func step(_ delta: Int) {
        let next = min(max(0, index + delta), exercises.count - 1)
        index = next
        remaining = exercises[next].seconds
        running = true
    }
}
