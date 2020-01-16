import UIKit
// tab-bar-tag-0: 일별, 오늘 지출 내역 추가 컨트롤러
class DayViewController: UIViewController {
    private let budgetLabel = UILabel()
    private let plusButton = UIButton()
    private lazy var tableView = UITableView(frame: .zero)
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
        baseUI()
        layout()
        costData = DataPicker.shared.getData(date: Date())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let monthBudget = DataPicker.shared.getMonthBudget(month: Date())
        let days = DataPicker.shared.howManyDaysInMonth(date: Date())

        guard monthBudget != 0 else { return }
        guard let count = days else { return }
        
        let budget = monthBudget / count
        baseBudget = budget
        self.budget = budget
        
        print(monthBudget, count)
        
        
    }
    
    @objc func plusButtonAction(button: UIButton) {
        
        let dayCostViewController = DayCostViewController()
        dayCostViewController.delegate = self
        present(dayCostViewController, animated: true)
        
    }
    private func baseUI() {
        budgetLabel.backgroundColor = ColorZip.midiumBlue
        plusButton.backgroundColor = ColorZip.lightGray
        tableView.backgroundColor = ColorZip.lightYellow
        budgetLabel.text = "\(budget)"
        budgetLabel.textAlignment = .center
        budgetLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
//        budgetLabel.layer.masksToBounds = true
        budgetLabel.layer.shadowOpacity = 0.5
        budgetLabel.layer.shadowColor = ColorZip.midiumGray.cgColor
        budgetLabel.layer.shadowRadius = 4
        budgetLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        plusButton.addTarget(self, action: #selector(plusButtonAction(button:)), for: .touchUpInside)
//        plusButton.layer.cornerRadius = 17
        plusButton.layer.shadowOpacity = 0.5
        plusButton.layer.shadowColor = ColorZip.midiumGray.cgColor
        plusButton.layer.shadowRadius = 4
        plusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        tableView.register(DayViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.rowHeight = 70
//        tableView.layer.cornerRadius = 17
        plusButton.layer.shadowOpacity = 0.5
        plusButton.layer.shadowColor = ColorZip.midiumGray.cgColor
        plusButton.layer.shadowRadius = 4
        plusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.addSubview(budgetLabel)
        view.addSubview(plusButton)
        view.addSubview(tableView)
    }
    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
        let uiArr = [budgetLabel, plusButton, tableView]
        for ui in uiArr {
            ui.translatesAutoresizingMaskIntoConstraints = false
            ui.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
            ui.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        }
        budgetLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        budgetLabel.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3).isActive = true
        plusButton.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: 10).isActive = true
        plusButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.1).isActive = true
        tableView.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10).isActive = true
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

extension DayViewController: DayCostViewControllerDelegat {
    func checkAction(cost: CostModel) {
        costData.append(cost)
        tableView.reloadData()
        DataPicker.shared.setData(date: Date(), datas: costData)
    }
    
    

    
    
}
