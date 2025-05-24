import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableInfoCard extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Color backgroundColor;
  final Color textColor;
  final Color? headerColor;
  final Color? shadowColor;

  const ExpandableInfoCard({
    Key? key,
    required this.title,
    required this.children,
    required this.backgroundColor,
    required this.textColor,
    this.headerColor,
    this.shadowColor,
  }) : super(key: key);

  @override
  State<ExpandableInfoCard> createState() => _ExpandableInfoCardState();
}

class _ExpandableInfoCardState extends State<ExpandableInfoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = widget.headerColor ?? widget.backgroundColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor?.withOpacity(0.2) ?? Colors.transparent,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Encabezado con color buttonColor
          Material(
            color: headerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(15),
                bottom: _isExpanded ? Radius.zero : const Radius.circular(15),
              ),
            ),
            child: InkWell(
              onTap: _handleTap,
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(15),
                bottom: _isExpanded ? Radius.zero : const Radius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.textColor,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Contenido con backgroundColor
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: const Radius.circular(15)),
            child: AnimatedCrossFade(
              firstChild: const SizedBox(height: 0),
              secondChild: Material(
                color: widget.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.children,
                  ),
                ),
              ),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ],
      ),
    );
  }
}