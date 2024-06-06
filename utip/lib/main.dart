import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utip/providers/ThemeProvider.dart';
import 'package:utip/providers/TipCalculatorModel.dart';
import 'package:utip/widgets/bill_amount_field.dart';
import 'package:utip/widgets/person_counter.dart';
import 'package:utip/widgets/tip_row.dart';
import 'package:utip/widgets/tip_slider.dart';
import 'package:utip/widgets/toggle_theme_button.dart';
import 'package:utip/widgets/total_per_person.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TipCalculatorModel()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: themeProvider.currentTheme,
        home: const UTip());
  }
}

class UTip extends StatefulWidget {
  const UTip({super.key});

  @override
  State<UTip> createState() => _UTipState();
}

class _UTipState extends State<UTip> {
  int _personCount = 1;
  double _tipPercentage = 0.0;
  double _billTotal = 100;

  double totalPerPerson() {
    return ((_billTotal * (1 + _tipPercentage)) / _personCount);
  }

  double totalTip() {
    return ((_billTotal * _tipPercentage));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final model = Provider.of<TipCalculatorModel>(context);
    var theme = Theme.of(context);
    
    final style = theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold);

    return Scaffold(
        appBar: AppBar(title: Text('UTip'), actions: [
          ToggleThemeButton(),
        ],),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TotalPerPerson(style: style, total: model.totalPerPerson, theme: theme),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                        Border.all(color: theme.colorScheme.primary, width: 2)),
                child: Column(
                  children: [
                    BillAmountField(
                      billAmount: model.billTotal.toString(),
                      onChanged: (value) {
                        model.updateBillTotal(double.parse(value));
                      },
                    ),
                    // Split bill area
                    PersonCounter(
                      theme: theme,
                      personCount: model.personCount,
                      onDecrement: () {
                        if(model.personCount > 1){
                          model.updatePersonCount(model.personCount - 1);
                        }
                      },
                      onIncrement: () {
                        model.updatePersonCount(model.personCount + 1);
                      },
                    ),
                    // tip section
                    TipRow(theme: theme, totalT: model.billTotal, percentage: model.tipPercentage,),

                    // slider text
                    Text('${(model.tipPercentage * 100).round()}%'),

                    // tip slider
                    TipSlider(
                      tipPercentage: model.tipPercentage,
                      onChanged: (double value) {
                       model.updateTipPercentage(value);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}