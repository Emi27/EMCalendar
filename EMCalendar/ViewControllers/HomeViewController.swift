//
//  ViewController.swift
//  Calendar
//
//  Test Project
//

import UIKit

class HomeViewController: UIViewController, AlertDisplayer, UIGestureRecognizerDelegate {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var calendarView: UIView!
    @IBOutlet weak var calendar: UIView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var workOrderTableView: UITableView!
    @IBOutlet weak var calendarViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    private let cellID = "HomeTableViewCell"

    private lazy var viewModel: CleanerListViewModel? = {
        let viewModel = CleanerListViewModel()
        viewModel.delegate = self
        return viewModel
    }()


    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(hardReload), for: .valueChanged)
        return control
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    //MARK:- Add calender to view
    private func addCalendar() {
        if let calendar = CalendarView.addCalendar(self.calendar) {
            calendar.delegate = self
            calendar.scrollToToday(true)
        }
        calendarViewHieghtConstraint.constant = 0
    }

    //MARK:- UI setups
    private func setupUI() {
        self.navBar.transparentNavigationBar()
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.workOrderTableView.register(nib, forCellReuseIdentifier: self.cellID)
        self.workOrderTableView.rowHeight = UITableView.automaticDimension
        self.workOrderTableView.estimatedRowHeight = 170
        self.tableTopConstraint.constant = 0
        workOrderTableView.refreshControl = refreshControl

        let tap = UITapGestureRecognizer(target: self, action: #selector(onViewTap(_:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setTitle(nil)
    }

    //MARK:- Setup data
    private func setupData() {
        viewModel?.delegate = self
    }

    private func setTitle(_ title: String?) {
        navBar.topItem?.title = title ?? "Today"
    }

    @objc
    private func hardReload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK:- Show calendar when tapped, Hide the calendar when tapped outside the calendar view
    @IBAction func calendarTapped(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.3) {
            self.calendarViewHieghtConstraint.constant = 200
            self.tableTopConstraint.constant = 112
            self.view.layoutIfNeeded()
        }
    }

    //MARK: - Action on tap gesture
    @objc func onViewTap(_ gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.calendarViewHieghtConstraint.constant = 0
            self.tableTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: calendarView) == true {
            return false
        }
        return true
    }
}


//MARK:- Tableview delegate and datasource methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HomeTableViewCell
        if let model = viewModel?.carwash(at: indexPath) {
            cell.model = model
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- Get selected calendar date
extension HomeViewController: CalendarDelegate {
    func getSelectedDate(_ date: Date) {
        viewModel?.filter(for: date)
        let dayString = date.isSame(to: Date()) ? "Today" : date.fullDate
        setTitle(dayString)
    }
}

//MARK:- ViewModel's Delegate to reload table when some date selected
extension HomeViewController: CleanerListUIDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.workOrderTableView.reloadData()
        }
    }
}

