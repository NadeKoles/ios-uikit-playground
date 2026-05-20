//  ViewController.swift


import UIKit

class ViewController: UIViewController {
    let myView = RoundedView()
    let sliderCornerRadius = UISlider()
    let sliderBorderWidth  = UISlider()
    let labelCornerRadius = UILabel()
    let labelBorderWidth = UILabel()
    let colorSegmentedControl = UISegmentedControl(items: ["Yellow", "Cyan", "Pink"])
    let switchModeControl = UISwitch()
    let labelBugMode = UILabel()
    
    enum colorForView {
        case yellow, cyan, pink
        
        var mainColor: UIColor {
            switch self {
            case .yellow: return .yellow
            case .cyan: return .cyan
            case .pink: return .systemPink
            }
        }
            
        var borderColor: UIColor {
            switch self {
            case .yellow: return .systemYellow
            case .cyan: return .systemTeal
            case .pink: return .orange
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        [myView, sliderCornerRadius, sliderBorderWidth, labelCornerRadius, labelBorderWidth,
         colorSegmentedControl, switchModeControl, labelBugMode]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        view.addSubview(myView)
        view.addSubview(colorSegmentedControl)
        view.addSubview(sliderCornerRadius)
        view.addSubview(labelCornerRadius)
        view.addSubview(sliderBorderWidth)
        view.addSubview(labelBorderWidth)
        view.addSubview(switchModeControl)
        view.addSubview(labelBugMode)
        
        NSLayoutConstraint.activate([
            myView.widthAnchor.constraint(equalToConstant: 200),
            myView.heightAnchor.constraint(equalToConstant: 200),
            myView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])

        NSLayoutConstraint.activate([
            colorSegmentedControl.widthAnchor.constraint(equalToConstant: 300),
            colorSegmentedControl.heightAnchor.constraint(equalToConstant: 30),
            colorSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorSegmentedControl.topAnchor.constraint(equalTo: myView.bottomAnchor, constant: 24)
        ])

        NSLayoutConstraint.activate([
            labelCornerRadius.widthAnchor.constraint(equalToConstant: 300),
            labelCornerRadius.heightAnchor.constraint(equalToConstant: 20),
            labelCornerRadius.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelCornerRadius.topAnchor.constraint(equalTo: colorSegmentedControl.bottomAnchor, constant: 24)
        ])

        NSLayoutConstraint.activate([
            sliderCornerRadius.widthAnchor.constraint(equalToConstant: 300),
            sliderCornerRadius.heightAnchor.constraint(equalToConstant: 20),
            sliderCornerRadius.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderCornerRadius.topAnchor.constraint(equalTo: labelCornerRadius.bottomAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            labelBorderWidth.widthAnchor.constraint(equalToConstant: 300),
            labelBorderWidth.heightAnchor.constraint(equalToConstant: 20),
            labelBorderWidth.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelBorderWidth.topAnchor.constraint(equalTo: sliderCornerRadius.bottomAnchor, constant: 24)
        ])

        NSLayoutConstraint.activate([
            sliderBorderWidth.widthAnchor.constraint(equalToConstant: 300),
            sliderBorderWidth.heightAnchor.constraint(equalToConstant: 20),
            sliderBorderWidth.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderBorderWidth.topAnchor.constraint(equalTo: labelBorderWidth.bottomAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            labelBugMode.widthAnchor.constraint(equalToConstant: 150),
            labelBugMode.heightAnchor.constraint(equalToConstant: 20),
            labelBugMode.leadingAnchor.constraint(equalTo: sliderBorderWidth.leadingAnchor),
            labelBugMode.topAnchor.constraint(equalTo: sliderBorderWidth.bottomAnchor, constant: 24)
        ])

        NSLayoutConstraint.activate([
            switchModeControl.trailingAnchor.constraint(equalTo: sliderBorderWidth.trailingAnchor),
            switchModeControl.centerYAnchor.constraint(equalTo: labelBugMode.centerYAnchor)
        ])
        
        sliderCornerRadius.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sliderCornerRadius.minimumValue = 0
        sliderCornerRadius.maximumValue = 100
        sliderCornerRadius.value = 25
        sliderValueChanged(sliderCornerRadius)
        
        sliderBorderWidth.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sliderBorderWidth.minimumValue = 0
        sliderBorderWidth.maximumValue = 10
        sliderBorderWidth.value = 4
        sliderValueChanged(sliderBorderWidth)
        
        labelCornerRadius.textColor = .white
        labelBorderWidth.textColor = .white
        labelBugMode.textColor = .white
        
        colorSegmentedControl.addTarget(self, action: #selector(colorSegmentChanged(_:)), for: .valueChanged)
        colorSegmentedControl.selectedSegmentIndex = 0
        colorSegmentChanged(colorSegmentedControl)
        
        switchModeControl.addTarget(self, action: #selector(switchModeChanged(_:)), for: .valueChanged)
        switchModeControl.onTintColor = .systemBlue
        switchModeChanged(switchModeControl)
    }
    
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        myView.cornerRadius = CGFloat(sliderCornerRadius.value)
        myView.borderWidth = CGFloat(sliderBorderWidth.value)
        labelCornerRadius.text = "Corner Radius: \(Int(sliderCornerRadius.value))"
        labelBorderWidth.text = "Border Width: \(Int(sliderBorderWidth.value))"
        myView.setNeedsLayout()
    }
    
    @objc func colorSegmentChanged(_ sender: UISegmentedControl) {
        guard sender.selectedSegmentIndex >= 0 else { return }
        let colors: [colorForView] = [.yellow, .cyan, .pink]
        let color = colors[sender.selectedSegmentIndex]
        myView.mainColor = color.mainColor
        myView.borderColor = color.borderColor
        colorSegmentedControl.backgroundColor = color.mainColor
        myView.setNeedsLayout()
    }
    
    @objc func switchModeChanged(_ sender: UISwitch) {
        myView.isBugMode = sender.isOn
        if sender.isOn {
            myView.applyInBugMode()
            labelBugMode.text = "Bug mode: ON"
        } else {
            labelBugMode.text = "Bug mode: OFF"
        }
        myView.setNeedsLayout()
    }

}

