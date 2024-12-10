import UIKit

final class MoviesView: UIView {
    
    //MARK: - Private properties -
    
    private let tableView = UITableView()
    private let labelWithButtonContainer = UIView()
    private let titleLabel = UILabel()
    private let yearButton = UIButton()
    private let datePicker = UIPickerView()
    private let pickerButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var yearPickerButtonAction: (() -> Void)?
    
    
    //MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI -

private extension MoviesView {
    func setupUI() {
        addSubviews()
        makeConstraints()
        setupLabelWithButtonContainer()
        setupPickerButton()
        setupTitleLabel()
        setupYearButton()
        setupTableView()
        setupDatePicker()
        setupActivityIndicator()
        backgroundColor = .black
    }
    
    func addSubviews() {
        addSubview(labelWithButtonContainer)
        labelWithButtonContainer.addSubview(titleLabel)
        labelWithButtonContainer.addSubview(yearButton)
        addSubview(activityIndicator)
        addSubview(tableView)
        addSubview(datePicker)
        addSubview(pickerButton)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            labelWithButtonContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            labelWithButtonContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            labelWithButtonContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            labelWithButtonContainer.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerXAnchor.constraint(equalTo: labelWithButtonContainer.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: labelWithButtonContainer.centerYAnchor),
            
            yearButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 13),
            yearButton.centerYAnchor.constraint(equalTo: labelWithButtonContainer.centerYAnchor),
            yearButton.widthAnchor.constraint(equalToConstant: 20),
            yearButton.heightAnchor.constraint(equalToConstant: 20),
            
            tableView.topAnchor.constraint(equalTo: labelWithButtonContainer.bottomAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            datePicker.leftAnchor.constraint(equalTo: leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: rightAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 200),
            
            pickerButton.topAnchor.constraint(equalTo: datePicker.topAnchor, constant: 20),
            pickerButton.rightAnchor.constraint(equalTo: datePicker.rightAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 40)
        ])
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    func setupPickerButton() {
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        pickerButton.setTitle("Done", for: .normal)
        pickerButton.setTitleColor(.black, for: .normal)
        pickerButton.addTarget(self, action: #selector(pressYearPickerDoneButtonPress), for: .touchUpInside)
    }
    
    func setupLabelWithButtonContainer() {
        labelWithButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        labelWithButtonContainer.backgroundColor = .clear
        labelWithButtonContainer.layer.borderColor = UIColor.gray.cgColor
        labelWithButtonContainer.layer.borderWidth = 1
        labelWithButtonContainer.layer.cornerRadius = 5
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .gray
        titleLabel.text = "Выберите год релиза"
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
    }
    
    func setupYearButton() {
        yearButton.translatesAutoresizingMaskIntoConstraints = false
        yearButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        yearButton.backgroundColor = .clear
        yearButton.tintColor = #colorLiteral(red: 0.2640381753, green: 0.8696789742, blue: 0.8171131611, alpha: 1)
        yearButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.isHidden = true
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 15
    }
    
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .gray
    }
}

//MARK: - Public extension -

extension MoviesView {
    func setDelegateAndDataSource(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    func setPickerViewDelegateAndDataSource(delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource) {
        datePicker.delegate = delegate
        datePicker.dataSource = dataSource
        
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setTextTitleLabel(text: String) {
        titleLabel.text = text
    }
    
    func changeDate() {
        datePicker.isHidden = true
    }
    
    func refreshTableView(refresh: UIRefreshControl) {
        tableView.refreshControl = refresh
    }
    
    func showActivityIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

//MARK: - Private extension -
private extension MoviesView {
    @objc func showDatePicker() {
        datePicker.isHidden = false
    }
    
    @objc func pressYearPickerDoneButtonPress() {
        yearPickerButtonAction?()
    }
}
