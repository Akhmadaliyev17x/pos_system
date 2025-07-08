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
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Shake animation setup
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Button pulse animation setup
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Auto-focus when component loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _handleDigit(String digit) {
    if (otp.length < 6) {
      setState(() {
        otp.add(digit);
        _isError = false; // Reset error state when typing
      });

      // Haptic feedback
      HapticFeedback.lightImpact();

      if (otp.length == 6) {
        final entered = otp.join();
        final isCorrect = entered == widget.correctCode;

        if (isCorrect) {
          // Success feedback
          HapticFeedback.heavyImpact();
          widget.onSubmit(true);
        } else {
          // Error feedback and animation
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
        _isError = false; // Reset error state when deleting
      });
      HapticFeedback.selectionClick();
    }
  }

  void _triggerErrorAnimation() {
    setState(() => _isError = true);
    _shakeController.forward().then((_) {
      _shakeController.reset();
      // Clear OTP after error animation
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
    _pulseController.dispose();
    for (final controller in _buttonControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey;

          // Handle digit keys (0-9)
          if (key.debugName != null && key.debugName!.startsWith('Digit')) {
            final digit = key.debugName!.replaceAll('Digit ', '');
            if (RegExp(r'^[0-9]$').hasMatch(digit)) {
              _handleDigit(digit);
            }
          }
          // Handle numpad keys
          else if (key.debugName != null &&
              key.debugName!.startsWith('Numpad')) {
            final digit = key.debugName!.replaceAll('Numpad ', '');
            if (RegExp(r'^[0-9]$').hasMatch(digit)) {
              _handleDigit(digit);
            }
          }
          // Handle backspace
          else if (key == LogicalKeyboardKey.backspace) {
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: _isError
                          ? Border.all(color: Colors.red.shade300, width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: _isError
                              ? Colors.red.withAlpha(30)
                              : Colors.grey.withAlpha(30),
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
                            _isError ? Icons.error_outline : Icons.lock,
                            size: 48,
                            color: _isError ? Colors.red : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isError ? Colors.red : Colors.black,
                          ),
                          child: Text(
                            _isError
                                ? 'Incorrect code'
                                : 'Enter your access code',
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
                                    ? Colors.red
                                    : Colors.red.shade200)
                                    : (index < otp.length
                                    ? Colors.black
                                    : Colors.grey.shade300),
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
                                // ⬅️ spacing oshirildi
                                mainAxisSpacing: 24,
                                children: [
                                  for (var i = 1; i <= 9; i++)
                                    _buildButton(i.toString()),
                                  const SizedBox(),
                                  _buildButton('0'),
                                  _buildButton('Del', isDelete: true),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Keyboard hint
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Use keyboard or click buttons',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
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
    final controller = _buttonControllers[label] ??= AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    final animation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Material(
            shape: const CircleBorder(),
            elevation: 3,
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
                // ⬅️ kattalashtirildi
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isError ? Colors.red.shade50 : Colors.grey[100],
                  border: _isError
                      ? Border.all(color: Colors.red.shade200)
                      : null,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _isError ? Colors.red.shade700 : Colors.black,
                    ),
                    child: Text(label),
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
