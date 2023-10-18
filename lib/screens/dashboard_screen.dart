import 'package:flutter/material.dart';
import 'package:tore_huber_web/widgets/dashboard_widgets/views/normal_view.dart';
import 'package:tore_huber_web/widgets/dashboard_widgets/views/small_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int serviceReportsCount = 0;
  int protocolsCount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ),
      child: SingleChildScrollView(
        child: MediaQuery.of(context).size.width > 1400
            ? NormalView(
                serviceReportsCount: serviceReportsCount,
                protocolsCount: protocolsCount,
              )
            : SmallView(
                serviceReportsCount: serviceReportsCount,
                protocolsCount: protocolsCount,
              ),
      ),
    );
  }
}
