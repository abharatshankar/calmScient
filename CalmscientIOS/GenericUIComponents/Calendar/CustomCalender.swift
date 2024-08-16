//
//  CustomCalender.swift
//  CalenderComponent
//
//  Created by KA on 20/03/24.
//

import Foundation
import UIKit
import FSCalendar

public protocol CalendarToViewDelegate : AnyObject {
    func calendardidChangeBounds(newBounds:CGRect)
    func userSelectedNewDate(selectedDate:Date)
}


class CustomCalender : UIView {
    
    @IBOutlet weak var customCalender: FSCalendar!
    
    public weak var calendarToViewDelegate:CalendarToViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib(nibName: "CustomCalender")
        setupCalenderView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib(nibName: "CustomCalender")
        setupCalenderView()
    }
    
    private func loadViewFromNib(nibName: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func setupCalenderView() {
        customCalender.allowsMultipleSelection = false
        customCalender.scope = .week
        customCalender.delegate = self
        customCalender.dataSource = self
        customCalender.today = nil
        customCalender.select(Date())
//        customCalender.today = nil
    }
    
    deinit {
        print("CustomCalender Deinit called")
    }
    
}

extension CustomCalender : FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.customCalender.frame.size.height = bounds.height
        calendarToViewDelegate?.calendardidChangeBounds(newBounds: bounds)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("User selected date is \(convertToLocalTimeZone(date: date))")
        calendarToViewDelegate?.userSelectedNewDate(selectedDate: convertToLocalTimeZone(date: date))
    }
    
    func convertToLocalTimeZone(date: Date) -> Date {
        let timeZone = TimeZone.current
        let calendar = Calendar.current
        let localDate = calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(for: date), to: date)!
        return localDate
    }

}
