//
//  ViewController.swift
//  CombineIntro
//
//  Created by Paulo Silva on 07/09/2021.
//
import Combine
import UIKit

class MyCustomTableCell: UITableViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // pass through subject, can happen multiple times
    let action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapButton() {
        action.send("Cool! Button was tapped")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 6)
        
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(MyCustomTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [String]()

    var observers: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        // call combine
        APICaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] value in
                self?.models = value
                self?.tableView.reloadData()
            }).store(in: &observers)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
            fatalError()
        }
        // this will return an observer
        cell.action.sink { string in
            print(string)
        }.store(in: &observers)
        return cell
    }
    

}

