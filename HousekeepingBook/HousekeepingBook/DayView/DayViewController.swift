import UIKit

class DayViewController: UIViewController {
    private let budgetLabel = UILabel()
    private let plusButton = UIButton()
    private lazy var tableView = UITableView(frame: .zero)
    private var date = Date()
    private var budget: Int = 0 {
        willSet {
            let formatter = DataPicker.shared.moneyForamt(price: newValue)
            budgetLabel.text = formatter
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
    }
    
    private func setBudget() {
        if var budget = DataPicker.shared.getDalyBudget(date: date) {
            
            for i in DataPicker.shared.getData(date: date) {
                budget -= i.price
            }
            self.budget = budget
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        costData = DataPicker.shared.getData(date: date)
        tableView.reloadData()
        setBudget()
        print("DayViewController: ViewWillAppear")
        
        
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
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let data = costData[indexPath.row]
        cell.titlelabel.text = data.memo
        let price = DataPicker.shared.moneyForamt(price: data.price)
        cell.priceLabel.text = price
        cell.iconView.backgroundColor = TagData.tags[data.tag]?.color
        cell.iconView.text = TagData.tags[data.tag]?.name
        
        return cell
        
    }
}

extension DayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let costDetailViewController = CostDetailViewController()
        costDetailViewController.delegate = self
        costDetailViewController.modalPresentationStyle = .overFullScreen
        costDetailViewController.tag = costData[indexPath.row].tag
        costDetailViewController.memo = costData[indexPath.row].memo
        costDetailViewController.price = costData[indexPath.row].price
        costDetailViewController.position = indexPath
        costDetailViewController.date = date
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

extension DayViewController: CostDetailViewControllerDelegate {
    func updateActiom(position: IndexPath?, data: CostModel) {
        guard let indexPath = position else { return }
        costData[indexPath.row] = data
        tableView.reloadRows(at: [indexPath], with: .automatic)
        DataPicker.shared.setData(date: date, datas: costData)
        setBudget()
    }
    
    func deleteAction(position: IndexPath?, price: Int) {
        guard let i = position else { return }
        costData.remove(at: i.row)
        tableView.deleteRows(at: [i], with: .automatic)
        DataPicker.shared.setData(date: date, datas: costData)
        setBudget()
    }
    
    
}
