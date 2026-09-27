import Foundation

enum Place: String, CaseIterable, Identifiable {
    case flight = "Flight"
    case bed = "In bed"

    var id: String { rawValue }

    var minutes: Int { self == .flight ? 7 : 8 }

    var blurb: String {
        switch self {
        case .flight: return "Seat only. Nothing that needs the aisle."
        case .bed: return "Lying down. Nothing that needs the floor."
        }
    }
}

enum Area: String, CaseIterable, Identifiable {
    case ankles = "Ankles"
    case hips = "Hips"
    case back = "Back"
    case shoulders = "Shoulders"
    case neck = "Neck"
    case wrists = "Wrists"
    case breath = "Breath"

    var id: String { rawValue }
}

struct Exercise: Identifiable, Hashable {
    var id: String
    var name: String
    var place: Place
    var area: Area
    var seconds: Int
    var cue: String
    var steps: [String]
    var video: String
}

enum Library {
    static let all: [Exercise] = flight + bed

    static let flight: [Exercise] = [
        Exercise(
            id: "ankle-circles",
            name: "Ankle circles",
            place: .flight,
            area: .ankles,
            seconds: 40,
            cue: "Draw a slow circle with one foot. Then the other.",
            steps: [
                "Keep the heel lightly down, or let it hover.",
                "Circle one way, then reverse.",
                "The other foot does the same."
            ],
            video: "ankle-circles"
        ),
        Exercise(
            id: "foot-pumps",
            name: "Foot pumps",
            place: .flight,
            area: .ankles,
            seconds: 40,
            cue: "Toes up, then toes down. Both feet.",
            steps: [
                "Pull the toes toward you.",
                "Point them away.",
                "Keep it smooth. This is the calf pump for a long sit."
            ],
            video: "foot-pumps"
        ),
        Exercise(
            id: "seat-march",
            name: "Seat march",
            place: .flight,
            area: .hips,
            seconds: 40,
            cue: "Lift one knee a little, then the other.",
            steps: [
                "Sit tall. Hands can rest on the armrests.",
                "Lift one knee only as high as the seat in front allows.",
                "Switch. Skip it if the row is tight."
            ],
            video: "seat-march"
        ),
        Exercise(
            id: "hip-shift",
            name: "Hip shift",
            place: .flight,
            area: .hips,
            seconds: 40,
            cue: "Shift your weight from one sitting bone to the other.",
            steps: [
                "Shoulders stay quiet.",
                "A small shift is enough.",
                "Stop if the low back pinches."
            ],
            video: "hip-shift"
        ),
        Exercise(
            id: "seat-figure-4",
            name: "Seated figure-4",
            place: .flight,
            area: .hips,
            seconds: 40,
            cue: "Ankle on the opposite knee, only if the seat allows.",
            steps: [
                "Sit tall. Rest the ankle on the other knee.",
                "A small lean is optional. Do not force the knee down.",
                "Switch sides. Skip it if the hip pinches."
            ],
            video: "seat-figure-4"
        ),
        Exercise(
            id: "seat-turn",
            name: "Seated turn",
            place: .flight,
            area: .back,
            seconds: 40,
            cue: "Turn the chest a little. Keep the turn small.",
            steps: [
                "One hand on the opposite knee.",
                "Turn only as far as the seatbelt allows.",
                "Come back, then the other way. Stop if the low back pinches."
            ],
            video: "seat-turn"
        ),
        Exercise(
            id: "neck-turns",
            name: "Neck turns",
            place: .flight,
            area: .neck,
            seconds: 40,
            cue: "Look slowly left, then right.",
            steps: [
                "Chin stays level.",
                "Stop before the end of the range.",
                "A small nod up and down is fine after the turns."
            ],
            video: "neck-turns"
        ),
        Exercise(
            id: "shoulder-circles",
            name: "Shoulder circles",
            place: .flight,
            area: .shoulders,
            seconds: 40,
            cue: "Roll both shoulders up, back, and down.",
            steps: [
                "Slow circles.",
                "Then the other direction.",
                "Jaw stays soft."
            ],
            video: "shoulder-circles"
        ),
        Exercise(
            id: "chest-open",
            name: "Chest open",
            place: .flight,
            area: .shoulders,
            seconds: 40,
            cue: "Hands on the seat behind you. Lift the chest a little.",
            steps: [
                "Only if the seat back allows your hands behind you.",
                "A small lift. Do not crank the low back.",
                "Breathe, then release."
            ],
            video: "chest-open"
        ),
        Exercise(
            id: "wrist-circles",
            name: "Wrist circles",
            place: .flight,
            area: .wrists,
            seconds: 40,
            cue: "Circle the wrists one way, then the other.",
            steps: [
                "Elbows can stay bent.",
                "Open and close the hands once at the end."
            ],
            video: "wrist-circles"
        ),
    ]

    static let bed: [Exercise] = [
        Exercise(
            id: "pelvic-rock",
            name: "Pelvic rock",
            place: .bed,
            area: .back,
            seconds: 45,
            cue: "Knees bent. Gently flatten the low back, then release.",
            steps: [
                "Feet on the mattress.",
                "A small tilt. You are not tucking hard.",
                "Stop if the low back pinches."
            ],
            video: "pelvic-rock"
        ),
        Exercise(
            id: "knee-chest",
            name: "Knee to chest",
            place: .bed,
            area: .hips,
            seconds: 45,
            cue: "Draw one knee in. Hold behind the thigh, not the knee.",
            steps: [
                "The other foot stays down.",
                "Small range. Switch sides.",
                "Stop if the hip or low back pinches."
            ],
            video: "knee-chest"
        ),
        Exercise(
            id: "supine-twist",
            name: "Knees to the side",
            place: .bed,
            area: .back,
            seconds: 45,
            cue: "Knees together, drop them a little to one side.",
            steps: [
                "Shoulders stay heavy.",
                "Only as far as the low back stays quiet.",
                "Switch sides."
            ],
            video: "supine-twist"
        ),
        Exercise(
            id: "bed-figure-4",
            name: "Figure-4 on your back",
            place: .bed,
            area: .hips,
            seconds: 45,
            cue: "Ankle across the opposite knee. Easy range.",
            steps: [
                "Both feet start bent.",
                "Do not pull the knee down.",
                "Switch. Skip the side that pinches."
            ],
            video: "bed-figure-4"
        ),
        Exercise(
            id: "windshield",
            name: "Windshield wipers",
            place: .bed,
            area: .hips,
            seconds: 45,
            cue: "Knees bent, sway them slowly side to side.",
            steps: [
                "Feet a little wider than the hips.",
                "Small sway. The back stays supported.",
                "Stop if either hip pinches."
            ],
            video: "windshield"
        ),
        Exercise(
            id: "open-book",
            name: "Open book",
            place: .bed,
            area: .back,
            seconds: 45,
            cue: "On your side. Open the top arm slowly.",
            steps: [
                "Knees bent, stacked or nearly stacked.",
                "Follow the hand with your eyes if that feels fine.",
                "A small open is enough. Then the other side."
            ],
            video: "open-book"
        ),
        Exercise(
            id: "side-knee",
            name: "Side knee to chest",
            place: .bed,
            area: .hips,
            seconds: 45,
            cue: "On your side, draw the top knee toward the chest.",
            steps: [
                "Bottom leg stays long or slightly bent.",
                "Hold behind the thigh.",
                "Switch sides. Skip a pinch."
            ],
            video: "side-knee"
        ),
        Exercise(
            id: "heel-slide",
            name: "Heel slide",
            place: .bed,
            area: .hips,
            seconds: 45,
            cue: "Slide one heel away, then back.",
            steps: [
                "Start with the knee bent.",
                "The heel stays on the mattress.",
                "Switch legs."
            ],
            video: "heel-slide"
        ),
        Exercise(
            id: "ankle-alphabet",
            name: "Ankle alphabet",
            place: .bed,
            area: .ankles,
            seconds: 45,
            cue: "Write small letters in the air with one foot.",
            steps: [
                "Leg can stay bent or rest long.",
                "Small letters. Then the other foot."
            ],
            video: "ankle-alphabet"
        ),
        Exercise(
            id: "bent-knee-breath",
            name: "Bent-knee breath",
            place: .bed,
            area: .breath,
            seconds: 45,
            cue: "Knees bent. Let the ribs widen as you breathe.",
            steps: [
                "Hands on the ribs or the belly.",
                "Quiet breaths. Nothing to force.",
                "This closes the session."
            ],
            video: "bent-knee-breath"
        ),
    ]

    static func session(_ place: Place) -> [Exercise] {
        all.filter { $0.place == place }
    }
}
