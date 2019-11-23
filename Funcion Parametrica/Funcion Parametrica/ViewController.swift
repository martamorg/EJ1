//
//  ViewController.swift
//  Funcion Parametrica
//
//  Created by Santiago Pavón Gómez on 07/11/2019.
//  Copyright © 2019 IWEB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ParametricFunctionViewDataSource  {

    @IBOutlet weak var parametricFunctionView: ParametricFunctionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parametricFunctionView.dataSource = self
    }

    
    // MARK: - ParametricFunctionViewDataSource
    
    func startIndexFor(_ functionView: ParametricFunctionView) -> Double {
            return 0
    }
    
    func endIndexFor(_ functionView: ParametricFunctionView) -> Double {
            return 35
    }
    
    func functionView(_ functionView: ParametricFunctionView, pointAt index: Double) -> FunctionPoint {
        
        let x = 100 * sin(0.4 * index)
        let y = 175 * cos(0.6 * index)
        return FunctionPoint(x: x, y: y)
    }
}

