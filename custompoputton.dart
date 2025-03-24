import 'package:aristhaprocurement/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class PopButton extends StatefulWidget {
  final void Function() onPressed;
  final double height;
  final double? width;
  final double shadowHeight;
  final Color? shadowColor;
  final double buttonRadius;
  final Widget? child;
  final IconData? icon;
  final Color buttonColor;
  final bool isDisabled;
  final Color disabledButtonColor;
  final bool isLoading;
  final Color iconColor;
  final double iconSize;
  final String? text;
  final TextStyle textStyle;
  final Color loadingColor;
  final bool moveIconRight;

  const PopButton({
    super.key,
    required this.onPressed,
    this.shadowHeight = 5,
    this.shadowColor,
    this.height = 50,
    this.width,
    this.icon,
    this.buttonRadius = 12,
    this.child,
    this.buttonColor = AppColors.primary,
    this.isDisabled = false,
    this.disabledButtonColor = const Color(0xffbdbdbd),
    this.isLoading = false,
    this.iconColor = Colors.white,
    this.iconSize = 26,
    this.text,
    this.textStyle = const TextStyle(
      fontSize: 17,
      color: Colors.white,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
    ),
    this.loadingColor = Colors.white,
    this.moveIconRight = false
  });

  @override
  State<PopButton> createState() => _PopButtonState();
}

class _PopButtonState extends State<PopButton> {
  double? _position;

  @override
  void initState() {
    _position = widget.shadowHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double totalHeight = widget.height - widget.shadowHeight;
    final double width = widget.width ?? MediaQuery.of(context).size.width * 0.6;
    return Align(
      alignment: Alignment.center,
      child: MouseRegion(
        cursor: widget.isDisabled
            ? SystemMouseCursors.forbidden
            : widget.isLoading
            ? SystemMouseCursors.wait
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.isDisabled || widget.isLoading ? null : widget.onPressed,
          onTapUp: widget.isDisabled || widget.isLoading
              ? null
              : (_) {
            setState(() {
              _position = widget.shadowHeight;
            });
          },
          onTapDown: widget.isDisabled || widget.isLoading
              ? null
              : (_) {
            setState(() {
              _position = 0;
            });
          },
          onTapCancel: widget.isDisabled || widget.isLoading
              ? null
              : () {
            setState(() {
              _position = widget.shadowHeight;
            });
          },
          child: SizedBox(
            height: totalHeight + widget.shadowHeight,
            width: width,
            child: Stack(
              fit: StackFit.loose,
              alignment: Alignment.center,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: totalHeight,
                    width: width,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: widget.shadowColor ?? HSLColor.fromColor(widget.buttonColor).withLightness(0.35).toColor(),
                      borderRadius: BorderRadius.circular(widget.buttonRadius),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.easeIn,
                  bottom: widget.isDisabled || widget.isLoading ? 0 : _position,
                  duration: const Duration(milliseconds: 70),
                  child: Container(
                    height: totalHeight,
                    width: width,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: widget.isDisabled ? widget.disabledButtonColor : widget.buttonColor,
                      borderRadius: BorderRadius.circular(widget.buttonRadius),
                    ),
                    child: widget.isLoading
                        ? Center(
                      child: SizedBox(
                        height: totalHeight - 18,
                        width: totalHeight - 18,
                        child: CircularProgressIndicator(
                          color: widget.loadingColor,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    )
                        : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textDirection: widget.moveIconRight ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          widget.icon != null
                              ? Icon(
                            widget.icon,
                            color: widget.iconColor,
                            size: widget.iconSize,
                          )
                              : const SizedBox.shrink(),
                          (widget.icon != null && widget.child != null) || (widget.text != null && widget.icon != null)
                              ? const SizedBox(
                            width: 12,
                          )
                              : const SizedBox.shrink(),
                          widget.child ?? const SizedBox.shrink(),
                          widget.text != null
                              ? Text(
                            widget.text ?? "",
                            style: widget.textStyle,
                          )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
