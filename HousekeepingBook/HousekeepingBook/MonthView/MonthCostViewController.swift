//
//  MonthCostViewController.swift
//  HousekeepingBook
//
//  Created by 은영김 on 2020/01/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// 월별 추가버튼 클릭시
class MonthCostViewController: UIViewController {
  
  // MARK: - Property
  
    var datas: [CostModel] = []
    var date: Date?
    var budget: Int? {
        didSet {
            guard let budget = budget else {
                moneyLabel.text = "예산 미등록."
                return
            }
            let text = DataPicker.shared.moneyForamt(price: budget)
            if let text = text {
            moneyLabel.text = "\(text) 원"
            }
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
    checkButton.setTitle(" Check ", for: .normal)
    checkButton.setTitleColor(.white, for: .normal)
    checkButton.backgroundColor = ColorZip.lightGray
    //    checkButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    checkButton.titleLabel?.font = UIFont(name: "Arial", size: 25)
    checkButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    checkButton.layer.cornerRadius = 10
    return checkButton
  }()
  
  
  
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    if let date = date {
        dateLabel.text = DataPicker.shared.getDateTitleForamt(date: date)
        datas = DataPicker.shared.getData(date: date)
        budget = DataPicker.shared.getDalyBudget(date: date)
    }
    
    if var budget = budget {
        for data in datas {
            budget -= data.price
        }
        self.budget = budget
    }
    
    setUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
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
    ])
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
    //        present(상세 컨트롤러, animated: true)
    // 선택 된 indexPath 로 값을 넘긴다.
  }
}
