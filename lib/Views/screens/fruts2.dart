import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Services/get_prodects.dart';
import 'package:hezmaa/cubits/product_cubit.dart';
import 'package:hezmaa/widgets/custom_card3.dart';

class fruts2 extends StatelessWidget {
  const fruts2({super.key});
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(ProdectService())..fetchProducts(),
      child: Scaffold(
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductError) {
              return Center(child: Text('حدث خطأ: ${state.message}'));
            } else if (state is ProductLoaded) {
              final allProducts = state.products;

              final vegetables = allProducts
                  .where((product) => product.subCategoryId == '5')
                  .toList();

              return CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 4.0,
                            childAspectRatio: 180 / 124),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomCard3(product: vegetables[index]),
                        );
                      },
                      childCount: vegetables.length,
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('لا توجد بيانات.'));
            }
          },
        ),
      ),
    );
  }
}
