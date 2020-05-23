import 'package:flutter/material.dart';

class Inview extends StatefulWidget {
  const Inview({
    this.child,
    this.onEnter,
    this.onExit,
  });

  final Widget child;
  final VoidCallback onEnter;
  final VoidCallback onExit;

  @override
  _InviewState createState() => _InviewState();
}

class _InviewState extends State<Inview> {
  ScrollController _scrollController;
  ScrollableState _scrollableState;
  bool _currentlyInView = false;
  int _delays = 0;

  @override
  Widget build(BuildContext context) => widget.child;

  void _updateScrollController() {
    if (context is! BuildContext) {
      return;
    }

    final ScrollableState _state = Scrollable.of(context);
    if (_state is! ScrollableState) {
      return;
    }

    final ScrollController _controller = _state.widget.controller;
    if (_controller is! ScrollController) {
      return;
    }

    _scrollableState = _state;
    _removeScrollHandler();
    _scrollController = _controller;
    _addScrollHandler();
  }

  void _handleScroll() {
    /// check we have a context, because it is required to fetch [RenderBox] types
    if (context is! BuildContext) {
      return;
    }

    /// update the scrollable state if it is not set yet
    if (_scrollableState is! ScrollableState) {
      _updateScrollController();
    }

    /// bail if we still do not have a scrollable state
    if (_scrollableState is! ScrollableState) {
      return;
    }

    /// calculate the upper left and bottom right corners of the scrollable container
    final RenderBox parentRenderBox = _scrollableState.context.findRenderObject();
    final Size parentSize = parentRenderBox.size;
    final Offset parentUpperLeft = parentRenderBox.localToGlobal(Offset.zero);
    final Offset parentBottomRight = Offset(
      parentUpperLeft.dx + parentSize.width,
      parentUpperLeft.dy + parentSize.height,
    );

    /// fetch data about current widget, so we can calculate the upper left and bottom right corners for this too
    final RenderBox myRenderBox = context.findRenderObject();
    final Size mySize = myRenderBox.size;

    /// if the child widget is not yet rendered, then delay until it is (or max 3 seconds)
    if (_delays <= 30 && (mySize.height == 0 || mySize.width == 0)) {
      _delays += 1;
      Future<void>.delayed(Duration(milliseconds: 100), _handleScroll);
      return;
    }
    _delays = 0;

    /// actually calculate the upper left and bottom right corners for this inview widget
    final Offset myUpperLeft = myRenderBox.localToGlobal(Offset.zero);
    final Offset myBottomRight = Offset(
      myUpperLeft.dx + mySize.width,
      myUpperLeft.dy + mySize.height,
    );

    /// inview widgets are only visible if both visible horizontally and vertaically
    bool verticallyVisible = false;
    bool horizontallyVisible = false;

    /// calculate horizontal visibility.
    if (_isWithin(parentBottomRight.dx, myUpperLeft.dx, myBottomRight.dx)) {
      /// 1. if the viewport's bottom right corner is within the inview widget horizontally
      horizontallyVisible = true;
    } else if (_isWithin(parentUpperLeft.dx, myUpperLeft.dx, myBottomRight.dx)) {
      /// 2. if the viewport's upper corner is within the inview widget horizontally
      horizontallyVisible = true;
    }

    /// calculate vertical visibility.
    if (_isWithin(parentBottomRight.dy, myUpperLeft.dy, myBottomRight.dy)) {
      /// 1. if the viewport's bottom right corner is within the inview widget vertically
      verticallyVisible = true;
    } else if (_isWithin(parentUpperLeft.dy, myUpperLeft.dy, myBottomRight.dy)) {
      /// 2. if the viewport's upper corner is within the inview widget vertically
      verticallyVisible = true;
    }

    /// finally, if both horizontally and vertically visible, then mark visible. otherwise, mark not-visible
    if (horizontallyVisible && verticallyVisible) {
      _updateInView(true);
    } else {
      _updateInView(false);
    }
  }

  void _updateInView(bool value) {
    /// if there is no change, then bail
    if (_currentlyInView == value) {
      return;
    }
    _currentlyInView = value;

    if (value && widget.onEnter is VoidCallback) {
      widget.onEnter();
    } else if (!value && widget.onExit is VoidCallback) {
      widget.onExit();
    }
  }

  bool _isWithin(num testValue, num minValue, num maxValue) => testValue >= minValue && testValue <= maxValue;

  void _addScrollHandler() {
    _scrollController.addListener(_handleScroll);
  }

  void _removeScrollHandler() {
    _scrollController?.removeListener(_handleScroll);
  }

  void _onFirstDraw(Duration _) {
    _handleScroll();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_onFirstDraw);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(Inview oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
