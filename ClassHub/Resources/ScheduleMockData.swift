import Foundation

enum ScheduleMockData {
    static func generateSampleSchedule() -> [Date: DaySchedule] {
        let calendar = Calendar.current
        let today = Date()
        
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else {
            return [:]
        }
        
        let startOfToday = calendar.startOfDay(for: today)
        let startOfTomorrow = calendar.startOfDay(for: tomorrow)
        let todayItems: [ScheduleItem] = [
            ScheduleItem(
                number: 1,
                type: .lecture,
                startTime: "10:00",
                endTime: "11:45",
                subject: "Международное право",
                teacher: "Иванов Иван Иванович",
                room: "Онлайн",
                breakAfter: "Перерыв 15 мин",
                breakEndTime: "12.00",
                isReplacement: false
            ),
            ScheduleItem(
                number: 2,
                type: .seminar,
                startTime: "12:00",
                endTime: "13:45",
                subject: "Государственное регулирование конституционной деятельности",
                teacher: "Михайлов Иван Дмитриевич",
                room: "405",
                breakAfter: "Перерыв 1.15 мин",
                breakEndTime: "15.00",
                isReplacement: true
            ),
            ScheduleItem(
                number: 3,
                type: .lecture,
                startTime: "15:00",
                endTime: "16:45",
                subject: "Теория вероятностей",
                teacher: "Смирнов Алексей Иванович",
                room: "12б",
                breakAfter: nil,
                breakEndTime: nil,
                isReplacement: false
            ),
            
            ScheduleItem(
                number: 3,
                type: .lecture,
                startTime: "16:45",
                endTime: "18:15",
                subject: "Архитектура ОС",
                teacher: "Смирнов Алексей Иванович",
                room: "12б",
                breakAfter: nil,
                breakEndTime: nil,
                isReplacement: false
            )
        ]
        
        var scheduleData: [Date: DaySchedule] = [:]
        scheduleData[startOfToday] = DaySchedule(
            date: startOfToday,
            items: todayItems,
            isWeekend: false
        )
        
        scheduleData[startOfTomorrow] = DaySchedule(
            date: startOfTomorrow,
            items: [],
            isWeekend: true
        )
        
        return scheduleData
    }
}
