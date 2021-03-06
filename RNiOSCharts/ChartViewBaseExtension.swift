
//
//  ChartViewBaseExtension.swift
//  PoliRank
//
//  Created by Jose Padilla on 2/8/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

import SwiftyJSON
import Charts

// Setting some defaults here
let DEFAULT_MARKER_FONT_SIZE:CGFloat = 12.0
let DEFAULT_MARKER_BG_COLOR: String = "#000000"
let DEFAULT_MARKER_TEXT_COLOR: String = "#FFFFFF"

extension ChartViewBase {
    func setCustomHighlightViewProps(json: JSON){
        if json["drawHighlightCircles"].exists(){
            self.drawCustomHighlight = json["drawHighlightCircles"].boolValue
        } else if json["highlightCircle"].exists(){
            self.drawCustomHighlight = true;
        }
        
        if self.drawCustomHighlight {
            let customItem: HighlightIntersection = HighlightIntersection();
            
            if json["highlightCircle"].exists(){
                let customViewObj = json["highlightCircle"];
                
                if customViewObj["outerColor"].exists(){
                    let outerColor = customViewObj["outerColor"].stringValue
                    customItem.setHighlightCircleColor(highlightCircleColor: UIColor(cgColor: ChartColorTemplates.colorFromString(outerColor).cgColor))
                }
                
                if customViewObj["innerColor"].exists(){
                    let innerColor = customViewObj["innerColor"].stringValue
                    customItem.setHighlightInnerCircleColor(highlightInnerCircleColor: UIColor(cgColor: ChartColorTemplates.colorFromString(innerColor).cgColor))
                }
                
                if customViewObj["outerRadius"].exists(){
                    let outerRadius = CGFloat(customViewObj["outerRadius"].floatValue)
                    customItem.setHighlightCircleRadius(highlightCircleRadius: outerRadius)
                }
                
                if customViewObj["innerRadius"].exists(){
                    let innerRadius = CGFloat(customViewObj["innerRadius"].floatValue)
                    customItem.setHighlightInnerCircleRadius(highlightInnerCircleRadius: innerRadius)
                }
                
                if customViewObj["dynChangeHighlightColor"].exists(){
                    let dynColorChange = customViewObj["dynChangeHighlightColor"].boolValue
                    customItem.setDynChangeHighlightColor(dynChangeHighlightColor: dynColorChange)
                }
            }
            
            self.customHightlightItem = customItem
        }
    }
    
    
    func setMarkerViewProps(json:JSON){
        let isMarkerPropExists = json["marker"].exists()
        
        if json["drawMarkers"].exists() {
            self.drawMarkers = json["drawMarkers"].boolValue;
        } else if isMarkerPropExists {
            self.drawMarkers = true
        }
        
        if self.drawMarkers{
            var markerFontSize: CGFloat = DEFAULT_MARKER_FONT_SIZE
            var markerFont = UIFont.systemFont(ofSize: markerFontSize);
            
            var bgColor = UIColor(
                cgColor: ChartColorTemplates.colorFromString(DEFAULT_MARKER_BG_COLOR).cgColor
            );
            
            var textColor = UIColor(
                cgColor: ChartColorTemplates.colorFromString(DEFAULT_MARKER_TEXT_COLOR).cgColor
            );
            
            let markerView : BalloonMarker = BalloonMarker(
                color: bgColor,
                font: markerFont,
                textColor: textColor
            )
            
            if isMarkerPropExists {
                var markerObj = json["marker"];
                
                var fontChanged = false
                
                if markerObj["textSize"].exists() {
                    markerFontSize = CGFloat(markerObj["textSize"].floatValue);
                    fontChanged = true
                }
                
                if markerObj["setBold"].exists() {
                    let setBold = markerObj["setBold"].boolValue
                    if setBold{
                        markerFont = UIFont.boldSystemFont(ofSize: markerFontSize);
                        fontChanged = true
                    }
                } else if markerObj["setItalics"].exists() {
                    let setItalics = markerObj["setItalics"].boolValue
                    if setItalics{
                        markerFont = UIFont.italicSystemFont(ofSize: markerFontSize)
                        fontChanged = true
                    }
                }
                
                if markerObj["font"].exists() {
                    let fontValue = markerObj["font"].stringValue
                    markerFont = UIFont(
                        name: fontValue,
                        size: markerFontSize
                        )!;
                    fontChanged = true
                }
                
                if fontChanged {
                    markerView.setFont(font: markerFont);
                }
                
                if markerObj["backgroundColor"].exists(){
                    let bgColorStr = markerObj["backgroundColor"].stringValue;
                    bgColor = UIColor(cgColor: ChartColorTemplates.colorFromString(bgColorStr).cgColor);
                    
                    markerView.setColor(color: bgColor);
                }
                
                if markerObj["textColor"].exists(){
                    let textColorStr = markerObj["textColor"].stringValue;
                    textColor = UIColor(cgColor: ChartColorTemplates.colorFromString(textColorStr).cgColor);
                    
                    markerView.setTextColor(textColor: textColor);
                }
                
                if markerObj["padding"].exists(){
                    markerView.setPadding(paddingVal: CGFloat(markerObj["padding"].floatValue))
                }
                
                if markerObj["xOffset"].exists(){
                    let xoffset = (CGFloat)(markerObj["xOffset"].intValue)
                    markerView.setXOffset(xOffset: xoffset);
                }
                
                if markerObj["yOffset"].exists(){
                    let yoffset = (CGFloat)(markerObj["yOffset"].intValue)
                    markerView.setYOffset(yOffset: yoffset);
                }
                
                if markerObj["padding"].exists() {
                    let paddingVal = (CGFloat)(markerObj["padding"].intValue)
                    markerView.setPadding(paddingVal: paddingVal)
                }
                
                if markerObj["textStructure"].exists() {
                    let textStructure = markerObj["textStructure"].stringValue
                    markerView.setTextStructure(textStructure: textStructure)
                }
                
                if markerObj["borderRadius"].exists() {
                    let borderRadius = CGFloat(markerObj["borderRadius"].floatValue)
                    markerView.setBorderRadius(borderRadius: borderRadius)
                }
                
                if markerObj["borderColor"].exists() {
                    let borderColorStr = markerObj["borderColor"].stringValue;
                    let borderColor = UIColor(cgColor: ChartColorTemplates.colorFromString(borderColorStr).cgColor);
                    
                    markerView.setBorderColor(borderColor: borderColor);
                }
                
                if markerObj["borderWidth"].exists() {
                    let borderWidth = CGFloat(markerObj["borderWidth"].floatValue);
                    
                    markerView.setBorderWidth(borderWidth: borderWidth);
                }
                
                if markerObj["shadow"].exists() {
                    let shadowObj = markerObj["shadow"];
                    
                    if shadowObj["height"].exists() {
                        markerView.setShadowHeight(shadowHeight: CGFloat(shadowObj["height"].floatValue));
                    }
                    
                    if shadowObj["width"].exists() {
                        markerView.setShadowWidth(shadowWidth: CGFloat(shadowObj["width"].floatValue));
                    }
                    
                    if shadowObj["blurRadius"].exists() {
                        markerView.setShadowHeight(shadowHeight: CGFloat(shadowObj["height"].floatValue));
                    }
                }
            }
            
            self.marker = markerView;
        }
    }
    
    func setChartViewBaseProps(_ config: String!) {
        var legendColors: [UIColor] = ChartColorTemplates.colorful();
        var legendLabels: [String] = [];

        self.descriptionText = "";
        self.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.0);

        var json: JSON = nil;
        if let data = config.data(using: String.Encoding.utf8) {
            json = JSON(data: data);
        };
        
        setMarkerViewProps(json: json);
        
        setCustomHighlightViewProps(json: json);

        if json["backgroundColor"].exists() {
            self.backgroundColor = RCTConvert.uiColor(json["backgroundColor"].intValue);
        }

        if json["noDataText"].exists() {
            self.noDataText = json["noDataText"].stringValue;
        }

        if json["descriptionText"].exists() {
            self.descriptionText = json["descriptionText"].stringValue;
        }

        if json["descriptionFontName"].exists() {
            self.descriptionFont = UIFont(
                name: json["descriptionFontName"].stringValue,
                size: self.descriptionFont!.pointSize
            );
        }

        if json["descriptionFontSize"].exists() {
            self.descriptionFont = self.descriptionFont?.withSize(CGFloat(json["descriptionFontSize"].floatValue));
        }

        if json["descriptionTextColor"].exists() {
            self.descriptionTextColor = RCTConvert.uiColor(json["descriptionTextColor"].intValue);
        }

        if json["descriptionTextPosition"].exists() &&
            json["descriptionTextPosition"]["x"].exists() &&
            json["descriptionTextPosition"]["y"].exists() {

                self.setDescriptionTextPosition(
                    x: CGFloat(json["descriptionTextPosition"]["x"].floatValue),
                    y: CGFloat(json["descriptionTextPosition"]["y"].floatValue)
                )
        }

        if json["infoTextFontName"].exists() {
            self.infoFont = UIFont(
                name: json["infoTextFontName"].stringValue,
                size: self.infoFont!.pointSize
            );
        }

        if json["infoTextFontSize"].exists() {
            self.infoFont = self.infoFont?.withSize(CGFloat(json["infoTextFontSize"].floatValue));
        }

        if json["infoTextColor"].exists() {
            self.infoTextColor = RCTConvert.uiColor(json["infoTextColor"].intValue);
        }

        if json["descriptionTextAlign"].exists() {
            switch (json["descriptionTextAlign"].stringValue) {
            case "left":
                self.descriptionTextAlign = NSTextAlignment.left;
                break;
            case "center":
                self.descriptionTextAlign = NSTextAlignment.center;
                break;
            case "right":
                self.descriptionTextAlign = NSTextAlignment.right;
                break;
            case "justified":
                self.descriptionTextAlign = NSTextAlignment.justified;
                break;
            default:
                break;
            }
        }

        if json["showLegend"].exists() {
            self.legend.enabled = json["showLegend"].boolValue;
        }

        if json["legend"].exists() {
            if json["legend"]["textColor"].exists() {
                self.legend.textColor = RCTConvert.uiColor(json["legend"]["textColor"].intValue);
            }

            if json["legend"]["textSize"].exists() {
                self.legend.font = self.legend.font.withSize(CGFloat(json["legend"]["textSize"].floatValue));
            }

            if json["legend"]["textFontName"].exists() {
                self.legend.font = UIFont(
                    name: json["legend"]["textFontName"].stringValue,
                    size: self.legend.font.pointSize
                    )!;
            }

            if json["legend"]["wordWrap"].exists() {
                self.legend.wordWrapEnabled = json["legend"]["wordWrap"].boolValue;
            }

            if json["legend"]["maxSizePercent"].exists() {
                self.legend.maxSizePercent = CGFloat(json["legend"]["maxSizePercent"].floatValue);
            }

            if json["legend"]["position"].exists() {
                switch(json["legend"]["position"].stringValue) {
                case "rightOfChart":
                    self.legend.position = ChartLegend.Position.rightOfChart;
                    break;
                case "rightOfChartCenter":
                    self.legend.position = ChartLegend.Position.rightOfChartCenter;
                    break;
                case "rightOfChartInside":
                    self.legend.position = ChartLegend.Position.rightOfChartInside;
                    break;
                case "leftOfChart":
                    self.legend.position = ChartLegend.Position.leftOfChart;
                    break;
                case "leftOfChartCenter":
                    self.legend.position = ChartLegend.Position.leftOfChartCenter;
                    break;
                case "leftOfChartInside":
                    self.legend.position = ChartLegend.Position.leftOfChartInside;
                    break;
                case "belowChartLeft":
                    self.legend.position = ChartLegend.Position.belowChartLeft;
                    break;
                case "belowChartRight":
                    self.legend.position = ChartLegend.Position.belowChartRight;
                    break;
                case "belowChartCenter":
                    self.legend.position = ChartLegend.Position.belowChartCenter;
                    break;
                case "aboveChartLeft":
                    self.legend.position = ChartLegend.Position.aboveChartLeft;
                    break;
                case "aboveChartRight":
                    self.legend.position = ChartLegend.Position.aboveChartRight;
                    break;
                case "aboveChartCenter":
                    self.legend.position = ChartLegend.Position.aboveChartCenter;
                    break;
                case "pieChartCenter":
                    self.legend.position = ChartLegend.Position.piechartCenter;
                    break;
                default:
                    self.legend.position = ChartLegend.Position.belowChartLeft;
                    break;
                }
            }

            if json["legend"]["form"].exists() {
                switch(json["legend"]["form"]) {
                case "square":
                    self.legend.form = ChartLegend.Form.square;
                    break;
                case "circle":
                    self.legend.form = ChartLegend.Form.circle;
                    break;
                case "line":
                    self.legend.form = ChartLegend.Form.line;
                    break;
                default:
                    self.legend.form = ChartLegend.Form.square;
                    break;
                }
            }

            if json["legend"]["formSize"].exists() {
                self.legend.formSize = CGFloat(json["legend"]["formSize"].floatValue);
            }

            if json["legend"]["xEntrySpace"].exists() {
                self.legend.xEntrySpace = CGFloat(json["legend"]["xEntrySpace"].floatValue);
            }

            if json["legend"]["yEntrySpace"].exists() {
                self.legend.yEntrySpace = CGFloat(json["legend"]["yEntrySpace"].floatValue);
            }

            if json["legend"]["formToTextSpace"].exists() {
                self.legend.formToTextSpace = CGFloat(json["legend"]["formToTextSpace"].floatValue);
            }

            if json["legend"]["colors"].exists() {
                let arrColors = json["legend"]["colors"].arrayValue.map({$0.intValue});
                legendColors = arrColors.map({return RCTConvert.uiColor($0)});
                if legendLabels.count == legendColors.count {
                    legend.setCustom(colors: legendColors, labels: legendLabels);
                }
            }

            if json["legend"]["labels"].exists() {
                legendLabels = json["legend"]["labels"].arrayValue.map({$0.stringValue});
                if legendLabels.count == legendColors.count {
                    legend.setCustom(colors:  legendColors, labels: legendLabels);
                }
            }
        }

        if json["userInteractionEnabled"].exists() {
          self.isUserInteractionEnabled = json["userInteractionEnabled"].boolValue;
        }

        if json["dragDecelerationEnabled"].exists() {
          self.dragDecelerationEnabled = json["dragDecelerationEnabled"].boolValue;
        }

        if json["dragDecelerationFrictionCoef"].exists() {
          self.dragDecelerationFrictionCoef = CGFloat(json["dragDecelerationFrictionCoef"].floatValue);
        }

        if json["highlightPerTap"].exists() {
          self.highlightPerTapEnabled = json["highlightPerTap"].boolValue;
        }

        if json["highlightValues"].exists() {
            let highlightValues = json["highlightValues"].arrayValue.map({$0.intValue});
            self.highlightValues(highlightValues.map({return ChartHighlight(xIndex: $0, dataSetIndex: 0)}));
        }

        if json["animation"].exists() {
            let xAxisDuration = json["animation"]["xAxisDuration"].exists() ?
                json["animation"]["xAxisDuration"].doubleValue : 0;
            let yAxisDuration = json["animation"]["yAxisDuration"].exists() ?
                json["animation"]["yAxisDuration"].doubleValue : 0;

            var easingOption: ChartEasingOption = .linear;

            if json["animation"]["easingOption"].exists() {
                switch(json["animation"]["easingOption"]) {
                case "linear":
                    easingOption = .linear;
                    break;
                case "easeInQuad":
                    easingOption = .easeInQuad;
                    break;
                case "easeOutQuad":
                    easingOption = .easeOutQuad;
                    break;
                case "easeInOutQuad":
                    easingOption = .easeInOutQuad;
                    break;
                case "easeInCubic":
                    easingOption = .easeInCubic;
                    break;
                case "easeOutCubic":
                    easingOption = .easeOutCubic;
                    break;
                case "easeInOutCubic":
                    easingOption = .easeInOutCubic;
                    break;
                case "easeInQuart":
                    easingOption = .easeInQuart;
                    break;
                case "easeOutQuart":
                    easingOption = .easeOutQuart;
                    break;
                case "easeInOutQuart":
                    easingOption = .easeInOutQuart;
                    break;
                case "easeInQuint":
                    easingOption = .easeInQuint;
                    break;
                case "easeOutQuint":
                    easingOption = .easeOutQuint;
                    break;
                case "easeInOutQuint":
                    easingOption = .easeInOutQuint;
                    break;
                case "easeInSine":
                    easingOption = .easeInSine;
                    break;
                case "easeOutSine":
                    easingOption = .easeOutSine;
                    break;
                case "easeInOutSine":
                    easingOption = .easeInOutSine;
                    break;
                case "easeInExpo":
                    easingOption = .easeInExpo;
                    break;
                case "easeOutExpo":
                    easingOption = .easeOutExpo;
                    break;
                case "easeInOutExpo":
                    easingOption = .easeInOutExpo;
                    break;
                case "easeInCirc":
                    easingOption = .easeInCirc;
                    break;
                case "easeOutCirc":
                    easingOption = .easeOutCirc;
                    break;
                case "easeInOutCirc":
                    easingOption = .easeInOutCirc;
                    break;
                case "easeInElastic":
                    easingOption = .easeInElastic;
                    break;
                case "easeOutElastic":
                    easingOption = .easeOutElastic;
                    break;
                case "easeInBack":
                    easingOption = .easeInBack;
                    break;
                case "easeOutBack":
                    easingOption = .easeOutBack;
                    break;
                case "easeInOutBack":
                    easingOption = .easeInOutBack;
                    break;
                case "easeInBounce":
                    easingOption = .easeInBounce;
                    break;
                case "easeOutBounce":
                    easingOption = .easeOutBounce;
                    break;
                case "easeInOutBounce":
                    easingOption = .easeInOutBounce;
                    break;
                default:
                    easingOption = .linear;
                    break;
                }
            }

            self.animate(xAxisDuration: xAxisDuration, yAxisDuration: yAxisDuration, easingOption: easingOption);
        }
    }
}
