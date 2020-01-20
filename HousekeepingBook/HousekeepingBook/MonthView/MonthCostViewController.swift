//
//  MonthCostViewController.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol MonthCostViewControllerDelegate: class {
    func reLoadCalendar()
}

// 월별 추가버튼 클릭시
class MonthCostViewController: UIViewController {
  
  // MARK: - Property
    
    weak var delegate: MonthCostViewControllerDelegate?
    var datas: [CostModel] = []
    var date: Date?
    var budget: Int = 0 {
        willSet{
            let text = DataPicker.shared.moneyForamt(price: newValue)
            moneyLabel.text = text
        }
    }

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
    tableView.rowHeight = 65
    tableView.layer.cornerRadius = 17

    tableView.separatorStyle = .none
    return tableView
  }()
  
  let dateLabel: UILabel = {
    let dateLabel = UILabel()
    dateLabel.backgroundColor = ColorZip.midiumBlue
    dateLabel.textColor = .white
    dateLabel.text = "2010. 01. 15 Sun"
    dateLabel.textAlignment = .center
    return dateLabel
  }()
  
  let moneyLabel: UILabel = {
    let moneyLabel = UILabel()
    moneyLabel.backgroundColor = .white
    moneyLabel.textColor = ColorZip.midiumGray
    moneyLabel.text = "0원"
    moneyLabel.textAlignment = .center
    moneyLabel.font = UIFont.systemFont(ofSize: 40)
    return moneyLabel
  }()
  
  let moneyLine: UIView = {
    let moneyLine = UIView()
    moneyLine.backgroundColor = ColorZip.midiumPink
    return moneyLine
  }()
  
  let checkButton: UIButton = {
    let checkButton = UIButton()
    checkButton.setTitle("+", for: .normal)
    checkButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
    checkButton.layer.shadowOpacity = 0.5
    checkButton.layer.shadowColor = ColorZip.midiumGray.cgColor
    checkButton.layer.shadowRadius = 4
    checkButton.layer.shadowOffset = CGSize(width: 4, height: 4)
    checkButton.backgroundColor = MyColors.yellow
    checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
    return checkButton
  }()
    
    @objc func didTapCheckButton() {
        print("MonthCostViewController: didTapCheckButton()")
        let dayCostViewController = DayCostViewController()
        dayCostViewController.delegate = self
        present(dayCostViewController, animated: true)
    }
  
    
//  private func setBudget() {
//    guard let date = date else { return }
//      if var budget = DataPicker.shared.getDalyBudget(date: date) {
//
//          for i in DataPicker.shared.getData(date: date) {
//              budget -= i.price
//          }
//          self.budget = budget
//      }
//
//  }
  
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    if let date = date {
        dateLabel.text = DataPicker.shared.getDateTitleForamt(date: date)
        datas = DataPicker.shared.getData(date: date)
        
    }
    
    setUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    print("MonthCostViewController ViewWillAppear")
    setBudget()
  }
  
    private func setBudget() {
        guard let date = date else { return }
        if var budget = DataPicker.shared.getDalyBudget(date: date) {
            
            for i in DataPicker.shared.getData(date: date) {
                budget -= i.price
            }
            self.budget = budget
        }
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.reLoadCalendar()
    }
  
  func setUI() {
    
    let guide = view.safeAreaLayoutGuide
    view.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: Standard.space),
      dateLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      dateLabel.widthAnchor.constraint(equalToConstant: 150),
    ])
    
    view.addSubview(moneyLabel)
    moneyLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moneyLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Standard.space),
      moneyLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      moneyLabel.widthAnchor.constraint(equalToConstant: 250),
    ])
    
    view.addSubview(moneyLine)
    moneyLine.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moneyLine.bottomAnchor.constraint(equalTo: moneyLabel.bottomAnchor),
      moneyLine.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      moneyLine.widthAnchor.constraint(equalToConstant: 250),
      moneyLine.heightAnchor.constraint(equalToConstant: 1),
    ])
    
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
    tableView.topAnchor.constraint(equalTo: moneyLine.bottomAnchor, constant: Standard.space),
    tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Standard.space),
    tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Standard.space),
    tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -250)
    ])
    
    view.addSubview(checkButton)
    checkButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Standard.space),
      checkButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      checkButton.widthAnchor.constraint(equalTo: checkButton.heightAnchor),
    ])
  }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        checkButton.layer.cornerRadius = checkButton.bounds.width / 2
    }
  
  private struct Standard {
    static let space: CGFloat = 30
  }
  
}

extension MonthCostViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datas.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCell {
        let data = datas[indexPath.row]
        cell.titlelabel.text = data.memo
        let price = DataPicker.shared.moneyForamt(price: data.price)
        cell.priceLabel.text = price
        cell.iconView.backgroundColor = TagData.tags[data.tag]?.color
        cell.iconView.text = TagData.tags[data.tag]?.name
        
        return cell
    }else {
        
        let data = datas[indexPath.row]
        let cell = CustomCell(style: .default, reuseIdentifier: "cell")
        
        cell.titlelabel.text = data.memo
        let price = DataPicker.shared.moneyForamt(price: data.price)
        cell.priceLabel.text = price
        cell.iconView.backgroundColor = TagData.tags[data.tag]?.color
        cell.iconView.text = TagData.tags[data.tag]?.name
    
        return cell
        
    }
    
    
  }
}
extension MonthCostViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath.row)
    let cost = CostDetailViewController()
    cost.delegate = self
    let data = datas[indexPath.row]
    cost.date = date
    cost.price = data.price
    cost.memo = data.memo
    cost.tag = data.tag
    cost.position = indexPath
    cost.delegate = self
    
    cost.modalPresentationStyle = .overFullScreen
    present(cost, animated: true)
  }




}


extension MonthCostViewController: CostDetailViewControllerDelegate {
    
   func updateActiom(position: IndexPath?, data: CostModel) {
        guard let indexPath = position else { return }
        guard let date = date else { return }
        datas[indexPath.row] = data
        tableView.reloadRows(at: [indexPath], with: .automatic)
        DataPicker.shared.setData(date: date, datas: datas)
        setBudget()
    }
    
    func deleteAction(position: IndexPath?, price: Int) {
        guard let i = position else { return }
        guard let date = date else { return }
        datas.remove(at: i.row)
        tableView.deleteRows(at: [i], with: .automatic)
        DataPicker.shared.setData(date: date, datas: datas)
        setBudget()
    }
    
    
}


extension MonthCostViewController: DayCostViewControllerDelegat {
    func checkAction(cost: CostModel) {
        datas.append(cost)
        tableView.reloadData()
        
        guard let date = date else {return print("MonthCostViewController: no date")}
        print(date)
        DataPicker.shared.setData(date: date, datas: datas)
        setBudget()
    }
    
    
}



