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
    func reloadAppointmentData()
}
class DatesTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var titledate: UILabel!
    
}
class WeekDayCVCell : UICollectionViewCell {
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var selectImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override  func awakeFromNib() {
        self.titleLbl.lineBreakMode = .byWordWrapping
        self.titleLbl.numberOfLines = 0
        self.titleLbl.fs_width = 80
    }
}
class SelectRecurringDateVC: UIViewController, CommonDelegates {
    
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var weeklySlecetionView: UIView!
    @IBOutlet weak var dateChangeSegment: UISegmentedControl!
    @IBOutlet weak var dailySelcetionView: UIView!
    @IBOutlet weak var datesTV: ContentSizedTableView!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var firstAppointmentDateTF: UITextField!
    @IBOutlet weak var selectedDateTFLbl: UILabel!
    @IBOutlet weak var selectedDateTF: UITextField!
    @IBOutlet weak var weekendSelectionSwitch: UISwitch!
    @IBOutlet weak var dayCountTF: iOSDropDown!
    
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    var appointmentDate : String?
    var previousAppointmentData: BlockedAppointmentData?
    var appointmentStartTime: String?
    var AppointmentEndTIme: String?
    
    @IBOutlet weak var weekCv: UICollectionView!
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        return layout
    }()
    var isWeekCV = false
    var filterCount = 1
    var countArr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    let monthArr = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    var daysArr = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
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
    var isNotWeekDays = false
    var calendar = FSCalendar()
    override func viewDidLoad() {
        super.viewDidLoad()
        weekCv.isScrollEnabled = false
        let startDateAndTime = "\(appointmentDate!) \(appointmentStartTime!)"
        let endDateTime =  "\(appointmentDate!) \(AppointmentEndTIme!)"
        self.firstAppointmentDateTF.text = "\(startDateAndTime) - \(endDateTime)"//result
        self.firstAppointmentDateTF.isUserInteractionEnabled = false
        self.datesTV.delegate = self
        self.datesTV.dataSource = self
        self.weekCv.delegate = self
        self.weekCv.dataSource = self
        self.weeklySlecetionView.isHidden = true
        self.dailySelcetionView.isHidden = false
        
        self.weekendSelectionSwitch.isOn = false
        self.weekendSelectionSwitch.addTarget(self, action: #selector(selcetWeekendData), for: .valueChanged)
        selectDaysFilter()
        
    }
    
    func selectDaysFilter(){
        self.dayCountTF.optionArray = self.countArr
        self.dayCountTF.checkMarkEnabled = false
        self.dayCountTF.arrowSize = 0.2
        
        self.dayCountTF.isSearchEnable = false
        self.dayCountTF.selectedRowColor = UIColor.clear
        self.dayCountTF.didSelect{(selectedText , index , id) in
            self.dayCountTF.text = "\(selectedText)"
            self.filterCount = Int(selectedText)!
            
            self.showSelectedDatArr.removeAll()
            
            if !self.isNotWeekDays{
                for i in stride(from: 0, to: self.selectedDatesArr.count, by: self.filterCount) {
                    self.showSelectedDatArr.append(self.selectedDatesArr[i])
                }
                
            }
            else {
                for i in stride(from: 0, to: self.selectedDatesArr.count, by: self.filterCount) {
                    let days = CEnumClass.share.getWeekDaysName(date: self.selectedDatesArr[i].selectedDate)
                    
                    if days.contains("sun") || days.contains("sat") {
                        
                    }
                    else {
                        
                        self.showSelectedDatArr.append(self.selectedDatesArr[i])
                    }
                }
                
            }
            self.datesTV.reloadData()
        }
    }
    @objc func selcetWeekendData(sender : UISwitch){
        if sender.isOn {
            sender.isOn = true
            
            self.showSelectedDatArr.removeAll()
            for i in stride(from: 0, to: self.selectedDatesArr.count, by: self.filterCount) {
                let days = CEnumClass.share.getWeekDaysName(date: self.selectedDatesArr[i].selectedDate)
                //  print("days---1:",days)
                if days.contains("sun") || days.contains("sat") {
                    //  print("days---2:",days)
                }
                else {
                    //   print("days---3:",days)
                    self.showSelectedDatArr.append(self.selectedDatesArr[i])
                }
                
                
            }
            self.datesTV.reloadData()
            self.isNotWeekDays = true
            
            
        }else {
            sender.isOn = false
            self.showSelectedDatArr.removeAll()
            
            for i in stride(from: 0, to: self.selectedDatesArr.count, by: self.filterCount) {
                
                self.showSelectedDatArr.append(self.selectedDatesArr[i])
            }
            self.datesTV.reloadData()
            
            self.isNotWeekDays = false
        }
        
    }
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.reloadAppointmentData()
    }
    @IBAction func actionCancelAppointment(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.reloadAppointmentData()
    }
    
    @IBAction func actionSelcetDate(_ sender: UIButton) {
        let callVC = UIStoryboard(name: Storyboard_name.scheduleApnt, bundle: nil)
        let vc = callVC.instantiateViewController(identifier: Control_Name.recurrenceCV) as! RecurrenceCalendarView
        vc.height = 455
        vc.topCornerRadius = 30
        vc.presentDuration = 0.5
        vc.dismissDuration = 0.2
        vc.shouldDismissInteractivelty = false
        vc.popupDismisAlphaVal = 0.4
        vc.appointmentDate = appointmentDate
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func actionAddApointments(_ sender: UIButton) {
        if selectedDateTF.text != "" {
            self.dismiss(animated: true, completion: nil)
            
            self.delegate?.SelectAppointmentDate(selectedDateArr: self.showSelectedDatArr)
        }
        else {
            self.view.makeToast("Please select date..!")
        }
        
    }
    @IBAction func dateChangeSegment(_ sender: UISegmentedControl) {
        print("sender.selectedSegmentIndex",sender.selectedSegmentIndex)
        // self.dateChangeSegment.changeUnderlinePosition()
        dateChangeSegment.selectedSegmentIndex = sender.selectedSegmentIndex
        if sender.selectedSegmentIndex == 0 {
            self.dayCountTF.text = "1"
            self.weekendSelectionSwitch.isOn = false
            isWeekCV = false
            self.dailySelcetionView.isHidden = false
            self.weeklySlecetionView.isHidden = true
            filterViewHeight.constant = 200
            self.showSelectedDatArr = self.selectedDatesArr
            self.datesTV.reloadData()
            
        }else if sender.selectedSegmentIndex == 1{
            dayStringArr.removeAll()
            filterViewHeight.constant = 210
            isWeekCV = true
            self.weekDayAndMonthArr.removeAll()
            self.daysArr.forEach { day in
                let itemA = WeekDayAndMonthData(titleName: day, isSelect: false)
                self.weekDayAndMonthArr.append(itemA)
            }
            self.weeklySlecetionView.isHidden = false
            self.dailySelcetionView.isHidden = true
            DispatchQueue.main.async {
                self.weekCv.reloadData()
            }
            self.showSelectedDatArr = self.selectedDatesArr
            self.datesTV.reloadData()
        }else if sender.selectedSegmentIndex == 2{
            monthStringArr.removeAll()
            filterViewHeight.constant = 240
            isWeekCV = false
            self.weekDayAndMonthArr.removeAll()
            self.monthArr.forEach { month in
                let itemA = WeekDayAndMonthData(titleName: month, isSelect: false)
                self.weekDayAndMonthArr.append(itemA)
            }
            self.weeklySlecetionView.isHidden = false
            self.dailySelcetionView.isHidden = true
            DispatchQueue.main.async {
                self.weekCv.reloadData()
            }
            self.showSelectedDatArr = self.selectedDatesArr
            self.datesTV.reloadData()
            
        }else {
            
        }
        
    }
    func getCaledarSelectedData(range: [Date]?) {
        if range!.count > 0 {
            lblEmpty.isHidden = true
        }
        datesRange = range
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
            
            self.showSelectedDatArr.append(itemA)
            self.selectedDatesArr.append(itemA)
            
        })
        let SortArr = self.selectedDatesArr.sorted(by: { $0.selectedDate.compare($1.selectedDate) == .orderedAscending })
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let first = SortArr.first?.selectedDate
        let last = SortArr.last?.selectedDate
        let firstString = dateFormatter.string(from: first ?? Date())
        let lasrString = dateFormatter.string(from: last ?? Date())
        
        self.selectedDateTF.text = "\(firstString) \(appointmentStartTime!) - \(lasrString) \(AppointmentEndTIme!)"
        
        
        if dateChangeSegment.selectedSegmentIndex == 0 {
            self.dayCountTF.text = "1"
            self.weekendSelectionSwitch.isOn = false
        }
        else if dateChangeSegment.selectedSegmentIndex == 1 {
            self.weekDayAndMonthArr.removeAll()
            
            self.daysArr.forEach { day in
                let itemA = WeekDayAndMonthData(titleName: day, isSelect: false)
                self.weekDayAndMonthArr.append(itemA)
            }
            
            weekCv.reloadData()
            
        }
        else if dateChangeSegment.selectedSegmentIndex == 2 {
            self.weekDayAndMonthArr.removeAll()
            monthStringArr.removeAll()
            self.monthArr.forEach { month in
                let itemA = WeekDayAndMonthData(titleName: month, isSelect: false)
                self.weekDayAndMonthArr.append(itemA)
            }
            
            weekCv.reloadData()
            
        }
        self.datesTV.reloadData()
        
    }
}
//MARK: - Collection Work
extension SelectRecurringDateVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDayAndMonthArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCVCell", for: indexPath) as! WeekDayCVCell
        cell.titleLbl.adjustsFontSizeToFitWidth = true
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
    //MARK: Filter with weekly and monthly
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
                    if self.dayStringArr.count > 0 {
                        self.dayStringArr.forEach { dayString in
                            let days = CEnumClass.share.getWeekDaysName(date: selectedDate.selectedDate)
                            print("days-------->4",dayString, selectedDate.selectedDate, "::",days)
                            if days.contains(dayString.lowercased()) {
                                
                                self.showSelectedDatArr.append(selectedDate)
                            }else {
                                
                                print("unselected day ",dayString)
                            }
                        }
                    }
                    else {
                        self.showSelectedDatArr.append(selectedDate)
                    }
                    
                    
                }
            }else {
                let title = self.weekDayAndMonthArr[sender.tag].titleName
                self.monthStringArr.removeAll { $0 == title }
                self.showSelectedDatArr.removeAll()
                self.selectedDatesArr.forEach { selectedDate in
                    if self.monthStringArr.count > 0 {
                        self.monthStringArr.forEach { dayString in
                            let days = CEnumClass.share.getWeekDaysName(date: selectedDate.selectedDate)
                            print("days-------->3",dayString, selectedDate.selectedDate, "::",days)
                            if days.contains(dayString.lowercased()) {
                                
                                self.showSelectedDatArr.append(selectedDate)
                            }
                            else {
                                print("unselected month ",dayString)
                            }
                        }
                    }
                    else {
                        self.showSelectedDatArr.append(selectedDate)
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
                        
                        
                        let days = CEnumClass.share.getWeekDaysName(date: selectedDate.selectedDate)
                        print("days-------->1",dayString, selectedDate.selectedDate, "::",days)
                        if days.contains(dayString.lowercased()) {
                            showSelectedDatArr.append(selectedDate)
                        }
                        else {
                            
                        }}
                }
            }else {
                self.monthStringArr.append(self.weekDayAndMonthArr[sender.tag].titleName)
                self.showSelectedDatArr.removeAll()
                self.selectedDatesArr.forEach { selectedDate in
                    self.monthStringArr.forEach { dayString in
                        let days = CEnumClass.share.getWeekDaysName(date: selectedDate.selectedDate)
                        print("days-------->2",dayString, selectedDate.selectedDate, "::",days)
                        if days.contains(dayString.lowercased()) {
                            showSelectedDatArr.append(selectedDate)
                        }
                        else {
                            
                        }
                    }
                }
            }
        }
        self.datesTV.reloadData()
        self.weekCv.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: 34)
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
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dayString = dateFormatter.string(from: selectedDate)
        cell.titledate.text = "\(dayString) \(appointmentStartTime!) - \(dayString) \(AppointmentEndTIme!)"
        return cell
    }
}
