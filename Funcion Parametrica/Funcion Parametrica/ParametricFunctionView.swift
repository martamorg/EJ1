//
//  ParametricFunctionView.swift
//  Funcion Parametrica
//
//  Created by Santiago Pavón Gómez on 07/11/2019.
//  Copyright © 2019 IWEB. All rights reserved.
//

import UIKit

struct FunctionPoint {
    var x = 0.0
    var y = 0.0
}

// El objeto que se use como DataSource debe ser conforme
// con este protocolo.
protocol ParametricFunctionViewDataSource: class {
    func startIndexFor(_ functionView: ParametricFunctionView) -> Double
    func endIndexFor(_ functionView: ParametricFunctionView) -> Double
    func functionView(_ functionView: ParametricFunctionView, pointAt index: Double) -> FunctionPoint
}


@IBDesignable
class ParametricFunctionView: UIView {
    
    @IBInspectable
    var lineWidth : Double = 1.0
    
    @IBInspectable
    var trajectoryColor : UIColor = UIColor.red
    
    // Numero de puntos a pintar
    @IBInspectable
    var resolucion : Double = 250
    
    // DataSource falso usado solo para que Interface Builder
    // pinte una curva de ejemplo.
    var fakeDataSource: ParametricFunctionViewDataSource!
    
    // Metodo que solo usa IB durnte el desarrollo.
    // Crear un objeto DataSource falso y asignarlo a dataSource.
    override func prepareForInterfaceBuilder() {
        
        class FakeDataSource: ParametricFunctionViewDataSource {
            
            func startIndexFor(_ functionView: ParametricFunctionView) -> Double {return -1.0}
            
            func endIndexFor(_ functionView: ParametricFunctionView) -> Double {return 1.0}
            
            func functionView(_ functionView: ParametricFunctionView, pointAt index: Double) -> FunctionPoint {
                return FunctionPoint(x: 200*index, y: 200*index)
            }
        }
        
        fakeDataSource = FakeDataSource()
        dataSource = fakeDataSource
    }
    
    // Asignar a este parametro el objeto que proporcionara los punto a pintar.
    weak var dataSource: ParametricFunctionViewDataSource!

    // MARK: - Funciones de pintar:
    
    override func draw(_ rect: CGRect) {
        drawAxis()
        drawTrajectory()
    }
    
    private func drawAxis() {
        
        let width = bounds.size.width
        let height = bounds.size.height
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: width/2, y: 0))
        path1.addLine(to: CGPoint(x: width/2, y: height))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: height/2))
        path2.addLine(to: CGPoint(x: width, y: height/2))
        
        UIColor.black.setStroke()
        
        path1.lineWidth = 1
        path1.stroke()
        path2.lineWidth = 1
        path2.stroke()
    }
    
        
    private func drawTrajectory() {
        
        if dataSource == nil {
            return
        }
        
        let startTime = dataSource.startIndexFor(self)
        let endTime = dataSource.endIndexFor(self)
        let incrTime = abs(startTime - endTime)/resolucion
        
        let path = UIBezierPath()
        
        var point = dataSource.functionView(self, pointAt: startTime)
        var px = pointForX(point.x)
        var py = pointForY(point.y)
        path.move(to: CGPoint(x: px, y: py))
        
        for t in stride(from: startTime, to: endTime, by: incrTime) {
            point = dataSource.functionView(self, pointAt: t)
            px = pointForX(point.x)
            py = pointForY(point.y)
            path.addLine(to: CGPoint(x: px, y: py))
        }
        
        point = dataSource.functionView(self, pointAt: endTime)
        px = pointForX(point.x)
        py = pointForY(point.y)
        path.move(to: CGPoint(x: px, y: py))
        
        path.lineWidth = CGFloat(lineWidth)
        
        trajectoryColor.set()
        
        path.stroke()
    }
    
    // MARK: - Cambio el origen de coordenadas al centro de la view:
    
    private func pointForX(_ x: Double) -> CGFloat {
        
        let width = bounds.size.width
        return width/2 + CGFloat(x)
    }
    
    private func pointForY(_ y: Double) -> CGFloat {
        
        let height = bounds.size.height
        return height/2 - CGFloat(y)
    }
}

