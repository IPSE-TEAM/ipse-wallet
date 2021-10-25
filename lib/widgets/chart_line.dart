/// Example of timeseries chart with custom measure and domain formatters.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyChartLine extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MyChartLine(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory MyChartLine.withSampleData() {
    return new MyChartLine(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  _MyChartLineState createState() => _MyChartLineState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<LineChartModel, DateTime>> _createSampleData() {
    final data = [
      new LineChartModel(new DateTime(2017, 9, 25), 6),
      new LineChartModel(new DateTime(2017, 9, 26), 8),
      new LineChartModel(new DateTime(2017, 9, 27), 6),
      new LineChartModel(new DateTime(2017, 9, 28), 9),
      new LineChartModel(new DateTime(2017, 9, 29), 11),
      new LineChartModel(new DateTime(2017, 9, 30), 15),
      new LineChartModel(new DateTime(2017, 10, 01), 25),
      new LineChartModel(new DateTime(2017, 10, 02), 33),
      new LineChartModel(new DateTime(2017, 10, 03), 27),
      new LineChartModel(new DateTime(2017, 10, 04), 31),
      new LineChartModel(new DateTime(2017, 10, 05), 23),
    ];

    return [
      new charts.Series<LineChartModel, DateTime>(
        id: 'Cost',
        domainFn: (LineChartModel row, _) => row.time,
        measureFn: (LineChartModel row, _) => row.money,
        data: data,
      )
    ];
  }
}

class _MyChartLineState extends State<MyChartLine> {
  DateTime _timeSelect;
  int _moneySelect;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    setState(() {
      _moneySelect = null;
      if (selectedDatum.isNotEmpty) {
        _timeSelect = selectedDatum.first.datum.time;
        _moneySelect = selectedDatum.first.datum.money;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Formatter for numeric ticks using [NumberFormat] to format into currency
    ///
    /// This is what is used in the [NumericAxisSpec] below.
    final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            new NumberFormat.compactSimpleCurrency(name: "CNY"));

    /// Formatter for numeric ticks that uses the callback provided.
    ///
    /// Use this formatter if you need to format values that [NumberFormat]
    /// cannot provide.
    ///
    /// To see this formatter, change [NumericAxisSpec] to use this formatter.
    // final customTickFormatter =
    //   charts.BasicNumericTickFormatterSpec((num value) => '¥$value');

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: new charts.TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            // Sets up a currency formatter for the measure axis.
            primaryMeasureAxis: new charts.NumericAxisSpec(
                tickFormatterSpec: simpleCurrencyFormatter),
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],

            /// Customizes the date tick formatter. It will print the day of month
            /// as the default format, but include the month and year if it
            /// transitions to a new month.
            ///
            /// minute, hour, day, month, and year are all provided by default and
            /// you can override them following this pattern.
            domainAxis: new charts.DateTimeAxisSpec(
              // renderSpec:,
              showAxisLine: true,
              tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'yyyy-MM-dd'),
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
                        NumberFormat.simpleCurrency(name: "CNY")
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

/// Sample time series data type.
class LineChartModel {
  final DateTime time;
  final int money;
  LineChartModel(this.time, this.money);
}
