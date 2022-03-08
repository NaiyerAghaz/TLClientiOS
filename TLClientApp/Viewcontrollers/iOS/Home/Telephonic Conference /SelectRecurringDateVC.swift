//
//  SelectRecurringDateVC.swift
//  TLClientApp
//
//  Created by Rajni Bajaj on 04/03/22.
//

import UIKit
import FSCalendar
import iOSDropDown
protocol SelectDateForRecurrence{
    func SelectAppointmentDate(selectedDateArr: [SelectedDatesModel])
}
class DatesTableViewCell : UITableViewCell {
    
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var dateTF: UITextField!
}
class WeekDayCVCell : UICollectionViewCell {
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
}
class SelectRecurringDateVC: UIViewController {

    @IBOutlet weak var weeklySlecetionView: UIView!
    @IBOutlet weak var dateChangeSegment: UISegmentedControl!
    @IBOutlet weak var dailySelcetionView: UIView!
    @IBOutlet weak var datesTV: ContentSizedTableView!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var firstAppointmentDateTF: UITextField!
    @IBOutlet weak var calenderOuterView: UIView!
    @IBOutlet weak var selectedDateLbl: UILabel!
    @IBOutlet weak var selectedDateTFLbl: UILabel!
    @IBOutlet weak var weekendSelectionSwitch: UISwitch!
    @IBOutlet weak var dayCountTF: iOSDropDown!
    @IBOutlet weak var weekCv: UICollectionView!
    
    var isWeekCV = false
    var filterCount = 0
    var countArr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    let monthArr = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var daysArr = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var delegate:SelectDateForRecurrence?
    var dayStringArr = [String]()
    var monthStringArr = [String]()
    var firstDate: Date?
    var datesRange: [Date]?
    var lastDate: Date?
    var weekDayAndMonthArr = [WeekDayAndMonthData]()
    var calenderObject = FSCalendar()
    var showSelectedDatArr = [SelectedDatesModel]()
    var selectedDatesArr = [SelectedDatesModel]()
    var isWeekendON = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.calenderOuterView.visibility = .gone
        createCalendar()
        self.datesTV.delegate = self
        self.datesTV.dataSource = self
        self.weekCv.delegate = self
        self.weekCv.dataSource = self
        self.weeklySlecetionView.isHidden = true
        self.dailySelcetionView.isHidden = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let dayString = dateFormatter.string(from: tomorrow ?? Date())
        self.selectedDateLbl.text = "\(dayString) - \(dayString)"
        self.selectedDateTFLbl.text = "\(dayString) - \(dayString)"
        self.dateChangeSegment.addUnderlineForSelectedSegment()
        self.weekendSelectionSwitch.isOn = false
        self.weekendSelectionSwitch.addTarget(self, action: #selector(selcetWeekendData), for: .valueChanged)
        self.dayCountTF.optionArray = self.countArr
        
        self.dayCountTF.checkMarkEnabled = false
        self.dayCountTF.arrowSize = 0.2
        
        self.dayCountTF.isSearchEnable = true
        self.dayCountTF.selectedRowColor = UIColor.clear
        self.dayCountTF.didSelect{(selectedText , index , id) in
            self.dayCountTF.text = "\(selectedText)"
            self.filterCount = Int(selectedText) ?? 0
            var count = 0
            self.showSelectedDatArr.removeAll()
            let sortedArr = self.selectedDatesArr.sorted(by: { $0.selectedDate.compare($1.selectedDate) == .orderedAscending })

            sortedArr.forEach { dateModel in
                if self.isWeekendON {
                    
                    if count == self.filterCount {
                        if (dateModel.selectedDay == "Sunday") || (dateModel.selectedDay == "Saturday") {
                            
                        }else {
                            self.showSelectedDatArr.append(dateModel)
                        }
                        count = 0
                    }else {
                        count = count + 1
                    }
                    
                }else {
                    
                    if count == self.filterCount {
                        self.showSelectedDatArr.append(dateModel)
                        count = 0
                    }else {
                        count = count + 1
                    }
                    
                }
                
            }
            self.datesTV.reloadData()
        }
        
    }
    @objc func selcetWeekendData(sender : UISwitch){
        if sender.isOn {
            sender.isOn = true
            print("true block ")
            // remove sat sunday
            
            
            
            self.showSelectedDatArr.removeAll()
            let sortedArr = self.selectedDatesArr.sorted(by: { $0.selectedDate.compare($1.selectedDate) == .orderedAscending })
            sortedArr.forEach { DataModel in
                if (DataModel.selectedDay == "Sunday") || (DataModel.selectedDay == "Saturday") {
                    
                }else {
                    self.showSelectedDatArr.append(DataModel)
                }
            }
            self.datesTV.reloadData()
            self.isWeekendON = true
            
            
        }else {
            sender.isOn = false
            print("false block ")
            // show sat sunday
            
            self.showSelectedDatArr.removeAll()
            let sortedArr = self.selectedDatesArr.sorted(by: { $0.selectedDate.compare($1.selectedDate) == .orderedAscending })
            sortedArr.forEach { DataModel in
                self.showSelectedDatArr.append(DataModel)
            }
            self.datesTV.reloadData()
            
            self.isWeekendON = false
            
            
            
            
        }
        
    }
    @IBAction func actionCancelDates(_ sender: UIButton) {
        for d in self.calenderObject.selectedDates {
            self.calenderObject.deselect(d)
        }
        self.calenderOuterView.visibility = .gone
    }
    @IBAction func actionAddDates(_ sender: UIButton) {
        self.selectedDatesArr.removeAll()
        self.showSelectedDatArr.removeAll()
        self.datesRange?.forEach({ dateElement in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayString = dateFormatter.string(from: dateElement)
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "MMMM"
            let monthString = dateFormatter1.string(from: dateElement)
            
            let itemA = SelectedDatesModel(selectedDate: dateElement, selectedDay: dayString, selectedMonth: monthString)
            print(itemA)
            if  self.isWeekendON {
                if dayString == "Sunday" || dayString == "Saturday" {
                    
                }else {
                    self.showSelectedDatArr.append(itemA)
                    self.selectedDatesArr.append(itemA)
                }
            }else {
                self.showSelectedDatArr.append(itemA)
                self.selectedDatesArr.append(itemA)
            }
            
        })
        let SortArr = self.selectedDatesArr.sorted(by: { $0.selectedDate.compare($1.selectedDate) == .orderedAscending })
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let first = SortArr.first?.selectedDate
        let last = SortArr.last?.selectedDate
        let firstString = dateFormatter.string(from: first ?? Date())
        let lasrString = dateFormatter.string(from: last ?? Date())
        self.selectedDateLbl.text = "\(firstString) - \(lasrString)"
        self.selectedDateTFLbl.text = "\(firstString) - \(lasrString)"
        
        
        self.datesTV.reloadData()
    }
    func createCalendar(){
        //calenderView.removeFromSuperview()
        calenderView.subviews.forEach { (item) in
             item.removeFromSuperview()
        }
        let cwidth = (UIScreen.main.bounds.width) - 50
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: cwidth, height: 300))
        //calendar.removeFromSuperview()+
        calendar.placeholderType = .none
        //calendar.appearance.separators = .interRows
        calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
       
        let tDate = Date()
        let intialDate = Calendar.current.date(byAdding: .day, value: 1, to: tDate)!
        let formatterTest = DateFormatter()
        formatterTest.dateFormat = "yyyy/MM/dd"
        print(formatterTest.string(from: tDate))
        let finalDate = formatterTest.string(from: intialDate)
        
        
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
        self.calenderObject = calendar
            calenderView.addSubview(calendar)
        let FirstDate = Date()
        let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy hh:mm a"
        guard let result : String = formatter.string(from: FirstDate) as String? else { return }
        print("selected Date -->",result )
        self.firstAppointmentDateTF.text = result
       // self.selectedDateTF.text =
        let userId = userDefaults.string(forKey: "userId") ?? ""
        let CustomerID = userDefaults.string(forKey: "CustomerID") ?? ""
        let userTypeID = userDefaults.string(forKey: "userTypeID") ?? ""
        print("userId is \(userId) , cutomerId is \(CustomerID) , usertypeID is \(userTypeID)")
        
    }
   
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionCancelAppointment(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionSelcetDate(_ sender: UIButton) {
        self.calenderOuterView.visibility = .visible
    }
    
    @IBAction func actionAddApointments(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        self.delegate?.SelectAppointmentDate(selectedDateArr: self.showSelectedDatArr)
    }
    @IBAction func dateChangeSegment(_ sender: UISegmentedControl) {
        print("sender.selectedSegmentIndex",sender.selectedSegmentIndex)
       // self.dateChangeSegment.changeUnderlinePosition()
        if sender.selectedSegmentIndex == 0 {
            isWeekCV = false
            self.dailySelcetionView.isHidden = false
            self.weeklySlecetionView.isHidden = true
        }else if sender.selectedSegmentIndex == 1{
            isWeekCV = true
            self.weekDayAndMonthArr.removeAll()
            self.daysArr.forEach { day in
                let itemA = WeekDayAndMonthData(titleName: day, isSelect: false)
                self.weekDayAndMonthArr.append(itemA)
            }
            self.weeklySlecetionView.isHidden = false
            self.dailySelcetionView.isHidden = true
            self.weekCv.reloadData()
        }else if sender.selectedSegmentIndex == 2{
            
            isWeekCV = false
            self.weekDayAndMonthArr.removeAll()
            self.monthArr.forEach { month in
                let itemA = WeekDayAndMonthData(titleName: month, isSelect: false)
                self.weekDayAndMonthArr.append(itemA)
            }
            self.weeklySlecetionView.isHidden = false
            self.dailySelcetionView.isHidden = true
            self.weekCv.reloadData()
        }else {
            
        }
        
    }
}
//MARK: - Collection Work
extension SelectRecurringDateVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDayAndMonthArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCVCell", for: indexPath) as! WeekDayCVCell
        cell.selectBtn.tag = indexPath.row
        
     
        let indx = self.weekDayAndMonthArr[indexPath.row]
        cell.titleLbl.text = indx.titleName
        let isSelect = indx.isSelect
        if isSelect {
            cell.selectImg.image = UIImage(systemName: "checkmark.square.fill")
            cell.selectImg.tintColor = UIColor(hexString: "33A5FF")
        }else {
            cell.selectImg.image = UIImage(systemName: "square")
            cell.selectImg.tintColor = UIColor.lightGray
        }
        cell.selectBtn.addTarget(self, action: #selector(selectMonthlyData), for: .touchUpInside)
            
        
        
        return cell
        
    }
    @objc func selectWeeklyData(){
        
    }
    @objc func selectMonthlyData(sender : UIButton){
        let isselect = self.weekDayAndMonthArr[sender.tag].isSelect
        
        
        
        
        if isselect  {
            self.weekDayAndMonthArr[sender.tag].isSelect = false
            
            if isWeekCV {
            // self.dayStringArr.append(self.weekDayAndMonthArr[sender.tag].titleName)
                  let title = self.weekDayAndMonthArr[sender.tag].titleName
                  self.dayStringArr.removeAll { $0 == title }
                  self.showSelectedDatArr.removeAll()
                  self.selectedDatesArr.forEach { selectedDate in
                      
                          self.dayStringArr.forEach { dayString in
                                 if dayString == selectedDate.selectedDay {
                                      print("Selected Day ",dayString)
                                      self.showSelectedDatArr.append(selectedDate)
                                 }else {
                                     
                                       print("unselected day ",dayString)
                                 }
                        }
                    }
            }else {
                let title = self.weekDayAndMonthArr[sender.tag].titleName
                self.monthStringArr.removeAll { $0 == title }
                self.showSelectedDatArr.removeAll()
                self.selectedDatesArr.forEach { selectedDate in
                    self.monthStringArr.forEach { dayString in
                        if dayString == selectedDate.selectedDay {
                            print(dayString)
                            self.showSelectedDatArr.append(selectedDate)
                        }else {
                            print(dayString)
                        }
                    }
                }
            }
        }else {
            self.weekDayAndMonthArr[sender.tag].isSelect = true
            
            if isWeekCV {
                self.dayStringArr.append(self.weekDayAndMonthArr[sender.tag].titleName)
                self.showSelectedDatArr.removeAll()
                self.selectedDatesArr.forEach { selectedDate in
                    self.dayStringArr.forEach { dayString in
                        if dayString == selectedDate.selectedDay {
                            print("Selected Day ",dayString)
                            self.showSelectedDatArr.append(selectedDate)
                        }else {
                            print("unselected day ",dayString)
                        }
                    }
                }
            }else {
                self.monthStringArr.append(self.weekDayAndMonthArr[sender.tag].titleName)
                self.showSelectedDatArr.removeAll()
                self.selectedDatesArr.forEach { selectedDate in
                    self.monthStringArr.forEach { dayString in
                        if dayString == selectedDate.selectedDay {
                            print(dayString)
                            self.showSelectedDatArr.append(selectedDate)
                        }else {
                            print(dayString)
                        }
                    }
                }
            }
        }
        self.datesTV.reloadData()
        self.weekCv.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("collection view cell ")
            let noOfCellsInRow = 2
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((weekCv.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: 40)
        }
    
    
}
//MARK: - Table work
extension SelectRecurringDateVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showSelectedDatArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell", for: indexPath) as! DatesTableViewCell
        let selectedDate = self.showSelectedDatArr[indexPath.row].selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let dayString = dateFormatter.string(from: selectedDate)
        cell.dateTF.text = dayString
        return cell
    }
}
//MARK: - Calender Delegate for deselcet past dates

extension SelectRecurringDateVC : FSCalendarDataSource, FSCalendarDelegate ,FSCalendarDelegateAppearance{
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
        
        return Date()
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date .compare(Date()) == .orderedAscending {
            return UIColor.lightGray
        }
        else {
            return UIColor.black
        }
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedAscending {
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
    }
}




struct SelectedDatesModel {
    var selectedDate : Date
    var selectedDay : String
    var selectedMonth : String
}
struct WeekDayAndMonthData {
    var titleName : String
    var isSelect : Bool
}
