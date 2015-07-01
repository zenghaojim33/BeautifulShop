//
//  HorizontalBarChartView.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 4/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

import Foundation
import UIKit

/// BarChart with horizontal bar orientation. In this implementation, x- and y-axis are switched.
public class HorizontalBarChartView: BarChartView
{
    internal override func initialize()
    {
        super.initialize();
        
        _leftAxisTransformer = ChartTransformerHorizontalBarChart(viewPortHandler: _viewPortHandler);
        _rightAxisTransformer = ChartTransformerHorizontalBarChart(viewPortHandler: _viewPortHandler);
        
        renderer = HorizontalBarChartRenderer(delegate: self, animator: _animator, viewPortHandler: _viewPortHandler);
        _leftYAxisRenderer = ChartYAxisRendererHorizontalBarChart(viewPortHandler: _viewPortHandler, yAxis: _leftAxis, transformer: _leftAxisTransformer);
        _rightYAxisRenderer = ChartYAxisRendererHorizontalBarChart(viewPortHandler: _viewPortHandler, yAxis: _rightAxis, transformer: _rightAxisTransformer);
        _xAxisRenderer = ChartXAxisRendererHorizontalBarChart(viewPortHandler: _viewPortHandler, xAxis: _xAxis, transformer: _leftAxisTransformer, chart: self);
    }
    
    internal override func calculateOffsets()
    {
        var offsetLeft: CGFloat = 0.0,
        offsetRight: CGFloat = 0.0,
        offsetTop: CGFloat = 0.0,
        offsetBottom: CGFloat = 0.0;
        
        // setup offsets for legend
        if (_legend !== nil && _legend.isEnabled)
        {
            if (_legend.position == .RightOfChart
                || _legend.position == .RightOfChartCenter)
            {
                offsetRight += _legend.textWidthMax + _legend.xOffset * 2.0;
            }
            else if (_legend.position == .LeftOfChart
                || _legend.position == .LeftOfChartCenter)
            {
                offsetLeft += _legend.textWidthMax + _legend.xOffset * 2.0;
            }
            else if (_legend.position == .BelowChartLeft
                || _legend.position == .BelowChartRight
                || _legend.position == .BelowChartCenter)
            {
                
                offsetBottom += _legend.textHeightMax * 3.0;
            }
        }
        
        // offsets for y-labels
        if (_leftAxis.needsOffset)
        {
            offsetTop += _leftAxis.requiredSize().height;
        }
        
        if (_rightAxis.needsOffset)
        {
            offsetBottom += _rightAxis.requiredSize().height;
        }
        
        var xlabelwidth = _xAxis.labelWidth;
        
        if (_xAxis.isEnabled)
        {
            // offsets for x-labels
            if (_xAxis.labelPosition == .Bottom)
            {
                offsetLeft += xlabelwidth;
            }
            else if (_xAxis.labelPosition == .Top)
            {
                offsetRight += xlabelwidth;
            }
            else if (_xAxis.labelPosition == .BothSided)
            {
                offsetLeft += xlabelwidth;
                offsetRight += xlabelwidth;
            }
        }
        
        var min: CGFloat = 10.0;
        
        _viewPortHandler.restrainViewPort(
            offsetLeft: max(min, offsetLeft),
            offsetTop: max(min, offsetTop),
            offsetRight: max(min, offsetRight),
            offsetBottom: max(min, offsetBottom));
        
        prepareOffsetMatrix();
        prepareValuePxMatrix();
    }
    
    internal override func prepareValuePxMatrix()
    {
        _rightAxisTransformer.prepareMatrixValuePx(chartXMin: _rightAxis.axisMinimum, deltaX: CGFloat(_rightAxis.axisRange), deltaY: _deltaX, chartYMin: _chartXMin);
        _leftAxisTransformer.prepareMatrixValuePx(chartXMin: _leftAxis.axisMinimum, deltaX: CGFloat(_leftAxis.axisRange), deltaY: _deltaX, chartYMin: _chartXMin);
    }

    internal override func calcModulus()
    {
        _xAxis.axisLabelModulus = Int(ceil((CGFloat(_data.xValCount) * _xAxis.labelHeight) / (_viewPortHandler.contentHeight * viewPortHandler.touchMatrix.d)));
        
        if (_xAxis.axisLabelModulus < 1)
        {
            _xAxis.axisLabelModulus = 1;
        }
    }
    
    public override func getBarBounds(e: BarChartDataEntry) -> CGRect!
    {
        var set = _data.getDataSetForEntry(e) as! BarChartDataSet!;
        
        if (set === nil)
        {
            return nil;
        }
        
        var barspace = set.barSpace;
        var y = CGFloat(e.value);
        var x = CGFloat(e.xIndex);
        
        var spaceHalf = barspace / 2.0;
        var top = x - 0.5 + spaceHalf;
        var bottom = x + 0.5 - spaceHalf;
        var left = y >= 0.0 ? y : 0.0;
        var right = y <= 0.0 ? y : 0.0;
        
        var bounds = CGRect(x: left, y: top, width: right - left, height: bottom - top);
        
        getTransformer(set.axisDependency).rectValueToPixel(&bounds);
        
        return bounds;
    }
    
    public override func getPosition(e: ChartDataEntry, axis: ChartYAxis.AxisDependency) -> CGPoint
    {
        var vals = CGPoint(x: CGFloat(e.value), y: CGFloat(e.xIndex));
        
        getTransformer(axis).pointValueToPixel(&vals);
        
        return vals;
    }

    public override func getHighlightByTouchPoint(var pt: CGPoint) -> ChartHighlight!
    {
        if (_dataNotSet || _data === nil)
        {
            println("Can't select by touch. No data set.");
            return nil;
        }
        
        _leftAxisTransformer.pixelToValue(&pt);
        
        if (pt.y < CGFloat(_chartXMin) || pt.y > CGFloat(_chartXMax))
        {
            return nil;
        }
        
        return getHighlight(xPosition: pt.y, yPosition: pt.x);
    }
}