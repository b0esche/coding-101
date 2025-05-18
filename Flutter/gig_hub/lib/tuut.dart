import 'package:flutter/material.dart';

class Tuut extends StatefulWidget {
  const Tuut({super.key});

  @override
  State<Tuut> createState() => _TuutState();
}

int itemCount = 12;
int newItemCount = itemCount;

class _TuutState extends State<Tuut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mein schöner Screen"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                  child: SizedBox(
                    height: 55,
                    child: Card(
                      color: Colors.grey[300],
                      child: ListTile(leading: Text("item $index")),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 48,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        itemCount != 3 ? Colors.deepPurple : Colors.redAccent,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      itemCount == 3 ? itemCount = newItemCount : itemCount = 3;
                    });
                    debugPrint("Moin Batch 9!");
                  },
                  child: itemCount == 3 ? Text("Show More") : Text("Show Less"),
                ),
                if (itemCount != 3)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        itemCount++;
                        newItemCount = itemCount;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                        child: Column(
                          children: [
                            Text(
                              "+",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),

                            Text(
                              "Add Item",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(width: 88),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
