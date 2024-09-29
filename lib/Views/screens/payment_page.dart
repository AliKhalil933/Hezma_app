import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedCardIndex = -1;

  void _selectCard(int index) {
    setState(() {
      _selectedCardIndex = index;
    });
  }

  void _showPaymentForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          height:
              MediaQuery.of(context).size.height * 0.75, // 75% of screen height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'تفاصيل البطاقة',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'STVBold'),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildTextField('اسم صاحب البطاقة'),
              const SizedBox(height: 16.0),
              _buildTextField('رقم البطاقة'),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: _buildTextField('تاريخ الصلاحية (MM/YY)')),
                  const SizedBox(width: 16.0),
                  Expanded(child: _buildTextField('رمز التحقق (CVV)')),
                ],
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  Navigator.pop(context);
                },
                child: Text(
                  'متابعة',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'STVBold'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> cards = [
      {'name': 'Visa', 'number': '**** **** **** 2350'},
      {'name': 'Visa', 'number': '**** **** **** 5678'},
      {'name': 'Visa', 'number': '**** **** **** 9101'},
      {'name': 'Visa', 'number': '**** **** **** 1121'},
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'اختيار بطاقة الدفع',
          style: TextStyle(fontFamily: 'STVBold'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد البطاقات في كل صف
                childAspectRatio: 180 / 240, // نسبة العرض إلى الارتفاع
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _selectCard(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedCardIndex == index
                            ? Colors.green
                            : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              child: Image.asset(
                                'assets/icons/Visa.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              cards[index]['name']!,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              cards[index]['number']!,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[700]),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.center,
                              child: Checkbox(
                                value: _selectedCardIndex == index,
                                onChanged: (bool? value) {
                                  _selectCard(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showPaymentForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'طريقة الدفع',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'STVBold'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
