import 'package:flutter/material.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/services/utils_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentDialog extends StatelessWidget {
  final OrderModel order;

  const PaymentDialog({ Key? key, required this.order }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Pagamento com Pix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                ),

                QrImage(
                  data: '1234500',
                  version: QrVersions.auto,
                  size: 200,
                ),

                Text(
                  'Vencimento: ${UtilsServices.formatDateTime(order.overdueDateTime)}',
                  style: const TextStyle(
                    fontSize: 12
                  ),
                ),

                Text(
                  'Total: ${UtilsServices.priceToCurrecy(order.total)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  ),
                ),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green
                    )
                  ),
                  onPressed: () {}, 
                  icon: const Icon(
                    Icons.copy,
                    size: 15,
                  ), 
                  label: const Text(
                    'Copiar código Pix',
                    style: TextStyle(fontSize: 13),
                  )
                )
              ],
            ),
          ),
          Positioned(   
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      )
    );
  }
}