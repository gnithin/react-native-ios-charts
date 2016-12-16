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

public class BalloonMarker: ChartMarker
{
    public var color: UIColor?
    public var arrowSize = CGSize(width: 15, height: 11)
    public var font: UIFont?
    public var textColor: UIColor?
    public var insets = UIEdgeInsets()
    public var minimumSize = CGSize()

    private var labelns: NSString?
    private var _labelSize: CGSize = CGSize()
    private var _size: CGSize = CGSize()
    private var _paragraphStyle: NSMutableParagraphStyle?
    private var _drawAttributes = [String : AnyObject]()
    private var paddingVal : CGFloat = 0.0
    private var xoffset: CGFloat = 0.0
    private var yoffset: CGFloat = 0.0
    private var angularOffset: CGFloat?
    private var textStructure: String = "{}"
    private var borderRadius: CGFloat = 0.0
    
    private var xOffset: CGFloat = 0.0;
    private var yOffset: CGFloat = 0.0;
    
    public init(
        color: UIColor,
        font: UIFont,
        textColor: UIColor
    ) {
        super.init()
        
        self.color = color
        self.font = font
        self.textColor = textColor
        self.setInsets();
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }
    
    public override var size: CGSize { return _size; }
    
    public override func draw(context: CGContext, point: CGPoint)
    {
        if labelns == nil { return }
        
        var updatedPoint = CGPoint(x: point.x, y: point.y)
        
        if self.angularOffset != nil{
            var posy: CGFloat = point.y
            var posx: CGFloat = point.x
            
            let scale :CGFloat = UIScreen.main.scale

            // This is needed since context.height is in pixels
            let height: CGFloat = CGFloat(context.height)/scale
            let width: CGFloat = CGFloat(context.width)/scale
            
            let midX: CGFloat = width/(2)
            let midY: CGFloat = height/(2)
            
            let offset: CGFloat = self.angularOffset!
            let ydiff: CGFloat = posy - midY
            let xdiff: CGFloat = posx - midX
            
            let slope: CGFloat = atan2(ydiff, xdiff)
            
            posx += offset * cos(slope)
            posy += offset * sin(slope)
            
            updatedPoint = CGPoint(x: posx, y: posy)
        }else{
            updatedPoint = CGPoint(
                x: point.x + self.xOffset,
                y: point.y + self.yOffset
            )
        }
        
        // This the draws the view at the point.
        var rect = CGRect(origin: updatedPoint, size: _size);
        rect.origin.x -= _size.width/2.0
        rect.origin.y -= _size.height
        
        context.saveGState()
        
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        
        context.move(to: CGPoint.init(x: rect.origin.x,
                                      y: rect.origin.y));
        
        (UIBezierPath.init(roundedRect: rect, cornerRadius: self.borderRadius)).fill()
        
        context.fillPath()
        
        rect.origin.x += self.insets.left
        rect.origin.y += self.insets.top
        
        UIGraphicsPushContext(context)
        
        labelns?.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: ChartHighlight)
    {
        var label = entry.value.description
        label = self.textStructure.replacingOccurrences(of: "{}", with: label)
        
        labelns = label as NSString
      
        _drawAttributes.removeAll()
        _drawAttributes[NSForegroundColorAttributeName] = self.textColor
        _drawAttributes[NSFontAttributeName] = self.font
        
        _labelSize = labelns!.size(attributes: _drawAttributes);
        _size.width = _labelSize.width + self.insets.left + self.insets.right
        _size.height = _labelSize.height + self.insets.top + self.insets.bottom
        _size.width = max(minimumSize.width, _size.width)
        _size.height = max(minimumSize.height, _size.height)
    }
    
    private func setInsets(){
        self.insets = UIEdgeInsetsMake(self.paddingVal, self.paddingVal, self.paddingVal, self.paddingVal);
    }
    
    public func setXOffset(xOffset: CGFloat){
        self.xOffset = xOffset;
    }
    
    public func setYOffset(yOffset: CGFloat){
        self.yOffset = yOffset;
    }
    
    public func setPadding(paddingVal : CGFloat){
        self.paddingVal = paddingVal;
        setInsets();
    }
    
    public func setTextStructure(textStructure: String){
        self.textStructure = textStructure
    }
    
    public func setColor(color: UIColor){
        self.color = color
    }
    
    public func setFont(font: UIFont){
        self.font = font
    }
    
    public func setTextColor(textColor: UIColor){
        self.textColor = textColor
    }
    
    public func setAngularOffset(angOff: CGFloat){
        self.angularOffset = angOff;
    }
    
    public func setBorderRadius(borderRadius: CGFloat){
        self.borderRadius = borderRadius;
    }
}
