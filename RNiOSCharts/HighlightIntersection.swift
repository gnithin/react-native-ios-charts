//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 19/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//  https://github.com/danielgindi/Charts/blob/1788e53f22eb3de79eb4f08574d8ea4b54b5e417/ChartsDemo/Classes/Components/BalloonMarker.swift
//  Edit: Added textColor

import Foundation;
import Charts;

public class HighlightIntersection: ChartMarker
{
    private var _size: CGSize = CGSize()
    private var isHighlightCircle: Bool = true;
    private var highlightCircleRadius: CGFloat = 6;
    private var highlightInnerCircleRadius: CGFloat = 3;
    private var highlightCircleColor: UIColor = UIColor.blue;
    private var highlightInnerCircleColor: UIColor = UIColor.darkGray;
    private var dynChangeHighlightColor: Bool = false;
    
    public override init() {
        super.init()
    }
    
    public override var size: CGSize { return _size; }

    public override func draw(context: CGContext, point: CGPoint)
    {
      context.saveGState()
      
      if self.isHighlightCircle {
        self.highlightIntersectionPoint(context: context, point: point);
      }
      
      context.restoreGState()
    }
    
    public func highlightIntersectionPoint(context: CGContext, point: CGPoint){
        context.move(to: point);
        
        // Outer circle
        context.setFillColor(self.highlightCircleColor.cgColor);
        (UIBezierPath(
            arcCenter: point,
            radius: self.highlightCircleRadius,
            startAngle: CGFloat(0),
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        ).fill();
        
        // Inner circle
        context.setFillColor(self.highlightInnerCircleColor.cgColor);
        (UIBezierPath(
            arcCenter: point,
            radius: self.highlightInnerCircleRadius,
            startAngle: CGFloat(0),
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        ).fill();
    }
    
    public override func preDraw(chartData: ChartData?, highlight: ChartHighlight){
        if dynChangeHighlightColor && (chartData != nil) {
            let highlightIndex = highlight.dataSetIndex
            
            let colorsList = chartData?.getColors();
            if colorsList != nil && (colorsList?.count)! > highlightIndex {
                let colorVal = colorsList?[highlightIndex]
                
                if colorVal != nil{
                    self.setHighlightCircleColor(highlightCircleColor: colorVal!);
                }
            }
        }
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: ChartHighlight)
    {
        // Nothing to do here
    }
    
    public func setHighlightCircleRadius(highlightCircleRadius: CGFloat){
        self.highlightCircleRadius = highlightCircleRadius
    }
    
    public func setHighlightInnerCircleRadius(highlightInnerCircleRadius: CGFloat){
        self.highlightInnerCircleRadius = highlightInnerCircleRadius
    }
    
    public func setHighlightCircleColor(highlightCircleColor: UIColor){
        self.highlightCircleColor = highlightCircleColor
    }
    
    public func setHighlightInnerCircleColor(highlightInnerCircleColor: UIColor){
        self.highlightInnerCircleColor = highlightInnerCircleColor
    }
    
    public func setDynChangeHighlightColor(dynChangeHighlightColor: Bool){
        self.dynChangeHighlightColor = dynChangeHighlightColor
    }
}
