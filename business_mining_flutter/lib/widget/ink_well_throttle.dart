import 'dart:async';

import 'package:business_mining/common/global.dart';
import 'package:business_mining/provider/view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///限流点击
///默认防重复点击间隔2s

class InkWellThrottle extends StatefulWidget {
  final Duration throttle;
  final Widget child;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onHighlightChanged;
  final ValueChanged<bool> onHover;
  final MouseCursor mouseCursor;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final MaterialStateProperty<Color> overlayColor;
  final Color splashColor;
  final InteractiveInkFeatureFactory splashFactory;
  final double radius;
  final BorderRadius borderRadius;
  final ShapeBorder customBorder;
  final bool enableFeedback;
  final bool excludeFromSemantics;
  final FocusNode focusNode;
  final bool canRequestFocus;
  final ValueChanged<bool> onFocusChange;
  final bool autofocus;

  InkWellThrottle({
    Key key,
    this.throttle = const Duration(seconds: 2),
    this.child,
    this.onTap,
    this.onHighlightChanged,
    this.onHover,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.overlayColor,
    this.splashColor,
    this.splashFactory,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.autofocus = false,
  }) : super(key: key);

  @override
  _InkWellThrottleState createState() => _InkWellThrottleState();
}

class _InkWellThrottleState extends State<InkWellThrottle> {
  Timer _timer;
  GestureTapCallback wrappedTap;

  @override
  void initState() {
    wrappedTap = _throttle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: widget.key,
      child: widget.child,
      onTap: wrappedTap,
      onDoubleTap: null,
      onLongPress: null,
      onTapDown: null,
      onTapCancel: null,
      onHighlightChanged: widget.onHighlightChanged,
      onHover: widget.onHover,
      mouseCursor: widget.mouseCursor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      highlightColor: widget.highlightColor,
      overlayColor: widget.overlayColor,
      splashColor: widget.splashColor,
      splashFactory: widget.splashFactory,
      radius: widget.radius,
      borderRadius: widget.borderRadius,
      customBorder: widget.customBorder,
      enableFeedback: widget.enableFeedback ?? true,
      excludeFromSemantics: widget.excludeFromSemantics ?? false,
      focusNode: widget.focusNode,
      canRequestFocus: widget.canRequestFocus ?? true,
      onFocusChange: widget.onFocusChange,
      autofocus: widget.autofocus ?? false,
    );
  }

  GestureTapCallback _throttle() {
    if (widget.onTap == null) {
      return null;
    }
    return () {
      if (_timer == null) {
        _timer = Timer(widget.throttle, () {
          _timer.cancel();
          _timer = null;
        });
        widget.onTap?.call();
      } else {
        logger.d('点击冷却时间:${_timer.isActive}');
      }
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

typedef StateWidgetBuilder = Widget Function(
    BuildContext context, ViewState state);

class StateChangeNotification extends Notification {
  final ViewState state;

  StateChangeNotification(this.state);
}

class StateChangeWidget extends StatefulWidget {
  final ViewState init;
  final StateWidgetBuilder builder;

  StateChangeWidget({
    Key key,
    this.init = ViewState.idle,
    this.builder,
  }) : super(key: key);

  @override
  _StateChangeWidgetState createState() => _StateChangeWidgetState();
}

class _StateChangeWidgetState extends State<StateChangeWidget> {
  ViewState _state;

  @override
  void initState() {
    _state = widget.init;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<StateChangeNotification>(
      onNotification: (notification) {
        changeState(notification.state);
        return false;
      },
      child: widget.builder(context, _state),
    );
  }

  void changeState(ViewState state) {
    if (_state == state) {
      return;
    }
    setState(() {
      _state = state;
    });
  }
}
