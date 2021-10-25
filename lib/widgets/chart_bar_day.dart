import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartBarDay extends StatefulWidget {
  final List<charts.Series<BarDayModel, DateTime>> seriesList;
  final bool animate;

  ChartBarDay(this.seriesList, {this.animate});

  
  factory ChartBarDay.withSampleData() {
    return new ChartBarDay(
      _createSampleData(),
      
      animate: false,
    );
  }

  @override
  _ChartBarDayState createState() => _ChartBarDayState();

  
  static List<charts.Series<BarDayModel, DateTime>> _createSampleData() {
    final data = [
      new BarDayModel(new DateTime(2017, 9, 1), 5),
      new BarDayModel(new DateTime(2017, 9, 2), 5),
      new BarDayModel(new DateTime(2017, 9, 3), 25),
      new BarDayModel(new DateTime(2017, 9, 4), 100),
      new BarDayModel(new DateTime(2017, 9, 5), 75),
      new BarDayModel(new DateTime(2017, 9, 6), 88),
      new BarDayModel(new DateTime(2017, 9, 7), 65),
      new BarDayModel(new DateTime(2017, 9, 8), 91),
      new BarDayModel(new DateTime(2017, 9, 9), 100),
      new BarDayModel(new DateTime(2017, 9, 10), 111),
      new BarDayModel(new DateTime(2017, 9, 11), 90),
      new BarDayModel(new DateTime(2017, 9, 12), 50),
      new BarDayModel(new DateTime(2017, 9, 13), 40),
      new BarDayModel(new DateTime(2017, 9, 14), 30),
      new BarDayModel(new DateTime(2017, 9, 15), 40),
      new BarDayModel(new DateTime(2017, 9, 16), 50),
      new BarDayModel(new DateTime(2017, 9, 17), 30),
      new BarDayModel(new DateTime(2017, 9, 18), 35),
      new BarDayModel(new DateTime(2017, 9, 19), 40),
      new BarDayModel(new DateTime(2017, 9, 20), 32),
      new BarDayModel(new DateTime(2017, 9, 21), 31),
    ];

    return [
      new charts.Series<BarDayModel, DateTime>(
        id: 'money',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarDayModel money, _) => money.time,
        measureFn: (BarDayModel money, _) => money.money,
        data: data,
      )
    ];
  }
}

class _ChartBarDayState extends State<ChartBarDay> {
  DateTime _timeSelect;
  num _moneySelect;

  
  
  
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    if (mounted) {
      setState(() {
        _moneySelect = null;
        if (selectedDatum.isNotEmpty) {
          _timeSelect = selectedDatum.first.datum.time;
          _moneySelect = selectedDatum.first.datum.money;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            new NumberFormat.compactSimpleCurrency(name: "USD"));

    
    
    
    
    
    
    
    

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: new charts.TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            
            primaryMeasureAxis: new charts.NumericAxisSpec(
              tickFormatterSpec: simpleCurrencyFormatter,
              showAxisLine: false,
              renderSpec: new charts.GridlineRendererSpec(
                  
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
              )
              
            ),
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
            
            
            defaultRenderer: new charts.BarRendererConfig<DateTime>(),
            
            
            
            
            
            
            behaviors: [
              
              
              
              
              
              new charts.DomainHighlighter()
            ],

            
            
            
            
            
            
            domainAxis: new charts.DateTimeAxisSpec(
              
              tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'yyyy-MM-dd'),
              ),
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
          ),
        ),
        _moneySelect != null
            ? Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  width: 150.0,
                  child: Column(
                    children: <Widget>[
                      Text(
                        DateFormat("yyyy-MM-dd").format(_timeSelect),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(name: "USD")
                            .format(_moneySelect),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ))
            : Container(),
      ],
    );
  }
}


class BarDayModel {
  final DateTime time;
  final double money;

  BarDayModel(this.time, this.money);
}
