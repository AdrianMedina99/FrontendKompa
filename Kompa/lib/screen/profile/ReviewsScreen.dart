import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/dark_mode.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late ColorNotifire notifier;

  // Lista de reseñas de ejemplo
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Laura Martínez',
      'date': '12/05/2024',
      'rating': 4.5,
      'comment': 'Excelente servicio, muy recomendable. La atención fue personalizada y el precio bastante accesible.',
      'avatar': 'LM',
    },
    {
      'name': 'Carlos López',
      'date': '05/05/2024',
      'rating': 4.0,
      'comment': 'La experiencia fue buena, aunque podría mejorar en cuanto al tiempo de respuesta. El personal fue amable.',
      'avatar': 'CL',
      'response': 'Gracias por tu comentario, trabajaremos en mejorar nuestros tiempos de respuesta.',
    },
    {
      'name': 'Ana García',
      'date': '28/04/2024',
      'rating': 5.0,
      'comment': '¡Increíble! Superaron mis expectativas. Definitivamente volveré a contratar sus servicios en el futuro.',
      'avatar': 'AG',
    },
    {
      'name': 'Pedro Rodríguez',
      'date': '15/04/2024',
      'rating': 3.5,
      'comment': 'El servicio fue correcto, aunque esperaba un poco más por el precio pagado. Los eventos están bien organizados.',
      'avatar': 'PR',
    },
    {
      'name': 'María Fernández',
      'date': '03/04/2024',
      'rating': 5.0,
      'comment': 'Todo perfecto desde el principio hasta el final. La organización y la atención al cliente fueron excelentes.',
      'avatar': 'MF',
      'response': '¡Gracias María! Nos alegra que hayas disfrutado tanto de nuestro servicio.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
        title: Text(
          "Reseñas",
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: notifier.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notifier.containerColor,
              boxShadow: [
                BoxShadow(
                  color: notifier.inv.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "4.8",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: notifier.textColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "/5",
                            style: TextStyle(
                              fontSize: 16,
                              color: notifier.subtitleTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Basado en 37 reseñas",
                      style: TextStyle(
                        color: notifier.subtitleTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingBar(5, 22, width),
                    _buildRatingBar(4, 10, width),
                    _buildRatingBar(3, 3, width),
                    _buildRatingBar(2, 1, width),
                    _buildRatingBar(1, 1, width),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return _buildReviewItem(review);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$stars",
            style: TextStyle(
              color: notifier.textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.star, size: 16, color: notifier.buttonColor),
          const SizedBox(width: 8),
          Container(
            width: width * 0.3,
            height: 6,
            decoration: BoxDecoration(
              color: notifier.containerColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: notifier.inv.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: width * 0.3 * (count / 37),
                  decoration: BoxDecoration(
                    color: notifier.buttonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            count.toString(),
            style: TextStyle(
              color: notifier.subtitleTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notifier.containerColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: notifier.inv.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: notifier.buttonColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review['avatar'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: notifier.textColor,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          review['date'] ?? '',
                          style: TextStyle(
                            color: notifier.subtitleTextColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(
                            5,
                                (index) => Icon(
                              index < (review['rating'] as double).floor() ? Icons.star :
                              index < (review['rating'] as double) ? Icons.star_half : Icons.star_border,
                              color: const Color(0xffD1E50C),
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'] ?? '',
            style: TextStyle(
              color: notifier.textColor,
              fontSize: 14,
            ),
          ),
          if (review.containsKey('response') && review['response'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: notifier.backGround,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: notifier.inv.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 16,
                        color: notifier.buttonColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Respuesta del propietario",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: notifier.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review['response'],
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
