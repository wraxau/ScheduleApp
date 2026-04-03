import Foundation

enum ScheduleMockData {
    static func generateSampleSchedule() -> [Date: DaySchedule] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        var scheduleData: [Date: DaySchedule] = [:]
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            let weekday = calendar.component(.weekday, from: date)
            let isWeekend = (weekday == 1 || weekday == 7) // 1 = воскресенье, 7 = суббота

            var items: [ScheduleItem] = []
            if !isWeekend {
                items = getItemsForDay(offset: dayOffset, weekday: weekday)
            }
            scheduleData[startOfDay] = DaySchedule(
                date: startOfDay, items: items, isWeekend: isWeekend
            )
        }
        return scheduleData
    }
    
    // Где-то данные могут быть немного кривыми, что написано онлайн, при это открывается аудитория, поправю чуть позже
    private static func getItemsForDay(offset: Int, weekday: Int) -> [ScheduleItem] {
        switch offset {
        case 0:
            return [
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
                    isReplacement: false,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Google Meet",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: "Необходимо выполнить задание с прошлой лекции"
                ),
                ScheduleItem(
                    number: 2,
                    type: .seminar,
                    startTime: "12:00",
                    endTime: "13:45",
                    subject: "Программировнаие на Java",
                    teacher: "Михайлов Иван Дмитриевич",
                    room: "Онлайн",
                    breakAfter: "Перерыв 1.15 мин",
                    breakEndTime: "15.00",
                    isReplacement: true,
                    topic: "История языка Java",
                    description: "Познакомимся с основами Java. Узнаем, как появился этот язык, и поговорим о его практическом применении",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Zoom",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: nil,
                    tasks: "Необходимо написать приложение, которое будет"
                    
                ),
                ScheduleItem(
                    number: 3,
                    type: .seminar,
                    startTime: "15:00",
                    endTime: "16:45",
                    subject: "Моделирование бизнес-процессов",
                    teacher: "Смирнов Алексей Иванович",
                    room: "Онлайн",
                    breakAfter: nil,
                    breakEndTime: nil,
                    isReplacement: false,
                    topic: "Нотация BPMN",
                    description: "Познакомимся с программой Storm BPMN, рассмотрим кейсы и приложенного файла.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Zoom",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: [
                        Material(name: "Кейсы_1.pdf", link: nil, size: "95 KB", type: "pdf"),
                        Material(name: "Презентация_как_работать_в_StormBPMN.pptx", link: nil, size: "450 KB", type: ".pptx")
                    ],
                    tasks: nil
                ),
                
                ScheduleItem(
                    number: 3,
                    type: .lecture,
                    startTime: "16:45",
                    endTime: "18:15",
                    subject: "Оптимизация и исследование операций",
                    teacher: "Смирнов Алексей Иванович",
                    room: "Онлайн",
                    breakAfter: nil,
                    breakEndTime: nil,
                    isReplacement: false,
                    topic: "Задачи на линейное программирование",
                    description: "Будем решать задачи на линейное программировнаие.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Телемост",
                    buildingInfo: nil,
                    isCancelled: true,
                    materials: nil,
                    tasks: nil
                )
            ]
        case 1:
            return [
                ScheduleItem(
                    number: 1,
                    type: .lecture,
                    startTime: "10:00",
                    endTime: "11:45",
                    subject: "Международное право",
                    teacher: "Иванов Иван Иванович",
                    room: "302",
                    breakAfter: "Перерыв 15 мин",
                    breakEndTime: "12.00",
                    isReplacement: false,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: nil,
                    meetingServiceName: nil,
                    buildingInfo: "Корпус 1, этаж 3",
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: nil
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
                    isReplacement: true,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: nil,
                    meetingServiceName: nil,
                    buildingInfo: "Корпус 1, этаж 4",
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: nil
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
                    isReplacement: false,
                    topic: "Комбинаторика",
                    description: "Будем решать задачи на комбинаторику. Рассмотрим задачи на перестановки, сочетания и размещения.",
                    meetingLink: nil,
                    meetingServiceName: nil,
                    buildingInfo: "Корпус 1, 1 этаж",
                    isCancelled: true,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: nil
                ),
                
                ScheduleItem(
                    number: 3,
                    type: .lecture,
                    startTime: "16:45",
                    endTime: "18:15",
                    subject: "Архитектура ОС",
                    teacher: "Смирнов Алексей Иванович",
                    room: "120",
                    breakAfter: nil,
                    breakEndTime: nil,
                    isReplacement: false,
                    topic: "Docker-контейнеры",
                    description: "На занятии рассмотрим как работать с Docker",
                    meetingLink: nil,
                    meetingServiceName: nil,
                    buildingInfo: "Корпус 5, этаж 1",
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: nil
                )
            ]
        case 2:
            return [
                ScheduleItem(
                    number: 1,
                    type: .lecture,
                    startTime: "08:00",
                    endTime: "09:20",
                    subject: "Проектирование UX/UI",
                    teacher: "Иванов Петр Сергеевич",
                    room: "Онлайн",
                    breakAfter: "Перерыв 10 мин",
                    breakEndTime: "09.30",
                    isReplacement: false,
                    topic: "Макеты мобильных приложений",
                    description: "На занятии рассмотрим пример построения макетов для мобильных приложений.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Google Meet",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: nil
                ),
                ScheduleItem(
                    number: 2,
                    type: .seminar,
                    startTime: "09:30",
                    endTime: "10:50",
                    subject: "Архитектура компьютера и ОС",
                    teacher: "Жданов Михаил Федорович",
                    room: "Онлайн",
                    breakAfter: nil,
                    breakEndTime: nil,
                    isReplacement: true,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Google Meet",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: nil
                ),
            ]
            
        case 3:
            return [
                ScheduleItem(
                    number: 1,
                    type: .lecture,
                    startTime: "13:00",
                    endTime: "14:20",
                    subject: "Международное право",
                    teacher: "Иванов Иван Иванович",
                    room: "Онлайн",
                    breakAfter: "Перерыв 20 мин",
                    breakEndTime: "14.40",
                    isReplacement: false,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Google Meet",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: nil
                ),
                ScheduleItem(
                    number: 2,
                    type: .seminar,
                    startTime: "14:40",
                    endTime: "16:00",
                    subject: "Государственное регулирование конституционной деятельности",
                    teacher: "Мальцев Дмитрий Викторович",
                    room: "Онлайн",
                    breakAfter: "Перерыв 20 мин",
                    breakEndTime: "16.20",
                    isReplacement: false,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Google Meet",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: "https:\\gosReg.ru", size: nil, type: nil)
                    ],
                    tasks: nil
                ),
                ScheduleItem(
                    number: 3,
                    type: .seminar,
                    startTime: "15:00",
                    endTime: "16:45",
                    subject: "Теория вероятностей",
                    teacher: "Смирнов Алексей Иванович",
                    room: "308",
                    breakAfter: nil,
                    breakEndTime: nil,
                    isReplacement: false,
                    topic: "Формула Бернулли",
                    description: "Будет решать задачи на формулу Бернулли. Те, кому не хватает оценок - смогут ответить у доски.",
                    meetingLink: nil,
                    meetingServiceName: nil,
                    buildingInfo: "Корпус 4, этаж 3",
                    isCancelled: false,
                    materials: [
                        Material(name: "Задачи_5_семинар.jpeg", link: nil, size: "30 KB", type: "jpeg")
                    ],
                    tasks: nil
                ),
                
                ScheduleItem(
                    number: 3,
                    type: .lecture,
                    startTime: "16:45",
                    endTime: "18:15",
                    subject: "Архитектура ОС",
                    teacher: "Смирнов Алексей Иванович",
                    room: "106",
                    breakAfter: nil,
                    breakEndTime: nil,
                    isReplacement: false,
                    topic: "ОС Linux",
                    description: "На занятии познакомимся с операционной системой Linux. Рассмотрим, когда ее удобно использовать, как настроить под себы и многое другое.",
                    meetingLink: nil,
                    meetingServiceName: nil,
                    buildingInfo: "Копус 2, этаж 1",
                    isCancelled: false,
                    materials: [
                        Material(name: "Статья", link: nil, size: "17 KB", type: "pdf")
                    ],
                    tasks: nil
                )
            ]
            
        case 4:
            return [
                ScheduleItem(
                    number: 1,
                    type: .lecture,
                    startTime: "11:10",
                    endTime: "12:30",
                    subject: "Программирование на Python",
                    teacher: "Беседин Вадим Игоревич",
                    room: "Онлайн",
                    breakAfter: "Перерыв 30 мин",
                    breakEndTime: "13.00",
                    isReplacement: true,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Google Meet",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: [
                        Material(name: "Учебник 'Программировнаие на python.pdf'", link: nil, size: "389 KB", type: "pdf")
                    ],
                    tasks: nil
                ),
                ScheduleItem(
                    number: 2,
                    type: .seminar,
                    startTime: "13:00",
                    endTime: "14:20",
                    subject: "Программировнаие на Python",
                    teacher: "Беседин Вадим Игоревич",
                    room: "405",
                    breakAfter: "Перерыв 20 мин",
                    breakEndTime: "14.40",
                    isReplacement: true,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: nil,
                    meetingServiceName: nil,
                    buildingInfo: "Корпус 6Б, этаж 4",
                    isCancelled: false,
                    materials: [
                        Material(name: "Учебник 'Программировнаие на python.pdf'", link: nil, size: "389 KB", type: "pdf")
                    ],
                    tasks: nil
                ),
                ScheduleItem(
                    number: 3,
                    type: .lecture,
                    startTime: "14:40",
                    endTime: "16:00",
                    subject: "Оптимизация и исследование операций",
                    teacher: "Смирнов Алексей Иванович",
                    room: "Онлайн",
                    breakAfter: nil,
                    breakEndTime: nil,
                    isReplacement: false,
                    topic: "История права и международные нормы",
                    description: "На занятии разберем основные принципы международного права, историю их формирования и применение в современных реалиях. Подготовьте конспект лекции за прошлую неделю.",
                    meetingLink: "https://meet.google.com/abc-defg-hij",
                    meetingServiceName: "Google Meet",
                    buildingInfo: nil,
                    isCancelled: false,
                    materials: nil,
                    tasks: nil
                )
                
            ]
            
        default:
            return[]
        }
        
    }
    
}
