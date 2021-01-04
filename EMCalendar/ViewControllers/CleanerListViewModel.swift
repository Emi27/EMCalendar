//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by imran malik on 24/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

protocol CleanerListUIDelegate: AnyObject {
    func reloadData()
}

protocol CleanerListProtocol {
    func numberOfRows() -> Int
    func carwash(at indexPath: IndexPath) -> VisitModel?
    func didSelect(carwashAt indexPath: IndexPath)
    func filter(for date: Date)
}

class CleanerListViewModel {

    private var carwashVisit: [CarwashVisit] = [] {
        didSet {
            filter(for: Date())
        }
    }

    private var filteredVisitList: [CarwashVisit] = []

    weak var delegate: CleanerListUIDelegate?

    // MARK: - Initializer
    init() {
        fetchCarwashData()
    }

    // MARK: - Fetching json data and assigning to corresponsing model array
    private func fetchCarwashData() {
        JSONParser.loadJSON(of: Response<[CarwashVisit]>.self, name: "carfit") { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let response):
                guard response.code == 200 else {
                    print(response.message ?? "Status code recieved \(response.code ?? 0)")
                    return
                }
                weakSelf.carwashVisit = response.data
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}

//MARK: - CleanerListViewModel Datasource
extension CleanerListViewModel: CleanerListProtocol {
    func numberOfRows() -> Int {
        filteredVisitList.count
    }

    func carwash(at indexPath: IndexPath) -> VisitModel? {
        modelFor(rowAt: indexPath)
    }

    /// Creates VisitModel for each given row
    /// - Parameter indexPath: indexPath for the row, for which we need to create a model
    /// - Returns: It returns a fully initialized VisitModel for the corresposnding indexPath
    private func modelFor(rowAt indexPath: IndexPath) -> VisitModel? {
        if let visit = filteredVisitList.safelyAt(index: indexPath.row) {
            if indexPath.row == 0 { // If it's first visit, I'm assuming the distance to be 0
                return VisitModel(visit: visit, distance: 0)
            } else if let previousVisit = filteredVisitList.safelyAt(index: indexPath.row - 1) {
                //Calculating distance from previous visit location here using distanceFrom extension
                return VisitModel(visit: visit, distance: visit.distanceFrom(previousVisit))
            }
        }
        return nil
    }
}

//MARK: - CleanerListViewModel Actions
extension CleanerListViewModel {
    func didSelect(carwashAt indexPath: IndexPath) {

    }

    /// To filter the array of objects according to the date
    /// - Parameter date: by which we want to filter the array
    func filter(for date: Date) {
        filteredVisitList = carwashVisit.filter { $0.startTimeUTC.isSame(to: date) }
        delegate?.reloadData()
    }
}

struct VisitModel {
    let visit: CarwashVisit
    let distance: Double
}
