import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpComponent extends StatefulWidget {
  final String correctCode;
  final ValueChanged<bool> onSubmit;

  const OtpComponent({
    required this.correctCode,
    required this.onSubmit,
    super.key,
  });

  @override
  State<OtpComponent> createState() => _OtpComponentState();
}

class _OtpComponentState extends State<OtpComponent>
    with TickerProviderStateMixin {
  Map<String, AnimationController> _buttonControllers = {};
  final FocusNode _focusNode = FocusNode();
  List<String> otp = [];
  bool _isError = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _handleDigit(String digit) {
    if (otp.length < 6) {
      setState(() {
        otp.add(digit);
        _isError = false;
      });

      HapticFeedback.lightImpact();

      if (otp.length == 6) {
        final entered = otp.join();
        final isCorrect = entered == widget.correctCode;

        if (isCorrect) {
          HapticFeedback.heavyImpact();
          widget.onSubmit(true);
        } else {
          HapticFeedback.vibrate();
          _triggerErrorAnimation();
          widget.onSubmit(false);
        }
      }
    }
  }

  void _handleDelete() {
    if (otp.isNotEmpty) {
      setState(() {
        otp.removeLast();
        _isError = false;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _triggerErrorAnimation() {
    setState(() => _isError = true);
    _shakeController.forward().then((_) {
      _shakeController.reset();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            otp.clear();
            _isError = false;
          });
        }
      });
    });
  }

  void _onButtonPressed(String label) {
    final controller = _buttonControllers[label] ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    controller.forward(from: 0.0).then((_) => controller.reverse());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _shakeController.dispose();
    for (final controller in _buttonControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey;

          final keyLabel = key.keyLabel;
          if (keyLabel.isNotEmpty && RegExp(r'^[0-9]$').hasMatch(keyLabel)) {
            _handleDigit(keyLabel);
          } else if (key == LogicalKeyboardKey.backspace) {
            _handleDelete();
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = 550;
          final double height = 800;

          return Center(
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                final offset = _isError
                    ? Offset(
                  10 *
                      _shakeAnimation.value *
                      (1 - _shakeAnimation.value * 2).abs(),
                  0,
                )
                    : Offset.zero;

                return Transform.translate(
                  offset: offset,
                  child: Container(
                    width: width,
                    height: height,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: _isError
                          ? Border.all(color: colorScheme.error, width: 2)
                          : Border.all(color: colorScheme.outline.withAlpha(30)),
                      boxShadow: [
                        BoxShadow(
                          color: _isError
                              ? colorScheme.error.withAlpha(20)
                              : colorScheme.shadow.withAlpha(10),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            _isError ? Icons.error_outline : Icons.lock_outline,
                            size: 48,
                            color: _isError ? colorScheme.error : colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: _isError ? colorScheme.error : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text(
                            _isError ? 'Noto\'g\'ri kod' : 'Kirish kodini kiriting',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isError
                                    ? (index < otp.length
                                    ? colorScheme.error
                                    : colorScheme.error.withAlpha(30))
                                    : (index < otp.length
                                    ? colorScheme.primary
                                    : colorScheme.outline.withAlpha(30)),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              height: 600,
                              width: 400,
                              child: GridView.count(
                                crossAxisCount: 3,
                                childAspectRatio: 1.0,
                                padding: const EdgeInsets.all(12),
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                                children: [
                                  for (var i = 1; i <= 9; i++) _buildButton(i.toString()),
                                  const SizedBox(),
                                  _buildButton('0'),
                                  _buildButton('Del', isDelete: true),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Klaviatura yoki tugmalarni ishlatishingiz mumkin',
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: colorScheme.onSurface.withAlpha(60),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton(String label, {bool isDelete = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final controller = _buttonControllers[label] ??= AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    final animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Material(
            shape: const CircleBorder(),
            elevation: 3,
            shadowColor: colorScheme.shadow,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                _onButtonPressed(label);
                if (isDelete) {
                  _handleDelete();
                } else {
                  _handleDigit(label);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isError
                      ? colorScheme.errorContainer
                      : colorScheme.surfaceContainerHighest,
                  border: _isError
                      ? Border.all(color: colorScheme.error.withAlpha(50))
                      : Border.all(color: colorScheme.outline.withAlpha(20)),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isError
                          ? colorScheme.onErrorContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    child: Text(
                      isDelete ? 'Del' : label,
                      style: TextStyle(fontSize: isDelete ? 16 : 26),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
