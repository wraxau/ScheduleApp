import UIKit

enum ClassType: String {
    case lecture = "лекция"
    case seminar = "семинар"
    case practice = "практика"
    
    var color: UIColor {
        switch self {
        case .lecture:
            return UIColor(red: 0.0, green: 192.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        case .seminar:
            return UIColor(red: 0.0, green: 200.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        case .practice:
            return UIColor(red: 1.0, green: 141.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        }
    }
}

struct ScheduleItem {
    let number: Int
    let type: ClassType
    let startTime: String
    let endTime: String
    let subject: String
    let teacher: String
    let room: String // "онлайн" или "ауд. XXX"
    let breakAfter: String? // например, "перерыв 15 минут"
    let breakEndTime: String?
    let isReplacement: Bool
    
    // для детальной информации о занятии
    let topic: String?
    let description: String?
    let meetingLink: String?
    let meetingServiceName: String?
    let buildingInfo: String?
    let isCancelled: Bool
    let materials: [Material]?
    let tasks: String?
}

struct DaySchedule {
    let date: Date
    let items: [ScheduleItem]
    let isWeekend: Bool
}

struct Material {
    let name: String?
    let link: String?
    let size: String?
    let type: String?
}

// чтобы можно было загрузить файл с заданием
struct AttachedFile {
    let name: String
    let size: String
    let type: String // "jpg", "pdf" и т.д.
}
