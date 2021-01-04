//
//  HomeTableViewCell.swift
//  Calendar
//
//  Test Project
//

import UIKit
import CoreLocation

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tasks: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var timeRequired: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    var model: VisitModel? {
        didSet {
            updateDetails()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 10.0
        self.statusView.layer.cornerRadius = self.status.frame.height / 2.0
        self.statusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    private func updateDetails() {
        guard let model = model else { return }
        customer.text = model.visit.fullName

        if let timeString = model.visit.startTimeUTC.toTimeString {
            if let expectedTime = model.visit.expectedTime {
                arrivalTime.text = timeString + " / \(expectedTime)"
            } else {
                arrivalTime.text = timeString
            }
        }

        destination.text = model.visit.fullAddress
        distance.text = "\(model.distance) Km"
        let seconds = model.visit.tasks.sum(\.timesInMinutes) * 60
        let (h,m) = secondsToHoursMinutesSeconds(seconds)
        timeRequired.text = h > 0 ? "\(h):\(m) Hr" : "\(m) Min"
        statusView.backgroundColor = model.visit.visitState.color
        status.text = model.visit.visitState.name
        let tasksTitles = model.visit.tasks.compactMap { $0.title }
        tasks.text = tasksTitles.joined(separator: ",")
    }

    private func secondsToHoursMinutesSeconds (_ seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
}
