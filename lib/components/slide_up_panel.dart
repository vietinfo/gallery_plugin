part of flutter_plugin_gallery;

///On panel status changed
typedef OnSlidingUpPanelStatusChanged = void Function(
    SlidingUpPanelStatus status);

const Duration _kSlidingUpPanelDuration = Duration(milliseconds: 400);
const double _kMinFlingVelocity = 100.0;
const double _kCloseProgressThreshold = 0.2;

///Sliding up panel status enum
enum SlidingUpPanelStatus {
  ///The panel is fully expanded
  expanded,

  ///The panel is anchored
  anchored,

  ///The panel is hidden
  hidden,

  ///The panel is dragging
  ///todo
  dragging,
}
class SlideUpPanelWidget extends StatefulWidget {
  ///Child widget
  final Widget body;
  final Widget header;

  /// The animation that controls the bottom sheet's position.
  ///
  /// The BottomSheet widget will manipulate the position of this animation, it
  /// is not just a passive observer.

  ///The controller of the panel
  final SlidingUpPanelController panelController;

  /// Called when the bottom sheet begins to close.
  ///
  /// The panel might be prevented from closing (e.g., by user
  /// interaction) even after this callback is called. For this reason, this
  /// callback might be call multiple times for a given bottom sheet.
  final OnSlidingUpPanelStatusChanged? onStatusChanged;

  ///Void callback when click control bar
  final VoidCallback? onTap;


  ///Enable the tap callback for control bar
  final bool enableOnTap;

  ///Elevation of the panel
  final double elevation;

  ///Panel status
  final SlidingUpPanelStatus panelStatus;

  ///Anchor
  final double anchor;

  SlideUpPanelWidget({
    required this.body,
    required this.header,
    required this.panelController,
    this.onStatusChanged,
    this.onTap,
    this.enableOnTap = true,
    this.elevation = 0.0,
    this.panelStatus = SlidingUpPanelStatus.hidden,
    this.anchor = 0.5,
  });

  @override
  State<StatefulWidget> createState() {
    return _SlideUpPanelWidgetState();
  }

  static SlideUpPanelWidget? of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<SlideUpPanelWidget>();
  }

  /// Creates an animation controller suitable for controlling a [SlideUpPanelWidget].
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      duration: _kSlidingUpPanelDuration,
      debugLabel: 'SlidingUpPanelWidget',
      vsync: vsync,
    );
  }
}

class _SlideUpPanelWidgetState extends State<SlideUpPanelWidget>
    with SingleTickerProviderStateMixin<SlideUpPanelWidget> {
  late Animation<Offset> animation;

  final GlobalKey _childKey =
  GlobalKey(debugLabel: 'SlidingUpPanelWidget child');

  double? get _childHeight {
    final RenderBox? renderBox = _childKey.currentContext?.findAncestorRenderObjectOfType<RenderBox>();
    if(renderBox != null)
      return renderBox.size.height;
    return null;
  }

  late AnimationController _animationController;

  double upperBound = 1.0;

  double anchorFraction = 0.5;

  double collapseFraction = 0.0;

  @override
  void initState() {
    upperBound = 1.0;
    widget.panelController.addListener(handlePanelStatusChanged);
      _animationController =
          SlideUpPanelWidget.createAnimationController(this);
    animation = _animationController.drive(
      Tween(begin: Offset(0.0, upperBound), end: Offset.zero).chain(
        CurveTween(
          curve: Curves.linear,
        ),
      ),
    );
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _initData(context));
  }

  void _initData(BuildContext context) {
    widget.panelController.value = widget.panelStatus;
    switch (widget.panelController.status) {
      case SlidingUpPanelStatus.anchored:
        _animationController.value = anchorFraction;
        break;
      case SlidingUpPanelStatus.expanded:
        _animationController.value = 1.0;
        break;
      case SlidingUpPanelStatus.hidden:
        _animationController.value = 0.0;
        break;
      default:
        _animationController.value = collapseFraction;
        break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: false,
      removeBottom: true,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return SlideTransition(
              child: child,
              position: animation,
            );
          },
          child: GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Material(
              key: _childKey,
              color: Colors.transparent,
              elevation: widget.elevation,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                          color: const Color(0x11000000))
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                          onTap: widget.enableOnTap
                              ? (widget.onTap ??
                                  () {
                                if (SlidingUpPanelStatus.anchored ==
                                    widget.panelController.status) {
                                  hide();
                                } else if (SlidingUpPanelStatus.expanded ==
                                    widget.panelController.status) {
                                  hide();
                                } else {
                                  hide();
                                }
                              })
                              : null,
                          child: widget.header),
                      Divider(
                        height: 0.5,
                        color: Colors.grey[300],
                      ),
                      Flexible(
                        child: widget.body
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                )
              ),
            ),
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }

  ///Handle method when user drag the panel
  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -=
        details.primaryDelta! / (_childHeight ?? details.primaryDelta!);
  }

  ///Handle method when user release drag.
  void _handleDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy < -_kMinFlingVelocity) {
     if ((SlidingUpPanelStatus.anchored ==
          widget.panelController.status)) {
        expand();
      } else {
        expand();
      }
    } else if (details.velocity.pixelsPerSecond.dy > _kMinFlingVelocity) {
      if (SlidingUpPanelStatus.expanded == widget.panelController.status) {
        anchor();
      } else if ((SlidingUpPanelStatus.anchored ==
          widget.panelController.status)) {
        hide();
      } else {
        hide();
      }
    } else if (_animationController.value < _kCloseProgressThreshold) {
      hide();
    } else if ((_animationController.value >=
        (anchorFraction + upperBound) / 2)) {
      expand();
    } else if (_animationController.value >= _kCloseProgressThreshold &&
        _animationController.value < (anchorFraction + upperBound) / 2) {
      anchor();
    } else {
      hide();
    }
  }

  ///Expand the panel
  void expand() {
    _animationController.animateTo(1.0,
        curve: Curves.linearToEaseOut, duration: _kSlidingUpPanelDuration);
    widget.panelController.value = SlidingUpPanelStatus.expanded;
    widget.onStatusChanged?.call(widget.panelController.status);
  }

  ///Anchor the panel
  void anchor() {
    _animationController.animateTo(anchorFraction,
        curve: Curves.linearToEaseOut, duration: _kSlidingUpPanelDuration);
    widget.panelController.value = SlidingUpPanelStatus.anchored;
    widget.onStatusChanged?.call(widget.panelController.status);
  }

  ///Hide the panel
  void hide() {
    _animationController.animateTo(0.0,
        curve: Curves.linearToEaseOut, duration: _kSlidingUpPanelDuration);
    widget.panelController.value = SlidingUpPanelStatus.hidden;
    widget.onStatusChanged?.call(widget.panelController.status);
  }

  ///Handle the status changed of panel
  void handlePanelStatusChanged() {
    widget.onStatusChanged?.call(widget.panelController.value);
    switch (widget.panelController.value) {
      case SlidingUpPanelStatus.anchored:
        anchor();
        break;
      case SlidingUpPanelStatus.expanded:
        expand();
        break;
      case SlidingUpPanelStatus.hidden:
        hide();
        break;
      default:
        hide();
        break;
    }
  }

  void setStateSafe(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }
}

///The controller of SlidingUpPanelWidget
class SlidingUpPanelController extends ValueNotifier<SlidingUpPanelStatus> {
  SlidingUpPanelController({SlidingUpPanelStatus? value})
      : super(value != null ? value : SlidingUpPanelStatus.hidden);

  SlidingUpPanelStatus get status => value;

  ///Expand the panel
  void expand() {
    value = SlidingUpPanelStatus.expanded;
  }

  ///Anchor the panel
  void anchor() {
    value = SlidingUpPanelStatus.anchored;
  }

  ///Hide the panel
  void hide() {
    value = SlidingUpPanelStatus.hidden;
  }
}