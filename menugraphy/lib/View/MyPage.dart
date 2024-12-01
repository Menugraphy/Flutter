import 'package:flutter/material.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'OrderList.dart';
import 'package:menugraphy/Network/APIProvider.dart';
import 'package:menugraphy/Model/OrderHistory.dart';
import 'package:menugraphy/Model/LikeFood.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiProvider _apiProvider = ApiProvider();
  List<OrderHistory> _orderHistories = [];
  bool _isLoading = true;
  List<LikedFood> _likedFoods = [];
  bool _isLoadingLikes = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchOrderHistories();
    _fetchLikedFoods();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrderHistories() async {
    try {
      final response = await _apiProvider.getOrderHistories();
      if (response['status'] == 'success' && mounted) {
        final List<dynamic> historyList = response['data']['orderHistoryList'];
        setState(() {
          _orderHistories =
              historyList.map((item) => OrderHistory.fromJson(item)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Page',
          style: TextStyle(color: CustomColorsExtension.text_gray03),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: CustomColorsExtension.mainColor01,
            unselectedLabelColor: CustomColorsExtension.text_gray02,
            indicatorColor: CustomColorsExtension.mainColor01,
            tabs: const [
              Tab(text: 'History'),
              Tab(text: 'Like'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHistoryTab(),
                _buildLikeTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_orderHistories.isEmpty) {
      return Center(child: Text('No order history'));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: _orderHistories.length,
      itemBuilder: (context, index) {
        final history = _orderHistories[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  history.orderedAt,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 15),
                        ...List.generate(
                          history.menuOrderList.length,
                          (index) => Column(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CustomColorsExtension.mainColor01,
                                ),
                              ),
                              if (index != history.menuOrderList.length - 1)
                                SizedBox(
                                  width: 1,
                                  height: 50,
                                  child: CustomPaint(
                                    painter: DashedLinePainter(
                                      color: CustomColorsExtension.mainColor01,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: history.menuOrderList.map((menuOrder) {
                          return Column(
                            children: [
                              _buildOrderItem('🍽️', menuOrder.menuName,
                                  '${menuOrder.menuCount}ea'),
                              SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${history.totalPrice}원 ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '(${history.localizedTotalPrice})',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // 메뉴 보기 기능 구현
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColorsExtension.mainColor02,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Show Menu',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(String emoji, String name, String quantity) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 20),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
          decoration: BoxDecoration(
            color: CustomColorsExtension.mainColor01,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            quantity,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchLikedFoods() async {
    try {
      final response = await _apiProvider.getLikedFoods();
      if (response['status'] == 'success' && mounted) {
        final List<dynamic> foodList = response['data']['likedFoodList'];
        setState(() {
          _likedFoods =
              foodList.map((item) => LikedFood.fromJson(item)).toList();
          _isLoadingLikes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLikes = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Widget _buildLikeTab() {
    if (_isLoadingLikes) {
      return Center(child: CircularProgressIndicator());
    }

    if (_likedFoods.isEmpty) {
      return Center(child: Text('No liked foods'));
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _likedFoods.length,
      itemBuilder: (context, index) {
        final food = _likedFoods[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            food.foodImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite,
                          color: CustomColorsExtension.mainColor01,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        ...food.foodTypeList.take(3).map((type) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                color: CustomColorsExtension.mainColor01,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                type.name,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        if (food.foodTypeList.length > 3)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),                
                            child: Text(
                              '...',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: CustomColorsExtension.mainColor01,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      food.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const double dashHeight = 3;
    const double dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
