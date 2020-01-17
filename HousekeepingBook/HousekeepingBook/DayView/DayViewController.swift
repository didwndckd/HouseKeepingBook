import UIKit

class DayViewController: UIViewController {
    private let budgetLabel = UILabel()
    private let plusButton = UIButton()
    private lazy var tableView = UITableView(frame: .zero)
    private var date = Date()
    private var baseBudget: Int?
    private var budget = 0 {
        didSet {
            guard let _ = baseBudget else {
                budgetLabel.text = "예산을 설정하세요."
                return
            }
            guard let text = DataPicker.shared.moneyForamt(price: budget) else { return }
            budgetLabel.text = "\(text) 원"
        }
    }
    
    var costData: [CostModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MyColors.lightgray
        baseUI()
        layout()
        costData = DataPicker.shared.getData(date: Date())
        tableView.rowHeight = 60
        setBudget()
    }
    
    private func setBudget() {
        
        
        budget = baseBudget ?? 0
        for data in costData {
            budget -= data.price
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
//        let monthBudget = DataPicker.shared.getMonthBudget(month: Date())
//        let days = DataPicker.shared.howManyDaysInMonth(date: Date())
//
//        guard monthBudget != 0 else { return }
//        guard let count = days else { return }
//
//        let budget = monthBudget / count
//        baseBudget = budget
//        self.budget = budget
        
        let monthBudget = DataPicker.shared.getMonthBudget(month: Date())
        let days = DataPicker.shared.howManyDaysInMonth(date: Date())
        
        guard let mBudget = monthBudget else { return }
        guard let count = days else { return }
        
        let budget = mBudget / count
        baseBudget = budget
        self.budget = budget
        
        // - [ ] budget 값이 바뀔 때마다 색 변경해야 함
        
//        print(monthBudget, count)
        
        
    }
    
  @objc func plusButtonAction(button: UIButton) {
    
            let dayCostViewController = DayCostViewController()
            dayCostViewController.delegate = self
            present(dayCostViewController, animated: true)
    
    
  }
  
    private func baseUI() {
        // MARK: - BackgroundColor
        budgetLabel.backgroundColor = MyColors.yellow
        tableView.backgroundColor = .white
        plusButton.backgroundColor = MyColors.yellow
        
        // MARK: - Label UI
        budgetLabel.text = "\(budget)"
        budgetLabel.textAlignment = .center
        budgetLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        
        // MARK: - TableView UI
        tableView.register(DayViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        
        // MARK: - Button UI
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        plusButton.layer.cornerRadius = 40
        plusButton.layer.shadowOpacity = 0.5
        plusButton.layer.shadowColor = ColorZip.midiumGray.cgColor
        plusButton.layer.shadowRadius = 4
        plusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        plusButton.addTarget(self, action: #selector(plusButtonAction(button:)), for: .touchUpInside)
        
        // MARK: - AddSubView
        view.addSubview(budgetLabel)
        view.addSubview(tableView)
        view.addSubview(plusButton)
    }
    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
        let uiArr = [budgetLabel, plusButton, tableView]
        for ui in uiArr {
            ui.translatesAutoresizingMaskIntoConstraints = false
            if ui != plusButton {
                ui.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
                ui.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
            }
        }
        budgetLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        budgetLabel.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4).isActive = true
        
        tableView.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10).isActive = true
    
        plusButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor).isActive = true
    }
}
extension DayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return costData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DayViewCell
        
        if let biningCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DayViewCell {
            cell = biningCell
        }else {
            cell = DayViewCell(style: .default, reuseIdentifier: "cell")
            
        }
        let key = costData[indexPath.row].tag
        let name = TagData.tags[key]?.name
        cell.textLabel?.text = name
        return cell
        
    }
}

extension DayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let costDetailViewController = CostDetailViewController()
        costDetailViewController.modalPresentationStyle = .overFullScreen
        present(costDetailViewController, animated: true)
    }
}

extension DayViewController: DayCostViewControllerDelegat {
    func checkAction(cost: CostModel) {
        costData.append(cost)
        tableView.reloadData()
        DataPicker.shared.setData(date: date, datas: costData)
        setBudget()
    }
}
