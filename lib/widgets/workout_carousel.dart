import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class WorkoutCarousel extends StatefulWidget {
  const WorkoutCarousel({Key? key}) : super(key: key);

  @override
  State<WorkoutCarousel> createState() => _WorkoutCarouselState();
}

class _WorkoutCarouselState extends State<WorkoutCarousel> {
  final _controller = CarouselController();
  int _current = 0;

  final _items = [
    {'name': 'Push-Ups', 'img': 'https://i.imgur.com/Jz7P1OQ.jpg'},
    {'name': 'Plank', 'img': 'https://i.imgur.com/9PRghcI.jpg'},
    {'name': 'Abs', 'img': 'https://i.imgur.com/1oRzPBI.jpg'},
    {'name': 'Cardio', 'img': 'https://i.imgur.com/CL9NwKq.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: _items.length,
          options: CarouselOptions(
            height: 250,
            viewportFraction: 0.7,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            onPageChanged: (i, reason) => setState(() => _current = i),
          ),
          itemBuilder: (context, index, realIdx) {
            final item = _items[index];
            final isCenter = index == _current;
            return _WorkoutCard(
              name: item['name']!,
              imgUrl: item['img']!,
              isFocused: isCenter,
            );
          },
        ),
      ],
    );
  }
}

class _WorkoutCard extends StatefulWidget {
  final String name;
  final String imgUrl;
  final bool isFocused;
  const _WorkoutCard({Key? key, required this.name, required this.imgUrl, required this.isFocused}) : super(key: key);

  @override
  State<_WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<_WorkoutCard> with SingleTickerProviderStateMixin {
  bool _flipped = false;
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    setState(() => _flipped = !_flipped);
    if (_flipped) {
      _anim.forward();
    } else {
      _anim.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final glow = BoxShadow(
      color: Colors.blue.withOpacity(0.4),
      blurRadius: widget.isFocused ? 20 : 8,
      spreadRadius: 1,
    );

    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          final angle = _anim.value * 3.1416; // radians
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: angle <= 1.57 ? _buildFront(glow) : _buildBack(glow),
          );
        },
      ),
    );
  }

  Widget _buildFront(BoxShadow glow) {
    return _GlassCard(
      glow: glow,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(widget.imgUrl, fit: BoxFit.cover),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.name,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BoxShadow glow) {
    return _GlassCard(
      glow: glow,
      child: Center(
        child: Text(
          'Details for ${widget.name}',
          style: const TextStyle(fontSize: 16, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final BoxShadow glow;
  const _GlassCard({Key? key, required this.child, required this.glow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [glow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
} 