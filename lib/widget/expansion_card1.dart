// import 'package:flutter/material.dart';

// const Duration _kExpand = Duration(milliseconds: 200);

// class ExpansionCard extends StatefulWidget {
//   final Widget? alwaysShowingChild;
//   final ValueChanged<bool>? onExpansionChanged;
//   final List<Widget>? children;
//   final Color? backgroundColor;
//   final bool? initiallyExpanded;
//   final bool? maintainState;
//   final Alignment? expandedAlignment;
//   final EdgeInsetsGeometry? childrenPadding;
//   final dynamic expandedCrossAxisAlignment;

//   const ExpansionCard({
//     Key? key,
//     this.alwaysShowingChild,
//     this.backgroundColor,
//     this.onExpansionChanged,
//     this.children = const <Widget>[],
//     this.initiallyExpanded = false,
//     this.maintainState = false,
//     this.expandedCrossAxisAlignment,
//     this.expandedAlignment,
//     this.childrenPadding,
//   })  : assert(initiallyExpanded != null),
//         assert(maintainState != null),
//         assert(
//           expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
//           'CrossAxisAlignment.baseline is not supported since the expanded children '
//           'are aligned in a column, not a row. Try to use another constant.',
//         ),
//         super(key: key);

//   @override
//   _ExpansionCardState createState() => _ExpansionCardState();
// }

// class _ExpansionCardState extends State<ExpansionCard>
//     with SingleTickerProviderStateMixin {
//   static final Animatable<double> _easeOutTween =
//       CurveTween(curve: Curves.easeOut);
//   static final Animatable<double> _easeInTween =
//       CurveTween(curve: Curves.easeIn);

//   final ColorTween _borderColorTween = ColorTween();
//   final ColorTween _headerColorTween = ColorTween();
//   final ColorTween _backgroundColorTween = ColorTween();

//   late AnimationController _controller;
//   late Animation<double> _heightFactor;
//   late Animation<Color?> _backgroundColor;

//   bool _isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: _kExpand, vsync: this);
//     _heightFactor = _controller.drive(_easeInTween);
//     _backgroundColor =
//         _controller.drive(_backgroundColorTween.chain(_easeOutTween));

//     _isExpanded = PageStorage.of(context)?.readState(context) as bool ??
//         widget.initiallyExpanded;
//     if (_isExpanded) _controller.value = 1.0;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleTap() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _controller.forward();
//       } else {
//         _controller.reverse().then<void>((void value) {
//           if (!mounted) return;
//           setState(() {
//             // Rebuild without widget.children.
//           });
//         });
//       }
//       PageStorage.of(context)?.writeState(context, _isExpanded);
//     });
//     if (widget.onExpansionChanged != null) {
//       widget.onExpansionChanged!(_isExpanded);
//     }
//   }

//   Widget _buildChildren(BuildContext context, Widget? child) {
//     const Color borderSideColor = Colors.transparent;

//     return Container(
//       decoration: BoxDecoration(
//         color: _backgroundColor.value,
//         border: const Border(
//           top: BorderSide(color: borderSideColor),
//           bottom: BorderSide(color: borderSideColor),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           GestureDetector(
//             onTap: _handleTap,
//             behavior: HitTestBehavior.opaque,
//             child: Container(
//               child: widget.alwaysShowingChild,
//             ),
//           ),
//           ClipRect(
//             child: Align(
//               alignment: widget.expandedAlignment!,
//               heightFactor: _heightFactor.value,
//               child: child,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     final ThemeData theme = Theme.of(context);
//     _borderColorTween.end = theme.dividerColor;
//     _headerColorTween
//       ..begin = theme.textTheme.subtitle1?.color
//       ..end = theme.accentColor;
//     _backgroundColorTween.end = widget.backgroundColor;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool closed = !_isExpanded && _controller.isDismissed;
//     final bool shouldRemoveChildren = closed && !widget.maintainState!;

//     final Widget result = Offstage(
//         child: TickerMode(
//           child: Padding(
//             padding: widget.childrenPadding!,
//             child: Column(
//               crossAxisAlignment: widget.expandedCrossAxisAlignment,
//               children: widget.children!,
//             ),
//           ),
//           enabled: !closed,
//         ),
//         offstage: closed);

//     return AnimatedBuilder(
//       animation: _controller.view,
//       builder: _buildChildren,
//       child: shouldRemoveChildren ? null : result,
//     );
//   }
// }
