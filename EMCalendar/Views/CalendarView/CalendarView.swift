//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ date: Date)
}

class CalendarView: UIView {

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    let carFitCalendar = CarFitCalendar.shared

    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?

    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        carFitCalendar.delegate = self
        updateMonthLabel()
    }

    func updateMonthLabel() {
        monthAndYear.text = carFitCalendar.baseDate.monthWithYear
    }

    func scrollToToday(_ animation: Bool) {
        let indexPath = IndexPath(row: carFitCalendar.indexOfToday, section: 0)
        //self.daysCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        self.daysCollectionView.selectItem(at: indexPath, animated: animation, scrollPosition: .left)
    }

    //MARK:- Change month when left and right arrow button tapped
    @IBAction func leftArrowTapped(_ sender: UIButton) {
        carFitCalendar.lastMonth()
        scrollToToday(false)
    }

    @IBAction func rightArrowTapped(_ sender: UIButton) {
        carFitCalendar.nextMonth()
        scrollToToday(false)
    }
}

//MARK: - CarFit Calendar Delegate
extension CalendarView: CarFitCalendarProtocol {
    func reloadData() {
        self.daysCollectionView.reloadData()
        self.updateMonthLabel()
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carFitCalendar.days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        if let day = carFitCalendar.days.safelyAt(index: indexPath.row) {
            cell.day = day
            cell.isSelected = day.isSelected
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let day = carFitCalendar.days.safelyAt(index: indexPath.row) {
            carFitCalendar.selectedDate = day.date
            delegate?.getSelectedDate(day.date)
            scrollToToday(true)
        }
    }
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}
