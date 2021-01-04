//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    var day: Day? {
        didSet {
            guard let day = day else { return }
            dayLabel.text = day.number
            weekday.text = day.date.weekdayName
        }
    }

    override var isSelected: Bool {
        didSet {
            guard let day = day else { return }
            if isSelected {
                applySelectedStyle()
            } else {
                applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
            }
        }
    }

    func applySelectedStyle() {
        accessibilityTraits.insert(.selected)
        accessibilityHint = nil

        dayLabel.textColor = .white
        dayView.backgroundColor = .daySelected
    }

    func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
        accessibilityTraits.remove(.selected)
        accessibilityHint = "Tap to select"

        dayLabel.textColor = .white
        dayView.backgroundColor = .clear
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }

    override func prepareForReuse() {
        dayLabel.text = nil
        weekday.text = nil
    }
    
}
