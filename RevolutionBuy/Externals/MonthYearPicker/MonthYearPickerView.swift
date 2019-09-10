//
//  MonthYearPicker.swift
//
//  Created by Ben Dodson on 15/04/2015.
//

import UIKit

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var years: [Int]!

    var month: Int = 0 {
        didSet {
            selectRow(month - 1, inComponent: 0, animated: false)
        }
    }

    var year: Int = 0 {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }

    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }

    func commonSetup() {
        var yearsArray: [Int] = []
        if yearsArray.count == 0 {

            var yearIterated = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for (index) in yearIterated ... yearIterated + 20 {
                yearsArray.append(index)
                yearIterated += index
            }
        }
        self.years = yearsArray

        self.delegate = self
        self.dataSource = self

        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        self.selectRow(0, inComponent: 1, animated: false)

        let selectedMonth = self.selectedRow(inComponent: 0) + 1
        let selectedYear = years[self.selectedRow(inComponent: 1)]
        self.month = selectedMonth
        self.year = selectedYear
    }

    // Mark: UIPicker Delegate / Data Source

    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }

    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        let selectedMonth = self.selectedRow(inComponent: 0) + 1
        let selectedYear = years[self.selectedRow(inComponent: 1)]

        if currentYear == selectedYear && currentMonth > selectedMonth {
            self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
            return
        }

        let monthSelected = self.selectedRow(inComponent: 0) + 1
        let yearSelected = years[self.selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            block(monthSelected, yearSelected)
        }

        self.month = monthSelected
        self.year = yearSelected
    }
}
