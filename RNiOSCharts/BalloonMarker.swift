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
    private var borderColor: UIColor = UIColor.black;
    private var borderWidth: CGFloat = 0.0;
    
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
        
        // This is needed since context.height is in pixels
        let scale :CGFloat = UIScreen.main.scale
        let height: CGFloat = CGFloat(context.height)/scale
        let width: CGFloat = CGFloat(context.width)/scale
        
        if self.angularOffset != nil{
            var posx: CGFloat = point.x
            var posy: CGFloat = point.y
            
            let midX: CGFloat = width/2
            let midY: CGFloat = height/2
            
            let offset: CGFloat = self.angularOffset!
            
            let ydiff: CGFloat = posy - midY
            let xdiff: CGFloat = posx - midX
            
            let slope: CGFloat = atan2(ydiff, xdiff)
            
            let xDelta = offset * cos(slope);
            let yDelta = offset * sin(slope);
            
            posx += xDelta;
            posy += yDelta;
            
            // Now the correct point is decided. 
            // But the rectangle will always be drawn from the top-left point.
            // We want the markerView to move around as it's rotated.
            // This block basically positions the xpos and ypos to match the 
            // top-left point in the markerView.
            if xdiff >= 0 && ydiff >= 0 {
                // Nothing to modify here. It's the top left corner
            } else if xdiff > 0 && ydiff < 0 {
                posy -= _size.height
            } else if xdiff < 0 && ydiff > 0 {
                posx -= _size.width;
            } else {
                posx -= _size.width
                posy -= _size.height
            }
            
            updatedPoint = CGPoint(x: posx, y: posy)
        }else{
            updatedPoint = CGPoint(
                x: point.x + self.xOffset,
                y: point.y + self.yOffset
            )
        }
        
        // This the draws the view at the point.
        var rect = CGRect(origin: updatedPoint, size: _size);
        
        var xVal = rect.origin.x;
        var yVal = rect.origin.y;
        
        // These checks are performed to see if the markerView goes out of bounds.
        // Depending on whether angular offsets are used, it varies slightly.
        if xVal < 0{
            xVal = self.xOffset + self.borderWidth;
        }else if (xVal + _size.width) > width {
            let totalMarkerWidth = xVal + _size.width + (2 * self.borderWidth);
            if totalMarkerWidth > width {
                if (self.angularOffset != nil){
                    xVal -= (totalMarkerWidth - width)
                }else{
                    // Switching the axes for when the markerView goes outside bounds
                    xVal = point.x - (self.xOffset + _size.width + (2 * self.borderWidth));
                }
            }
        }
        
        if yVal < 0{
            yVal = self.yOffset + self.borderWidth;
        }else {
            let totalMarkerHeight = yVal + _size.height + (2 * self.borderWidth);
            if totalMarkerHeight > height{
                if (self.angularOffset != nil){
                    yVal -= (totalMarkerHeight - height);
                } else {
                    // Switching the axes for when the markerView goes outside bounds
                    yVal = point.y - (self.yOffset + _size.height + (2 * self.borderWidth));
                }
            }
        }
        
        rect.origin.x = xVal;
        rect.origin.y = yVal;
        
        context.saveGState()
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        
        context.move(to: CGPoint.init(x: rect.origin.x,
                                      y: rect.origin.y));
        
        // Drawing the border
        if self.borderWidth > 0 {
            context.setFillColor((self.borderColor.cgColor))
            let borderRect = CGRect(
                x: rect.origin.x - self.borderWidth,
                y: rect.origin.y - self.borderWidth,
                width: rect.width + (2 * self.borderWidth),
                height: rect.height + (2 * self.borderWidth)
            );
            
            (UIBezierPath.init(roundedRect: borderRect, cornerRadius: self.borderRadius)).fill()
        }
        
        context.setFillColor((color?.cgColor)!)
        
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
    
    public func setBorderColor(borderColor: UIColor){
        self.borderColor = borderColor;
    }
    
    public func setBorderWidth(borderWidth: CGFloat){
        self.borderWidth = borderWidth;
    }
}
