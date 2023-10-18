import 'package:flutter/material.dart';
import 'package:tore_huber_web/widgets/dashboard_widgets/counter_widget.dart';
import 'package:tore_huber_web/widgets/dashboard_widgets/employee_widget.dart';
import 'package:tore_huber_web/widgets/dashboard_widgets/protocols_widget.dart';
import 'package:tore_huber_web/widgets/dashboard_widgets/service_report_widget.dart';

class NormalView extends StatelessWidget {
  const NormalView({
    super.key,
    required this.serviceReportsCount,
    required this.protocolsCount,
  });

  final int serviceReportsCount;
  final int protocolsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 1,
                  child: CounterWidget(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const Expanded(
                  flex: 4,
                  child: EmployeesWidget(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
        const Expanded(
          flex: 1,
          child: ProtocolsWidget(),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
        const Expanded(
          flex: 1,
          child: ServiceReportWidget(),
        ),
      ],
    );
  }
}
