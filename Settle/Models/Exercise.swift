import Foundation

enum Avatar: String, CaseIterable, Identifiable {
    case female
    case male

    var id: String { rawValue }
    var title: String { self == .female ? "Female" : "Male" }
    var suffix: String { self == .female ? "f" : "m" }
}

enum Module: String, CaseIterable, Identifiable, Hashable {
    case flight = "Flight"
    case bed = "In bed"
    case desk = "Desk"
    case hotel = "Hotel room"
    case wakeup = "Wake up"

    var id: String { rawValue }

    var minutes: Int {
        let seconds = Library.session(self).reduce(0) { $0 + $1.seconds }
        return max(1, Int((Double(seconds) / 60).rounded()))
    }

    var blurb: String {
        switch self {
        case .flight: return "Seat only. Nothing that needs the aisle."
        case .bed: return "Lying down. Nothing that needs the floor."
        case .desk: return "Stay in the chair. Neck, shoulders, wrists, and a small hip shift."
        case .hotel: return "A wall, a bit of floor, and the bed. Nothing that needs a gym."
        case .wakeup: return "The first minutes before you get up. Still lying down."
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

enum Muscle: String, CaseIterable, Identifiable, Hashable {
    case neck = "Neck"
    case upperTraps = "Upper traps"
    case delts = "Shoulders"
    case pecs = "Chest"
    case midBack = "Mid back"
    case erectors = "Low back"
    case abs = "Abs"
    case obliques = "Obliques"
    case hipFlexors = "Hip flexors"
    case glutes = "Glutes"
    case deepHip = "Deep hip"
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case calves = "Calves"
    case shins = "Shins"
    case wrists = "Wrists"
    case forearms = "Forearms"
    case diaphragm = "Breathing"

    var id: String { rawValue }
}

struct BodyZone: Identifiable, Hashable {
    var id: String
    var name: String
    var back: Bool
    var muscles: [Muscle]

    static let all: [BodyZone] = [
        BodyZone(id: "front-neck", name: "Neck", back: false, muscles: [.neck]),
        BodyZone(id: "front-shoulders", name: "Shoulders", back: false, muscles: [.delts, .pecs]),
        BodyZone(id: "front-chest", name: "Chest", back: false, muscles: [.pecs]),
        BodyZone(id: "front-core", name: "Core", back: false, muscles: [.abs, .obliques, .diaphragm]),
        BodyZone(id: "front-hips", name: "Hips", back: false, muscles: [.hipFlexors]),
        BodyZone(id: "front-thighs", name: "Thighs", back: false, muscles: [.quads]),
        BodyZone(id: "front-calves", name: "Calves", back: false, muscles: [.calves, .shins]),
        BodyZone(id: "front-hands", name: "Wrists", back: false, muscles: [.wrists, .forearms]),
        BodyZone(id: "back-neck", name: "Neck", back: true, muscles: [.neck, .upperTraps]),
        BodyZone(id: "back-upper", name: "Upper back", back: true, muscles: [.upperTraps, .midBack]),
        BodyZone(id: "back-low", name: "Low back", back: true, muscles: [.erectors]),
        BodyZone(id: "back-glutes", name: "Glutes", back: true, muscles: [.glutes, .deepHip]),
        BodyZone(id: "back-hams", name: "Hamstrings", back: true, muscles: [.hamstrings]),
        BodyZone(id: "back-calves", name: "Calves", back: true, muscles: [.calves]),
    ]
}

struct Exercise: Identifiable, Hashable {
    var id: String
    var name: String
    var area: Area
    var seconds: Int
    var cue: String
    var steps: [String]
    var video: String
    var muscles: [Muscle]

    func clip(_ avatar: Avatar) -> String { "\(video)-\(avatar.suffix)" }

    var modules: [Module] {
        Module.allCases.filter { Library.playlists[$0, default: []].contains(id) }
    }

    var muscleLine: String {
        muscles.map(\.rawValue).joined(separator: ", ")
    }
}

enum Library {
    static let playlists: [Module: [String]] = [
        .flight: [
            "ankle-circles", "foot-pumps", "seat-march", "hip-shift", "seat-figure-4",
            "seat-turn", "neck-turns", "shoulder-circles", "chest-open", "wrist-circles",
        ],
        .bed: [
            "pelvic-rock", "knee-chest", "supine-twist", "bed-figure-4", "windshield",
            "open-book", "side-knee", "heel-slide", "ankle-alphabet", "bent-knee-breath",
        ],
        .desk: [
            "neck-turns", "shoulder-circles", "chest-open", "wrist-circles",
            "hip-shift", "seat-turn", "ankle-circles", "seat-march",
        ],
        .hotel: [
            "wall-chest", "wall-calf", "stand-hip", "thread-needle", "knee-chest", "windshield",
        ],
        .wakeup: [
            "pelvic-rock", "knee-chest", "supine-twist", "heel-slide", "ankle-alphabet", "bent-knee-breath",
        ],
    ]

    static let all: [Exercise] = [
        move("ankle-circles", "Ankle circles", .ankles, 40,
             "Slow circles with one foot, then the other.",
             ["Keep the heel down if the seat is tight.", "Small circles. Then the other way.", "Switch feet."],
             [.calves, .shins],
             [.flight, .desk]),
        move("foot-pumps", "Foot pumps", .ankles, 40,
             "Point the toes, then pull them back.",
             ["Heels can stay on the floor.", "A steady pump, not a stretch you force.", "Both feet, or one at a time."],
             [.calves, .shins],
             [.flight]),
        move("seat-march", "Seat march", .hips, 40,
             "Lift one knee a little, then the other.",
             ["Sit tall. Hands can rest on the armrests.", "Lift one knee only as high as the seat in front allows.", "Switch. Skip it if the row is tight."],
             [.hipFlexors, .quads],
             [.flight, .desk]),
        move("hip-shift", "Hip shift", .hips, 40,
             "Shift your weight from one sitting bone to the other.",
             ["Shoulders stay quiet.", "A small shift is enough.", "Stop if the low back pinches."],
             [.glutes, .erectors],
             [.flight, .desk]),
        move("seat-figure-4", "Seated figure-4", .hips, 40,
             "Ankle on the opposite knee, only if the seat allows.",
             ["Sit tall. Rest the ankle on the other knee.", "A small lean is optional. Do not force the knee down.", "Switch sides. Skip it if the hip pinches."],
             [.glutes, .deepHip],
             [.flight]),
        move("seat-turn", "Seated turn", .back, 40,
             "Turn the chest a little. Keep the turn small.",
             ["One hand on the opposite knee.", "Turn only as far as the seatbelt allows.", "Come back, then the other way. Stop if the low back pinches."],
             [.obliques, .erectors],
             [.flight, .desk]),
        move("neck-turns", "Neck turns", .neck, 40,
             "Look slowly left, then right.",
             ["Chin stays level.", "Stop before the end of the range.", "A small nod up and down is fine after the turns."],
             [.neck],
             [.flight, .desk]),
        move("shoulder-circles", "Shoulder circles", .shoulders, 40,
             "Roll both shoulders up, back, and down.",
             ["Slow circles.", "Then the other direction.", "Jaw stays soft."],
             [.upperTraps, .delts],
             [.flight, .desk]),
        move("chest-open", "Chest open", .shoulders, 40,
             "Hands on the seat behind you. Lift the chest a little.",
             ["Only if the seat back allows your hands behind you.", "A small lift. Do not crank the low back.", "Breathe, then release."],
             [.pecs, .delts],
             [.flight, .desk]),
        move("wrist-circles", "Wrist circles", .wrists, 40,
             "Circle the wrists one way, then the other.",
             ["Elbows can stay bent.", "Open and close the hands once at the end."],
             [.wrists, .forearms],
             [.flight, .desk]),
        move("pelvic-rock", "Pelvic rock", .back, 45,
             "Knees bent. Gently flatten the low back, then release.",
             ["Feet on the mattress.", "A small tilt. You are not tucking hard.", "Stop if the low back pinches."],
             [.erectors, .abs],
             [.bed, .wakeup]),
        move("knee-chest", "Knee to chest", .hips, 45,
             "Draw one knee in. Hold behind the thigh, not the knee.",
             ["The other foot stays down.", "Small range. Switch sides.", "Stop if the hip or low back pinches."],
             [.glutes, .hipFlexors, .erectors],
             [.bed, .hotel, .wakeup]),
        move("supine-twist", "Knees to the side", .back, 45,
             "Knees together, drop them a little to one side.",
             ["Shoulders stay heavy.", "Only as far as the low back stays quiet.", "Switch sides."],
             [.obliques, .erectors],
             [.bed, .wakeup]),
        move("bed-figure-4", "Figure-4 on your back", .hips, 45,
             "Ankle across the opposite knee. Easy range.",
             ["Both feet start bent.", "Do not pull the knee down.", "Switch. Skip the side that pinches."],
             [.glutes, .deepHip],
             [.bed]),
        move("windshield", "Windshield wipers", .hips, 45,
             "Knees bent, sway them slowly side to side.",
             ["Feet a little wider than the hips.", "Small sway. The back stays supported.", "Stop if either hip pinches."],
             [.hipFlexors, .glutes, .obliques],
             [.bed, .hotel]),
        move("open-book", "Open book", .back, 45,
             "On your side. Open the top arm slowly.",
             ["Knees bent, stacked or nearly stacked.", "Follow the hand with your eyes if that feels fine.", "A small open is enough. Then the other side."],
             [.pecs, .midBack, .obliques],
             [.bed]),
        move("side-knee", "Side knee to chest", .hips, 45,
             "On your side, draw the top knee toward the chest.",
             ["Bottom leg stays long or slightly bent.", "Hold behind the thigh.", "Switch sides. Skip a pinch."],
             [.hipFlexors, .glutes],
             [.bed]),
        move("heel-slide", "Heel slide", .hips, 45,
             "Slide one heel away, then back.",
             ["Start with the knee bent.", "The heel stays on the mattress.", "Switch legs."],
             [.quads, .hipFlexors, .hamstrings],
             [.bed, .wakeup]),
        move("ankle-alphabet", "Ankle alphabet", .ankles, 45,
             "Write small letters in the air with one foot.",
             ["Leg can stay bent or rest long.", "Small letters. Then the other foot."],
             [.calves, .shins],
             [.bed, .wakeup]),
        move("bent-knee-breath", "Bent-knee breath", .breath, 45,
             "Knees bent. Let the ribs widen as you breathe.",
             ["Hands on the ribs or the belly.", "Quiet breaths. Nothing to force.", "This closes the session."],
             [.diaphragm, .abs],
             [.bed, .wakeup]),
        move("wall-chest", "Wall chest open", .shoulders, 40,
             "Hands on the wall. Step one foot back a little and let the chest move forward.",
             ["The lean is small. Do not dump into the low back.", "Breathe, then step back in.", "Stop if the low back pinches."],
             [.pecs, .delts],
             [.hotel]),
        move("wall-calf", "Wall calf", .ankles, 40,
             "Back heel stays down. A small lean toward the wall.",
             ["Front knee stays soft.", "You should feel the back calf, not the low back.", "Switch sides."],
             [.calves],
             [.hotel]),
        move("stand-hip", "Standing hip circle", .hips, 40,
             "Stand tall. Draw a small circle with one hip.",
             ["Hold the wall if you want.", "A small circle. Then the other way.", "Stop if the hip or low back pinches. Switch sides."],
             [.glutes, .hipFlexors],
             [.hotel]),
        move("thread-needle", "Thread the needle", .back, 40,
             "On hands and knees, slide one arm under the body.",
             ["The other hand can stay on the floor.", "Only as far as the shoulder is comfortable.", "Switch sides. Skip it if the low back pinches."],
             [.midBack, .delts, .obliques],
             [.hotel]),
    ]

    static func session(_ module: Module) -> [Exercise] {
        let byID = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
        return playlists[module, default: []].compactMap { byID[$0] }
    }

    static func matching(_ muscle: Muscle) -> [Exercise] {
        all.filter { $0.muscles.contains(muscle) }
    }

    private static func move(
        _ id: String,
        _ name: String,
        _ area: Area,
        _ seconds: Int,
        _ cue: String,
        _ steps: [String],
        _ muscles: [Muscle],
        _ modules: [Module]
    ) -> Exercise {
        let listed = modules.sorted { $0.rawValue < $1.rawValue }.map(\.rawValue)
        let fromPlaylists = Module.allCases.filter { playlists[$0, default: []].contains(id) }.map(\.rawValue).sorted()
        assert(listed == fromPlaylists, "Playlist mismatch for \(id)")
        return Exercise(
            id: id, name: name, area: area, seconds: seconds,
            cue: cue, steps: steps, video: id, muscles: muscles
        )
    }
}
