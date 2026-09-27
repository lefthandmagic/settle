import AVKit
import SwiftUI

struct LoopingVideo: UIViewControllerRepresentable {
    var name: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspect
        controller.view.backgroundColor = UIColor(red: 0.961, green: 0.941, blue: 0.902, alpha: 1)
        play(name, on: controller, context: context)
        return controller
    }

    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        guard context.coordinator.name != name else { return }
        play(name, on: controller, context: context)
    }

    private func play(_ name: String, on controller: AVPlayerViewController, context: Context) {
        context.coordinator.name = name
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp4") else {
            controller.player = nil
            return
        }
        let item = AVPlayerItem(url: url)
        let queue = AVQueuePlayer()
        queue.isMuted = true
        context.coordinator.looper = AVPlayerLooper(player: queue, templateItem: item)
        controller.player = queue
        queue.play()
    }

    final class Coordinator {
        var looper: AVPlayerLooper?
        var name: String?
    }
}
