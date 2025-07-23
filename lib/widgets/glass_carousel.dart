import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CarouselItem {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  CarouselItem({required this.title, required this.imageUrl, required this.onTap});
}

class GlassCarousel extends StatefulWidget {
  final List<CarouselItem> items;
  const GlassCarousel({Key? key, required this.items}) : super(key: key);

  @override
  State<GlassCarousel> createState() => _GlassCarouselState();
}

class _GlassCarouselState extends State<GlassCarousel> {
  final _controller = CarouselController();
  int _current = 0;
  final _tapPlayer = AudioCache(prefix: 'assets/sounds/');

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: _controller,
      itemCount: widget.items.length,
      options: CarouselOptions(
        height: 250,
        viewportFraction: 0.7,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
        onPageChanged: (i, r) => setState(() => _current = i),
      ),
      itemBuilder: (context, index, realIdx) {
        final item = widget.items[index];
        final isCenter = index == _current;
        return _CarouselCard(item: item, isFocused: isCenter);
      },
    );
  }
}

class _CarouselCard extends StatefulWidget {
  final CarouselItem item;
  final bool isFocused;
  const _CarouselCard({Key? key, required this.item, required this.isFocused}) : super(key: key);

  @override
  State<_CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<_CarouselCard> with SingleTickerProviderStateMixin {
  bool _flipped = false;
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle() {
    _tapPlayer.play('card_click.mp3');
    setState(() => _flipped = !_flipped);
    _flipped ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final glow = BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: widget.isFocused?20:8, spreadRadius:1);
    return GestureDetector(
      onTap: () {
        if (!_flipped) widget.item.onTap();
        _toggle();
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child){
          final angle = _ctrl.value * 3.1416;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..setEntry(3,2,0.001)..rotateY(angle),
            child: angle<=1.57? _front(glow): _back(glow),
          );
        },
      ),
    );
  }

  Widget _front(BoxShadow glow){
    return _Glass(
      glow: glow,
      child: Stack(
        children:[
          Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(widget.item.imageUrl, fit: BoxFit.cover))),
          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(colors:[Colors.black.withOpacity(0.4),Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter))),
          Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.all(12), child: Text(widget.item.title, style: const TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white))))
        ]));
  }
  Widget _back(BoxShadow glow){
    return _Glass(glow: glow, child: Center(child: Text('Details for ${widget.item.title}', style: const TextStyle(color: Colors.white),))); }
}

class _Glass extends StatelessWidget{
  final Widget child; final BoxShadow glow;
  const _Glass({Key? key, required this.child, required this.glow}): super(key:key);
  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.symmetric(vertical:8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow:[glow]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX:10,sigmaY:10), child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.white.withOpacity(0.2))),
          child: child,
        )),
      ),
    );
  }
} 