//
//  CalendarTVCell.swift
//  TLClientApp
//
//  Created by Naiyer on 8/15/21.
//

import UIKit
import FSCalendar

enum HomeCellIdentifier: String {
    case calendarTVCell = "CalendarTVCell"
}
class CalendarTVCell: UITableViewCell, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var calenderView: FSCalendar!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        calenderView.delegate = self
        calenderView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
