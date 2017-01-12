import React, { Component } from 'react';
import {
  requireNativeComponent,
  NativeModules,
  findNodeHandle
} from 'react-native';

import {
  globalCommonProps,
  barLineCommonProps,
  commonDataSetProps
} from '../utils/commonProps';

import { processColors } from '../utils/commonColorProps';
const RNLineChartManager = NativeModules.RNLineChartSwift;
const RNLineChart = requireNativeComponent('RNLineChartSwift', LineChart);

class LineChart extends Component {
  constructor(props) {
    super(props);
    this.setVisibleXRangeMaximum = this.setVisibleXRangeMaximum.bind(this);
  }
  setVisibleXRangeMaximum(value) {
    RNLineChartManager.setVisibleXRangeMaximum(findNodeHandle(this), value);
  }

  shouldComponentUpdate(nextProps, nextState) {
    // NOTE - Never update the line chart. It will render the whole graph again,
    // thus breaking the customHighlightVal logic flow.
    // Currently, there is never a use-case to do so.
    // If there is ever a case, make sure to put the logic for customHighlightVal 
    // in an else and return false.
    
    // Getting the customValue here.
    if(typeof nextProps.customHighlightVal !== "undefined"){
      let hVal = parseInt(nextProps.customHighlightVal);

      if(!isNaN(hVal) && hVal >= 0){
        // Calling the native module here.
        RNLineChartManager.customHighlightVal(findNodeHandle(this), hVal); 
      }
    }

    return false;
  }
  
  render() {
    let { config, ...otherProps } = this.props;
    config = JSON.stringify(processColors(config));

    return <RNLineChart config={config} {...otherProps} />;
  }
}

LineChart.propTypes = {
  config: React.PropTypes.shape({
    ...globalCommonProps,
    ...barLineCommonProps,
    dataSets: React.PropTypes.arrayOf(React.PropTypes.shape({
      ...commonDataSetProps,
      drawCircles: React.PropTypes.bool,
      circleColors: React.PropTypes.arrayOf(React.PropTypes.string),
      circleHoleColor: React.PropTypes.string,
      circleRadius: React.PropTypes.number,
      cubicIntensity: React.PropTypes.number,
      drawCircleHole: React.PropTypes.bool,
      drawCubic: React.PropTypes.bool,
      drawFilled: React.PropTypes.bool,
      drawHorizontalHighlightIndicator: React.PropTypes.bool,
      drawVerticalHighlightIndicator: React.PropTypes.bool,
      fillAlpha: React.PropTypes.number,
      fillColor: React.PropTypes.string,
      fillGradient: React.PropTypes.shape({
        angle: React.PropTypes.string,
        startColor: React.PropTypes.string,
        endColor: React.PropTypes.string
      }),
      highlightColor: React.PropTypes.string,
      highlightLineDashLengths: React.PropTypes.number,
      highlightLineDashPhase: React.PropTypes.number,
      highlightLineWidth: React.PropTypes.number,
      lineDashLengths: React.PropTypes.number,
      lineDashPhase: React.PropTypes.number,
      lineWidth: React.PropTypes.number
    }))
  })
};

export default LineChart;
