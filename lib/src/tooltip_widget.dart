import 'package:flutter/material.dart';

/// A widget that displays an info icon and shows a tooltip overlay when tapped.
///
/// Tapping the icon opens a modal overlay with the provided message text
/// and an "Ok" button to dismiss it. The overlay includes a brief
/// scale animation on the info icon.
class ToolTipWidget extends StatefulWidget {
  /// Creates a [ToolTipWidget] with the given [msg].
  const ToolTipWidget({super.key, required this.msg});

  /// The message text to display inside the tooltip overlay.
  final String msg;

  @override
  State<ToolTipWidget> createState() => _ToolTipWidgetState();
}

class _ToolTipWidgetState extends State<ToolTipWidget> {
  late OverlayEntry overlayEntry;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showOverlay(context);
      },
      child: const Icon(
        Icons.info_outlined,
        size: 20,
        color: Colors.blueAccent,
      ),
    );
  }

  void _showOverlay(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    OverlayState? overlayState = Overlay.of(context);
    double size = 70;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: const [BoxShadow(color: Colors.white)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: SizedBox(
                          height: size,
                          width: size,
                          child: TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 600),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder:
                                (BuildContext context, double value, child) {
                                  return Icon(
                                    Icons.info_outlined,
                                    size: size * value,
                                    color: Colors.blue,
                                  );
                                },
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.msg,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: Colors.lightBlueAccent,
                        child: const Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          closeOverlay();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlayState.insert(overlayEntry);
  }

  void closeOverlay() {
    overlayEntry.remove();
  }
}
