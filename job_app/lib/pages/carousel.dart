import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<String> imglist = [
    "assets/job.png",
    "assets/job2.jpg",
    "assets/job3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        items: imglist
            .map(
              (e) => Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    e,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
            .toList(),
        options: CarouselOptions(
          initialPage: 0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          enlargeCenterPage: true,
          enlargeFactor: 0.5,
          viewportFraction: 0.9,
        ),
      ),
    );
  }
}
