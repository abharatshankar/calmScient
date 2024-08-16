//
//  MedicationsAPICodables.swift
//  CalmscientIOS
//
//  Created by NFC on NA.
//

import Foundation

// Define Codable classes to represent the JSON structure

class MedicationDetailsResponse: Codable {
    let response: ResponseDetails
    let totalRecords: Int
    let medicineDetails: [MedicineDetails]

    enum CodingKeys: String, CodingKey {
        case response
        case totalRecords
        case medicineDetails = "medicineDetails"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        response = try container.decode(ResponseDetails.self, forKey: .response)
        totalRecords = try container.decode(Int.self, forKey: .totalRecords)
        medicineDetails = try container.decode([MedicineDetails].self, forKey: .medicineDetails)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(response, forKey: .response)
        try container.encode(totalRecords, forKey: .totalRecords)
        try container.encode(medicineDetails, forKey: .medicineDetails)
    }
}



class MedicineDetails: Codable {
    let date: String
    let medicationDetailsByDate: [MedicationDetailsByDate]

    enum CodingKeys: String, CodingKey {
        case date
        case medicationDetailsByDate = "medicationDetailsByDate"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        medicationDetailsByDate = try container.decode([MedicationDetailsByDate].self, forKey: .medicationDetailsByDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(medicationDetailsByDate, forKey: .medicationDetailsByDate)
    }
}

class MedicationDetailsByDate: Codable {
    let medicineName: String
    let numberOfTablets: Int
    let medicalDetails: MedicalDetails
    let dosageTime: [String]

    enum CodingKeys: String, CodingKey {
        case medicineName
        case numberOfTablets
        case medicalDetails = "medicalDetails"
        case dosageTime
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        medicineName = try container.decode(String.self, forKey: .medicineName)
        numberOfTablets = try container.decode(Int.self, forKey: .numberOfTablets)
        medicalDetails = try container.decode(MedicalDetails.self, forKey: .medicalDetails)
        dosageTime = try container.decode([String].self, forKey: .dosageTime)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(medicineName, forKey: .medicineName)
        try container.encode(numberOfTablets, forKey: .numberOfTablets)
        try container.encode(medicalDetails, forKey: .medicalDetails)
        try container.encode(dosageTime, forKey: .dosageTime)
    }
}

class MedicalDetails: Codable {
    let medicationId: Int
    let medicineName: String
    let medicineDosage: String
    let providerName: String
    let providerId: Int
    let directions: String
    var scheduledTimeList: [ScheduledTimeList]

    enum CodingKeys: String, CodingKey {
        case medicationId
        case medicineName
        case medicineDosage
        case providerName
        case providerId
        case directions
        case scheduledTimeList = "scheduledTimeList"
    }
    
    

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        medicationId = try container.decode(Int.self, forKey: .medicationId)
        medicineName = try container.decode(String.self, forKey: .medicineName)
        medicineDosage = try container.decode(String.self, forKey: .medicineDosage)
        providerName = try container.decode(String.self, forKey: .providerName)
        providerId = try container.decode(Int.self, forKey: .providerId)
        directions = try container.decode(String.self, forKey: .directions)
        scheduledTimeList = try container.decode([ScheduledTimeList].self, forKey: .scheduledTimeList)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(medicationId, forKey: .medicationId)
        try container.encode(medicineName, forKey: .medicineName)
        try container.encode(medicineDosage, forKey: .medicineDosage)
        try container.encode(providerName, forKey: .providerName)
        try container.encode(providerId, forKey: .providerId)
        try container.encode(directions, forKey: .directions)
        try container.encode(scheduledTimeList, forKey: .scheduledTimeList)
    }
}

class ScheduledTimeList: Codable {
    var scheduledTimes: [ScheduledTimes]

    enum CodingKeys: String, CodingKey {
        case scheduledTimes
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scheduledTimes = try container.decode([ScheduledTimes].self, forKey: .scheduledTimes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scheduledTimes, forKey: .scheduledTimes)
    }
}

class ScheduledTimes: Codable {
    var medicineTime: String
    var alarmTime: String
    var alarmId: Int
    var alarmEnabled: String
    var alarmInterval: String
    var repeatDay: [String]

    enum CodingKeys: String, CodingKey {
        case medicineTime
        case alarmTime
        case alarmId
        case alarmEnabled
        case alarmInterval
        case repeatDate = "repeat"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        medicineTime = try container.decode(String.self, forKey: .medicineTime)
        alarmTime = try container.decode(String.self, forKey: .alarmTime)
        alarmId = try container.decode(Int.self, forKey: .alarmId)
        alarmEnabled = try container.decode(String.self, forKey: .alarmEnabled)
        alarmInterval = try container.decode(String.self, forKey: .alarmInterval)
        repeatDay = try container.decode([String].self, forKey: .repeatDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(medicineTime, forKey: .medicineTime)
        try container.encode(alarmTime, forKey: .alarmTime)
        try container.encode(alarmId, forKey: .alarmId)
        try container.encode(alarmEnabled, forKey: .alarmEnabled)
        try container.encode(alarmInterval, forKey: .alarmInterval)
        try container.encode(repeatDay, forKey: .repeatDate)
    }
}


//MARK: - ADD Medication

class MedicationAlarm: Codable {
    var alarmDate: String = ""
    var alarmId: Int = 0
    var alarmInterval: Int = 5
    var plId: Int = 0
    var medicationId: Int = 0
    var flag: String = "I"
    var isEnabled: Int = 0
    var medicineTime: String = ""
    var `repeat`: [String] = [] // Backticks are used for the 'repeat' key since it's a reserved keyword in Swift
    
    var dayTime:DayTimeValue = .Morning
    
    
    enum CodingKeys: String, CodingKey {
        case alarmDate, alarmId, alarmInterval, plId, medicationId, flag, isEnabled, medicineTime
        case `repeat` = "repeat"
    }
    
    init?(withScheduledTime:ScheduledTimes, medicationID:Int) {
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            return nil
        }
        let alarmDate = withScheduledTime.alarmTime.getDate(formatString: "yyyy-MM-dd HH:mm:ss")
        plId = userInfo.patientLocationID
        `repeat` = withScheduledTime.repeatDay
        self.medicationId = medicationID
        self.alarmId = withScheduledTime.alarmId
        self.medicineTime = withScheduledTime.medicineTime
        self.isEnabled = Int(withScheduledTime.alarmEnabled) ?? 0
        self.alarmInterval = Int(withScheduledTime.alarmInterval) ?? 5
        self.flag = "U"
        self.alarmDate = alarmDate.dateToString(format: "MM/dd/yyyy")
    }
    
    init?(alarmTime:DayTimeValue) {
        guard let userInfo = ApplicationSharedInfo.shared.loginResponse else {
            return nil
        }
        dayTime = alarmTime
        alarmDate = Date().dateToString(format: "MM/dd/yyyy")
        switch alarmTime {
        case .Morning:
            medicineTime = "06:00:00"
        case .Afternoon:
            medicineTime = "13:00:00"
        case .Evening:
            medicineTime = "19:00:00"
        }
        plId = userInfo.patientLocationID
        `repeat` = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }
    
    public func getDayTime() -> DayTimeValue {
        return DayTimeValue(rawValue: medicineTime.getDayTimeFromDate(formatter: "HH:mm:ss", includeTimeZone: false) ?? DayTimeValue.Morning.rawValue) ?? DayTimeValue.Morning
    }
    
    public func getTimeRestrictionsFromDate() -> [Date] {
        switch dayTime {
        case .Morning:
            let startTimeDate = "06:00:00".createDateFromTimeString()
            let endTimeDate = "11:59:00".createDateFromTimeString()
            return [startTimeDate,endTimeDate]
        case .Afternoon:
            let startTimeDate = "12:00:00".createDateFromTimeString()
            let endTimeDate = "16:59:00".createDateFromTimeString()
            return [startTimeDate,endTimeDate]
        case .Evening:
            let startTimeDate = "17:00:00".createDateFromTimeString()
            let endTimeDate = "23:59:00".createDateFromTimeString()
            return [startTimeDate,endTimeDate]
        }
    }
    
    func getAlarmIntervalStringValue() -> String {
        if alarmInterval < 10 {
            return "0\(alarmInterval)"
        } else {
            return "\(alarmInterval)"
        }
    }
    
    func getAlarmTime() -> String? {
        let medicineDateTime = medicineTime.getDate(formatString: "HH:mm:ss")
        let alarmTime = Calendar.current.date(byAdding: .minute, value: -alarmInterval, to: medicineDateTime)
        print("Alarm Time: \(alarmTime ?? Date().getTomorrowDate())")
        return alarmTime?.dateToString(format: "HH:mm:ss") ?? nil
    }
    
    func getAlarmTimeWithAMOrPM() -> String? {
        let alarmTime = self.getAlarmTime()
        return alarmTime?.getDayTimeFromDate(formatter: "HH:mm:ss", includeTimeZone: true)
    }
    
    func getMedicineTimeWithAMorPM() -> String? {
        return medicineTime.getDayTimeFromDate(formatter: "HH:mm:ss", includeTimeZone: true)
    }
    
    // Custom init method to decode JSON data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarmDate = try container.decode(String.self, forKey: .alarmDate)
        alarmId = try container.decode(Int.self, forKey: .alarmId)
        alarmInterval = try container.decode(Int.self, forKey: .alarmInterval)
        plId = try container.decode(Int.self, forKey: .plId)
        medicationId = try container.decode(Int.self, forKey: .medicationId)
        flag = try container.decode(String.self, forKey: .flag)
        isEnabled = try container.decode(Int.self, forKey: .isEnabled)
        medicineTime = try container.decode(String.self, forKey: .medicineTime)
        `repeat` = try container.decode([String].self, forKey: .repeat)
    }
    
    // Custom encode method to encode to JSON data
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alarmDate, forKey: .alarmDate)
        try container.encode(alarmId, forKey: .alarmId)
        try container.encode(alarmInterval, forKey: .alarmInterval)
        try container.encode(plId, forKey: .plId)
        try container.encode(medicationId, forKey: .medicationId)
        try container.encode(flag, forKey: .flag)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(medicineTime, forKey: .medicineTime)
        try container.encode(`repeat`, forKey: .repeat)
    }
}



// Define Codable struct for the main object
class AddMedication: Codable {
    var alarms: [MedicationAlarm] = []
    var direction: String = ""
    var dosage: String = ""
    var endDate: String = Date().getTomorrowDate().dateToString(format: "MM/dd/yyyy")
    var isActive: Int = 1
    var medicationName: String = ""
    var medicineTime: String = ""
    var plId: Int = ApplicationSharedInfo.shared.loginResponse!.patientLocationID
    var prescriptionId: Int = 0
    var providerId: Int = 0
    var pvcFlag: String = "I"
    var quantity: Int = 1
    var startDate: String = Date().dateToString(format: "MM/dd/yyyy")
    var withMeal: Int = 0

    enum CodingKeys: String, CodingKey {
        case alarms, direction, dosage, endDate, isActive, medicationName, medicineTime, plId, prescriptionId, providerId, pvcFlag, quantity, startDate, withMeal
    }
    
    init() {
        
    }
    
    // Custom init method to decode JSON data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarms = try container.decode([MedicationAlarm].self, forKey: .alarms)
        direction = try container.decode(String.self, forKey: .direction)
        dosage = try container.decode(String.self, forKey: .dosage)
        endDate = try container.decode(String.self, forKey: .endDate)
        isActive = try container.decode(Int.self, forKey: .isActive)
        medicationName = try container.decode(String.self, forKey: .medicationName)
        medicineTime = try container.decode(String.self, forKey: .medicineTime)
        plId = try container.decode(Int.self, forKey: .plId)
        prescriptionId = try container.decode(Int.self, forKey: .prescriptionId)
        providerId = try container.decode(Int.self, forKey: .providerId)
        pvcFlag = try container.decode(String.self, forKey: .pvcFlag)
        quantity = try container.decode(Int.self, forKey: .quantity)
        startDate = try container.decode(String.self, forKey: .startDate)
        withMeal = try container.decode(Int.self, forKey: .withMeal)
    }

    // Custom encode method to encode to JSON data
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alarms, forKey: .alarms)
        try container.encode(direction, forKey: .direction)
        try container.encode(dosage, forKey: .dosage)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(medicationName, forKey: .medicationName)
        try container.encode(medicineTime, forKey: .medicineTime)
        try container.encode(plId, forKey: .plId)
        try container.encode(prescriptionId, forKey: .prescriptionId)
        try container.encode(providerId, forKey: .providerId)
        try container.encode(pvcFlag, forKey: .pvcFlag)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(withMeal, forKey: .withMeal)
    }
}

class AddMedicationSavedResponse: Codable {
    let response: ResponseDetails
    
    enum CodingKeys: String, CodingKey {
        case response
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        response = try container.decode(ResponseDetails.self, forKey: .response)
    }
    
    // Encode method to encode JSON data
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(response, forKey: .response)
    }
    
}

class GetMedicationsRequestForm: EndPointRequest {
    var baseURL: String = baseURLString
    var path: String = "patients/api/v1/medications/getMedications"
    var httpMethod: HTTPMethod = .post
    var requestBody: [String : Any]
    
    required init(_ requestBodyParams:[String:Any]) {
        self.requestBody = requestBodyParams
    }
}


class AddMedicationsRequestForm: EndPointRequest {
    
    var baseURL: String = baseURLString
    var path: String = "patients/api/v1/medications/addMedications"
    var httpMethod: HTTPMethod = .post
    var requestBody: [String : Any] = [:]
    var jsonData:Data? = nil
    
    required init(_ requestData:Data?) {
        self.jsonData = requestData
    }
    
    func getURLRequest() -> URLRequest? {
        
        guard let url = URL(string: "\(baseURL)\(path)"), jsonData != nil else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        
        for keyValuePair in self.headers {
            request.setValue(keyValuePair.value, forHTTPHeaderField: keyValuePair.key)
        }
        request.httpBody = jsonData
        
        return request
    }
}

class UpdateMedicationsAlarmRequestForm: EndPointRequest {
    var baseURL: String = baseURLString
    var path: String = "patients/api/v1/medications/addPatientMedicationAlarms"
    var httpMethod: HTTPMethod = .post
    var requestBody: [String : Any] = [:]
    var jsonData:Data? = nil
    
    required init(_ requestData:Data?) {
        self.jsonData = requestData
    }
    
    func getURLRequest() -> URLRequest? {
        
        guard let url = URL(string: "\(baseURL)\(path)"), jsonData != nil else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        
        for keyValuePair in self.headers {
            request.setValue(keyValuePair.value, forHTTPHeaderField: keyValuePair.key)
        }
        request.httpBody = jsonData
        
        return request
    }
}

class OnlyMedicationAlarm:Codable {
    var alarms: [MedicationAlarm] = []
    
    enum CodingKeys: String, CodingKey {
        case alarms
    }
    init() {
        
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarms = try container.decode([MedicationAlarm].self, forKey: .alarms)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alarms, forKey: .alarms)
    }
}
