import UIKit

// YearPickerManager.swift

final class YearPickerManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - Properties
    private var years: [Int] = []
    var selectedYear: Int?

    // MARK: - Initialization
    init(startYear: Int = 1990) {
        let currentYear = Calendar.current.component(.year, from: Date())
        self.years = Array(startYear...currentYear)
    }

    // MARK: - UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = years[row]
    }
    
    // MARK: - Helper Methods
    func availableYears() -> [Int] {
        return years
    }
}
