import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/components/bloc/AnalyticsBloc/analytics_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../theme/colors.dart';
import '../../utils/helper/styles.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView>
    with TickerProviderStateMixin {
  List<int> xAxis = [];
  List<String> month = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> barTouchData = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<int> yAxis = [];
  String xTitle = "";
  String yTitle = "";
  late TabController tabController;
  final analyticsBlocBloc = AnalyticsBlocBloc();
  int selectedMonth = -1;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    analyticsBlocBloc.add(AnalyticsLoadEvent());
    barTouchData = month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: AppStyles.setAppStyle(black, 20, FontWeight.bold, 'black'),
        ),
        forceMaterialTransparency: true,
        leading: Icon(Icons.analytics_outlined),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // Moves content up
                  ),
                  child: AnalyticsChatBottomSheet(analyticsChatBloc: analyticsBlocBloc),
                );
              });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          shape:
          CircleBorder(side: BorderSide(color: border, width: 0.5)),
          minimumSize: const Size(50, 50),
        ),
        child: Icon(
          Icons.star,
          size: 35,
          color: Colors.green,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AnalyticsBlocBloc, AnalyticsBlocState>(
          bloc: analyticsBlocBloc,
          builder: (context, state) {
            if (state is AnalyticsLoadingState) {
              return Center(child: SpinKitCircle(color: primary,));
            }
            if (state is AnalyticsLoadedState) {
              xAxis = state.xList;
              yAxis = state.yList;
              xTitle = state.xTitle;
              yTitle = state.yTitle;
              selectedMonth = state.selectedMonth;

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < 12; i++)
                            monthlyExpenseContainer(
                                value: state.yList[i],
                                month: month[i],
                                expense: state.yList[i],
                                income: state.yList[i] + 500,
                                index: i,
                                isSelected: selectedMonth == i,
                                onTap: () {
                                  analyticsBlocBloc.add(AnalyticsMonthSelectedEvent(i));
                                }
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Show weekly data if a month is selected, otherwise show monthly data
                    if (selectedMonth >= 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${month[selectedMonth]} Weekly Analytics',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                analyticsBlocBloc.add(AnalyticsMonthSelectedEvent(-1));
                              },
                              child: const Text('Back to Monthly View',style: TextStyle(overflow: TextOverflow.ellipsis),),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      weeklyExpenseGraph(
                          context,
                          List.generate(4, (index) => index),
                          state.weeklyData[selectedMonth] ?? [],
                          "Weeks",
                          "Weekly Amount",
                          selectedMonth
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < 4; i++)
                              weeklyDetailContainer(
                                week: "Week ${i + 1}",
                                expense: state.weeklyExpense[selectedMonth]?[i] ?? 0,
                                income: state.weeklyIncome[selectedMonth]?[i] ?? 0,
                              )
                          ],
                        ),
                      ),
                    ] else ...[
                      const Text('Expense Graphs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      expenseGraph(context, xAxis, yAxis, xTitle, yTitle, month),
                    ],

                    // const SizedBox(height: 20),
                    // TabBar(
                    //     controller: tabController,
                    //     dividerColor: Colors.transparent,
                    //     tabs: const [
                    //       Tab(child: Text("Expenses")),
                    //       Tab(child: Text("Stocks"))
                    //     ]
                    // ),
                  ],
                ),
              );
            }
            return const Center(child: Text("No data available"));
          },
        ),
      ),
    );
  }
}

Widget monthlyExpenseContainer({
  required int value,
  required String month,
  required int expense,
  required int income,
  required int index,
  required bool isSelected,
  required VoidCallback onTap
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      color: isSelected ? Colors.blue[100] : Colors.grey[200],
      elevation: isSelected ? 4 : 1,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Expense'),
                Text('₹$expense'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Income'),
                Text('₹$income'),
              ],
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Tap to view weekly', style: TextStyle(fontSize: 12, color: Colors.blue)),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget weeklyDetailContainer({
  required String week,
  required int expense,
  required int income,
}) {
  return Card(
    color: Colors.grey[200],
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(week, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Expense'),
              Text('₹$expense'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Income'),
              Text('₹$income'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Balance'),
              Text('₹${income - expense}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: income - expense >= 0 ? Colors.green : Colors.red
                  )),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget expenseGraph(BuildContext context, List<int> xList, List<int> yList,
    String xTitle, String yTitle, List<String> month) {
  return SizedBox(
    height: MediaQuery.of(context).size.width * 0.9,
    child: BarChart(BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        groupsSpace: 12,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  month[group.x.toInt()],
                  const TextStyle(color: Colors.white));
            },
          ),
        ),
        barGroups: [
          for (int i = 0; i < xList.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: yList[i].toDouble(),
                  fromY: 0,
                  width: 25,
                  color: Colors.blue,
                ),
              ],
              barsSpace: 4,
            ),
        ],
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(yTitle),
              sideTitles: const SideTitles(showTitles: false, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(xTitle),
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < month.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(month[value.toInt()].substring(0, 3)),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 30
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            )))),
  );
}

Widget weeklyExpenseGraph(BuildContext context, List<int> xList, List<int> yList,
    String xTitle, String yTitle, int monthIndex) {
  print("ylist data ${yList[1].toDouble()}");
  return SizedBox(
    height: MediaQuery.of(context).size.width * 0.7,
    child: BarChart(BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        groupsSpace: 12,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  "Week ${group.x.toInt() + 1}",
                  const TextStyle(color: Colors.white));
            },
          ),
        ),
        barGroups: [
          for (int i = 0; i < xList.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: yList[i].toDouble(),
                  fromY: 0,
                  width: 30,
                  color: Colors.green,
                ),
              ],
              barsSpace: 4,
            ),
        ],
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(yTitle),
              sideTitles: const SideTitles(showTitles: false, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(xTitle),
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Week ${value.toInt() + 1}"),
                    );
                  },
                  reservedSize: 30
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            )))),
  );
}
// The Bottom Sheet Widget
class AnalyticsChatBottomSheet extends StatefulWidget {
  final AnalyticsBlocBloc analyticsChatBloc;

  const AnalyticsChatBottomSheet({
    required this.analyticsChatBloc,
    Key? key,
  }) : super(key: key);

  @override
  State<AnalyticsChatBottomSheet> createState() => _AnalyticsChatBottomSheetState();
}

class _AnalyticsChatBottomSheetState extends State<AnalyticsChatBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? selectedChip;
  List<ChatMessage> messages = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Common analytics questions
    List<String> analyticsChips = [
      "Revenue Analysis",
      "Conversion Rates",
      "Growth Trends",
      "Custom Query"
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocConsumer<AnalyticsBlocBloc, AnalyticsBlocState>(
          bloc: widget.analyticsChatBloc,
          listener: (context, state) {
            if (state is AnalyticsChatBotLoadedState) {
              setState(() {
                messages.add(ChatMessage(
                  content: state.message,
                  isFromBot: true,
                  timestamp: DateTime.now(),
                ));
              });

              // Auto-scroll to bottom
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              // Clear text field after response
              _controller.clear();
            } else if (state is AnalyticsChipSelectedState) {
              setState(() {
                selectedChip = state.selectedChip;

                if (selectedChip != "Custom Query") {
                  _controller.text = selectedChip!;
                } else {
                  _controller.clear();
                }
              });
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar at the top
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header with analytics icon
                Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Analytics Assistant",
                      style: TextStyle(
                        fontFamily: "medium",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Analytics topic chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: analyticsChips.map((label) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          selected: selectedChip == label,
                          label: Text(label),
                          labelStyle: TextStyle(
                            fontWeight: selectedChip == label ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          onSelected: (value) {
                            widget.analyticsChatBloc.add(SelectAnalyticsChipEvent(label));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Chat messages area
                Flexible(
                  child: messages.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Ask me about your analytics data",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatBubble(
                        message: message.content,
                        isFromBot: message.isFromBot,
                      );
                    },
                  ),
                ),

                // Loading indicator
                if (state is AnalyticsChatBotLoadingState)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SpinKitPulse(
                        color: Theme.of(context).primaryColor,
                        size: 40.0,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Input field with send button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Ask about analytics data...",
                            hintStyle: TextStyle(
                              fontFamily: "medium",
                              color: Colors.grey.shade500,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            if (_controller.text.isNotEmpty) {
                              final query = _controller.text;

                              // Add user message to chat
                              setState(() {
                                messages.add(ChatMessage(
                                  content: query,
                                  isFromBot: false,
                                  timestamp: DateTime.now(),
                                ));
                              });

                              // Send query to bloc
                              widget.analyticsChatBloc.add(SendAnalyticsQueryEvent(query));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.send_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Chat Message Model
class ChatMessage {
  final String content;
  final bool isFromBot;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isFromBot,
    required this.timestamp,
  });
}

// Custom chat bubble widget
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isFromBot;


  const ChatBubble({
    required this.message,
    required this.isFromBot,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isFromBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFromBot)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                radius: 16,
                child: Icon(
                  Icons.analytics,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromBot
                    ? Colors.grey.shade100
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFromBot
                      ? Colors.grey.shade300
                      : Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}