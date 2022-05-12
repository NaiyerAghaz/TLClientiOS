//
//  RecurrenceCalendarView.swift
//  TLClientApp
//
//  Created by Darrin Brooks on 10/05/22.
//

import UIKit
import FSCalendar
import BottomPopup
class RecurrenceCalendarView: BottomPopupViewController {
    
    var height: CGFloat?
     var topCornerRadius: CGFloat?
     var presentDuration: Double?
     var dismissDuration: Double?
     var shouldDismissInteractivelty: Bool?
     var popupDismisAlphaVal : CGFloat?
    var delegate: CommonDelegates?
    var calendar = FSCalendar()
    @IBOutlet weak var rCalendarView: UIView!
    var firstDate: Date?
    var datesRange: [Date]?
    var lastDate: Date?
    var appointmentDate : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 340)
        createCalendar()
    }
    //MARK: createCalendar
    override var popupHeight: CGFloat { height ?? 500.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    override var popupDimmingViewAlpha: CGFloat { popupDismisAlphaVal ?? 1.0}
    func createCalendar(){
        //calenderView.removeFromSuperview()
        rCalendarView.subviews.forEach { (item) in
             item.removeFromSuperview()
        }
      calendar.placeholderType = .none
      calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        let nDate = CEnumClass.share.getDateAndTimeFromString(dateStr: appointmentDate!)
        let tDate = Date()
        let intialDate = Calendar.current.date(byAdding: .day, value: 1, to: nDate)!
        let formatterTest = DateFormatter()
        formatterTest.dateFormat = "MM/dd/yyyy"
        print(formatterTest.string(from: tDate))
        let finalDate = formatterTest.string(from: intialDate)
        
        firstDate = formatterTest.date(from: finalDate)!
        datesRange = [firstDate!]
        calendar.select(formatterTest.date(from: finalDate)!)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .blue
        calendar.today = Date()
        //calendar.currentPage = Date()
        calendar.setCurrentPage(Date(), animated: true)
        calendar.calendarHeaderView.backgroundColor = UIColor(hexString: "#33A5FF")
        calendar.appearance.headerMinimumDissolvedAlpha = (0.3)
        calendar.appearance.headerTitleColor = .white
        calendar.allowsMultipleSelection = true
        calendar.isMultipleTouchEnabled = true
        calendar.scope = .month
       // self.calenderObject = calendar
            rCalendarView.addSubview(calendar)
 }
 
    @IBAction func btnApplyTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        delegate?.getCaledarSelectedData?(range: datesRange)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - Calender Delegate for deselcet past dates

extension RecurrenceCalendarView : FSCalendarDataSource, FSCalendarDelegate ,FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]

            print("datesRange contains first date only : \(datesRange!)")

            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains: \(datesRange!)")

                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange for last range contains:  \(datesRange!)")

            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        let apDate = CEnumClass.share.getDateAndTimeFromString(dateStr: appointmentDate!)
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: apDate)!
     
        return newDate
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let apDate = CEnumClass.share.getDateAndTimeFromString(dateStr: appointmentDate!)
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: apDate)!
        if date .compare(newDate) == .orderedAscending {
            return UIColor.lightGray
        }
        else {
            return UIColor.black
        }
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        if date .compare(CEnumClass.share.getDateAndTimeFromString(dateStr: appointmentDate!)) == .orderedAscending {
//            return false
//        }
        if date <= CEnumClass.share.getDateAndTimeFromString(dateStr: appointmentDate!) {
            return false
        }
        else {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:

        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
        else if firstDate != nil {
            firstDate = nil
           
        }
    }
}
