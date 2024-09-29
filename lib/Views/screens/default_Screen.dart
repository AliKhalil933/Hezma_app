import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hezmaa/Services/get_prodects.dart';
import 'package:hezmaa/cubits/product_cubit.dart';

import 'package:hezmaa/widgets/custom_card.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(ProdectService())..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'قسم الورقيات',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'STVBold'),
          ),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductError) {
              return Center(child: Text('حدث خطأ: ${state.message}'));
            } else if (state is ProductLoaded) {
              final allProducts = state.products;

              final vegetables = allProducts
                  .where((product) =>
                      ['0', '0', '0'].contains(product.subCategoryId))
                  .toList();

              return CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return CustomCard(product: vegetables[index]);
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
