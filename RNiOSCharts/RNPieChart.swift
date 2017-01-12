//
//  RNPieChart.swift
//  PoliRank
//
//  Created by Jose Padilla on 2/8/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

import Charts
import SwiftyJSON

@objc(RNPieChart)
class RNPieChart : PieChartView {
  
  override init(frame: CGRect) {
    super.init(frame: frame);
    self.frame = frame;
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  }
  
  func setConfig(_ config: String!) {
    setPieRadarChartViewBaseProps(config);
    
    var maximumDecimalPlaces: Int = 0;
    var minimumDecimalPlaces: Int = 0;
    var labels: [String] = [];
    
    var json: JSON = nil;
    if let data = config.data(using: String.Encoding.utf8) {
      json = JSON(data: data);
    };
    
    /*
     There is no conceivable way to figure out the type of the chart while drawing the
     markerView (i.e without modifying the charts library). 
     Since angularOffset is a specific property of a piechart, it needs to be added to the 
     current markerView already set from the extension.
     
     So this basically adds that extra property.
    */
    if(
      self.drawMarkers &&
      json["marker"].exists() &&
      json["marker"]["angularOffset"].exists() &&
      self.marker != nil
    ) {
      let markerObj = json["marker"]
      
      let angOff: CGFloat = CGFloat(markerObj["angularOffset"].floatValue)
      (self.marker as! BalloonMarker).setAngularOffset(angOff: angOff);
    }
    
    if json["holeColor"].exists() {
      let holeColorStr = json["holeColor"].stringValue;
      self.holeColor = NSUIColor(cgColor: ChartColorTemplates.colorFromString(holeColorStr).cgColor)
    }
    
    if json["drawHoleEnabled"].exists() {
      self.drawHoleEnabled = json["drawHoleEnabled"].boolValue;
    }

    if json["centerText"].exists() {
      self.centerText = json["centerText"].stringValue;
    }
    
    if json["centerTextColor"].exists() {
      let centerTextColorStr = json["centerTextColor"].stringValue;
      
      var attrString: NSMutableAttributedString?
      let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
      paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
      paragraphStyle.alignment = .center
      
      attrString = NSMutableAttributedString(string: self.centerText!)
      attrString?.setAttributes([
        NSForegroundColorAttributeName: NSUIColor(cgColor: ChartColorTemplates.colorFromString(centerTextColorStr).cgColor),
        NSFontAttributeName: NSUIFont.systemFont(ofSize: 12.0),
        ], range: NSMakeRange(0, attrString!.length))
      
      self.centerAttributedText = attrString;
      
    }

    if json["drawCenterTextEnabled"].exists() {
      self.drawCenterTextEnabled = json["drawCenterTextEnabled"].boolValue;
    }
    
    if json["holeRadiusPercent"].exists() {
      self.holeRadiusPercent = CGFloat(json["holeRadiusPercent"].floatValue);
    }
    
    if json["transparentCircleRadiusPercent"].exists() {
      self.transparentCircleRadiusPercent = CGFloat(json["transparentCircleRadiusPercent"].floatValue);
    }
    
    if json["drawSliceTextEnabled"].exists() {
      self.drawSliceTextEnabled = json["drawSliceTextEnabled"].boolValue;
    }
    
    if json["usePercentValuesEnabled"].exists() {
      self.usePercentValuesEnabled = json["usePercentValuesEnabled"].boolValue;
    }
    
    if json["centerTextRadiusPercent"].exists() {
      self.centerTextRadiusPercent = CGFloat(json["centerTextRadiusPercent"].floatValue);
    }
    
    if json["maxAngle"].exists() {
      self.maxAngle = CGFloat(json["maxAngle"].floatValue);
    }
    
    var totalValuesCount:Int = 0;
    
    if json["dataSets"].exists() {
      let dataSets = json["dataSets"].arrayObject;
      
      var sets: [PieChartDataSet] = [];
      
      for set in dataSets! {
        let tmp = JSON(set);
        if tmp["values"].exists() {
          let values = tmp["values"].arrayValue.map({$0.doubleValue});
          let label = tmp["label"].exists() ? tmp["label"].stringValue : "";
          
          // This is basically a customization which separates the data points plotting the
          // graph to the ones that show up in the MarkerView.
          var displayData:[String] = [];
          for _ in 0..<values.count {
            displayData.append("");
          }
          
          if(tmp["displayData"].exists()){
            let customDisplayData = tmp["displayData"].arrayValue;
            for i in 0..<customDisplayData.count {
              if i < displayData.count{
                displayData[i] = customDisplayData[i].stringValue;
              }
            }
          }
          
          var dataEntries: [ChartDataEntry] = [];
          let valuesCount = values.count
          
          for i in 0..<valuesCount {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i, data:displayData[i]);
            dataEntries.append(dataEntry);
          }
            
          if valuesCount > totalValuesCount{
            totalValuesCount = valuesCount
          }
          
          let dataSet = PieChartDataSet(yVals: dataEntries, label: label);
          
          if tmp["sliceSpace"].exists() {
            dataSet.sliceSpace = CGFloat(tmp["sliceSpace"].floatValue);
          }
          
          if tmp["selectionShift"].exists() {
            dataSet.selectionShift = CGFloat(tmp["selectionShift"].floatValue);
          }
          
          if tmp["colors"].exists() {
            let arrColors = tmp["colors"].arrayValue.map({$0.intValue});
            dataSet.colors = arrColors.map({return RCTConvert.uiColor($0)});
          }
          
          if tmp["drawValues"].exists() {
            dataSet.drawValuesEnabled = tmp["drawValues"].boolValue;
          }
          
          if tmp["highlightEnabled"].exists() {
            dataSet.highlightEnabled = tmp["highlightEnabled"].boolValue;
          }
          
          if tmp["valueTextFontName"].exists() {
            dataSet.valueFont = UIFont(
              name: tmp["valueTextFontName"].stringValue,
              size: dataSet.valueFont.pointSize
              )!;
          }
          
          if tmp["valueTextFontSize"].exists() {
            dataSet.valueFont = dataSet.valueFont.withSize(CGFloat(tmp["valueTextFontSize"].floatValue))
          }
          
          if tmp["valueTextColor"].exists() {
            dataSet.valueTextColor = RCTConvert.uiColor(tmp["valueTextColor"].intValue);
          }
          
          if json["valueFormatter"].exists() {
            if json["valueFormatter"]["minimumDecimalPlaces"].exists() {
              minimumDecimalPlaces = json["valueFormatter"]["minimumDecimalPlaces"].intValue;
            }
            if json["valueFormatter"]["maximumDecimalPlaces"].exists() {
              maximumDecimalPlaces = json["valueFormatter"]["maximumDecimalPlaces"].intValue;
            }
            
            if json["valueFormatter"]["type"].exists() {
              switch(json["valueFormatter"]["type"]) {
              case "regular":
                dataSet.valueFormatter = NumberFormatter();
                break;
              case "abbreviated":
                dataSet.valueFormatter = ABNumberFormatter(minimumDecimalPlaces: minimumDecimalPlaces, maximumDecimalPlaces: maximumDecimalPlaces);
                break;
              default:
                dataSet.valueFormatter = NumberFormatter();
              }
            }
            
            if json["valueFormatter"]["numberStyle"].exists() {
              switch(json["valueFormatter"]["numberStyle"]) {
              case "CurrencyAccountingStyle":
                if #available(iOS 9.0, *) {
                  dataSet.valueFormatter?.numberStyle = .currencyAccounting;
                }
                break;
              case "CurrencyISOCodeStyle":
                if #available(iOS 9.0, *) {
                  dataSet.valueFormatter?.numberStyle = .currencyISOCode;
                }
                break;
              case "CurrencyPluralStyle":
                if #available(iOS 9.0, *) {
                  dataSet.valueFormatter?.numberStyle = .currencyPlural;
                }
                break;
              case "CurrencyStyle":
                dataSet.valueFormatter?.numberStyle = .currency;
                break;
              case "DecimalStyle":
                dataSet.valueFormatter?.numberStyle = .decimal;
                break;
              case "NoStyle":
                dataSet.valueFormatter?.numberStyle = .none;
                break;
              case "OrdinalStyle":
                if #available(iOS 9.0, *) {
                  dataSet.valueFormatter?.numberStyle = .ordinal;
                }
                break;
              case "PercentStyle":
                dataSet.valueFormatter?.numberStyle = .percent;
                break;
              case "ScientificStyle":
                dataSet.valueFormatter?.numberStyle = .scientific;
                break;
              case "SpellOutStyle":
                dataSet.valueFormatter?.numberStyle = .spellOut;
                break;
              default:
                dataSet.valueFormatter?.numberStyle = .none;
              }
            }
            
            dataSet.valueFormatter?.minimumFractionDigits = minimumDecimalPlaces;
            dataSet.valueFormatter?.maximumFractionDigits = maximumDecimalPlaces;
          }
          
          sets.append(dataSet);
        }
      }
      
      if json["labels"].exists() {
          labels = json["labels"].arrayValue.map({$0.stringValue});
      }
      
      /*
       This is for basically handling the cases when there are no labels given for
       a pie chart. This is needed because the markerView's whole logic is based off of
       the labels which it uses.
       */
      let labelsCount:Int = labels.count
      let valDiff:Int = totalValuesCount - labelsCount
      if valDiff > 0 {
          for _ in 0..<valDiff{
              labels.append("")
          }
      }
      
      let chartData = PieChartData(xVals: labels, dataSets: sets);
      self.data = chartData;
    }
    
  }
  
}
