import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class ChartBarMonth extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ChartBarMonth(this.seriesList, {this.animate});

  
  factory ChartBarMonth.withSampleData() {
    return new ChartBarMonth(
      _createSampleData(),
      
      animate: false,
    );
  }

  @override
  _ChartBarMonthState createState() => _ChartBarMonthState();

  
  static List<charts.Series<BarChartMonthModel, String>> _createSampleData() {
    final data = [
      new BarChartMonthModel('01', 5),
      new BarChartMonthModel('02', 25),
      new BarChartMonthModel('03', 100),
      new BarChartMonthModel('04', 75),
    ];
    Color _color = Color(0xFF23212A);
    return [
      new charts.Series<BarChartMonthModel, String>(
        id: 'money',
        colorFn: (_, __) => charts.Color(
            r: _color.red, g: _color.blue, b: _color.blue, a: _color.alpha),
        
        domainFn: (BarChartMonthModel money, _) => money.month,
        measureFn: (BarChartMonthModel money, _) => money.money,
        data: data,
      )
    ];
  }
}

class _ChartBarMonthState extends State<ChartBarMonth> {
  String _timeSelect;

  num _moneySelect;
  final _simpleCurrencyFormatter =
      new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
          new NumberFormat.compactSimpleCurrency(name: "USD"));

  
  _onSelectionChange(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    setState(() {
      _moneySelect = null;
      if (selectedDatum.isNotEmpty) {
        _timeSelect = selectedDatum.first.datum.month;
        selectedDatum.forEach((charts.SeriesDatum v) {
          _moneySelect = v.datum.money;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: charts.BarChart(
            widget.seriesList,
            animate: widget.animate,
            primaryMeasureAxis: new charts.NumericAxisSpec(
              tickFormatterSpec: _simpleCurrencyFormatter,
              showAxisLine: false,
             
              renderSpec: charts.GridlineRendererSpec(
                
                tickLengthPx: 0, 
                
                labelStyle: charts.TextStyleSpec(
                  
                  color: charts.Color.fromHex(code: '#999999'),
                ),
                axisLineStyle: charts.LineStyleSpec(
                  
                  color: charts.Color.fromHex(code: '#EEEEEE'),
                ),
                lineStyle: charts.LineStyleSpec(
                  
                  color: charts.Color.fromHex(code: '#EEEEEE'),
                ),
              ),
            ),
            domainAxis: new charts.OrdinalAxisSpec(
              tickFormatterSpec: new charts.BasicOrdinalTickFormatterSpec(),
              renderSpec: charts.SmallTickRendererSpec(
                
                tickLengthPx: 0, 
                
                labelStyle: charts.TextStyleSpec(
                  
                  color: charts.Color.fromHex(code: '#999999'),
                ),
                axisLineStyle: charts.LineStyleSpec(
                  
                  color: charts.Color.fromHex(code: '#EEEEEE'),
                ),
              ),
            ),
            selectionModels: [
              charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChange,
              ),
            ],
          ),
        ),
        _moneySelect != null
            ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  width: 150.0,
                  
                  child: Column(
                    children: <Widget>[
                      Text(
                        "$_timeSelect",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(name: "USD")
                            .format(_moneySelect),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}


class BarChartMonthModel {
  final String month;
  final double money;

  BarChartMonthModel(this.month, this.money);
}
