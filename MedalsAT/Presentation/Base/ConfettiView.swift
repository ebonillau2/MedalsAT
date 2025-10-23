//
//  ConfettiView.swift
//  Medals_AT
//
//  Created by Enrique Bonilla on 22/10/25.
//

import SwiftUI
import UIKit

struct ConfettiView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView(frame: .zero)
    let emitter = CAEmitterLayer()
    emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.midX, y: -10)
    emitter.emitterShape = .line
    emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 2)

    let colors: [UIColor] = [.systemRed, .systemBlue, .systemYellow, .systemGreen, .systemOrange, .systemPurple]
    var cells: [CAEmitterCell] = []
    for color in colors {
      let cell = CAEmitterCell()
      cell.birthRate = 8
      cell.lifetime = 4.0
      cell.velocity = 150
      cell.velocityRange = 50
      cell.emissionRange = .pi
      cell.spin = 3
      cell.spinRange = 3
      cell.scale = 0.15
      cell.scaleRange = 0.02
      cell.color = color.cgColor
      cell.contents = makeSquareImage().cgImage
      cells.append(cell)
    }
    emitter.emitterCells = cells
    view.layer.addSublayer(emitter)
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) { }

  private func makeSquareImage() -> UIImage {
    let size = CGSize(width: 10, height: 10)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.setFillColor(UIColor.white.cgColor)
    ctx.fill(CGRect(origin: .zero, size: size))
    let img = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return img
  }
}
