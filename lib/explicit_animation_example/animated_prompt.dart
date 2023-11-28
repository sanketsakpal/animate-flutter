import 'package:flutter/material.dart';

class AnimatedPrompt extends StatefulWidget {
  const AnimatedPrompt({super.key});

  @override
  State<AnimatedPrompt> createState() => _AnimatedPromptState();
}

class _AnimatedPromptState extends State<AnimatedPrompt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Icons'),
      ),
      body: const Center(
        child: PromptAnimatedDialog(
          title: 'Thank you for your order!',
          subTitle: 'Your order will be delivered in 2 days. Enjoy!',
          child: Icon(
            Icons.check,
          ),
        ),
      ),
    );
  }
}

class PromptAnimatedDialog extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final Widget child;
  const PromptAnimatedDialog(
      {super.key, this.title, this.subTitle, required this.child});

  @override
  State<PromptAnimatedDialog> createState() => _PromptAnimatedDialogState();
}

class _PromptAnimatedDialogState extends State<PromptAnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> iconScaleAnimation;
  late Animation<double> containerScaleAnimation;
  late Animation<Offset> yAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    yAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -0.23)).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    iconScaleAnimation = Tween<double>(begin: 7, end: 6).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    containerScaleAnimation = Tween<double>(
      begin: 2.0,
      end: 0.4,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller
      ..reset()
      ..forward();
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 160,
                    ),
                    Text(
                      widget.title ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.subTitle ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: SlideTransition(
                  position: yAnimation,
                  child: ScaleTransition(
                    scale: containerScaleAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: ScaleTransition(
                        scale: iconScaleAnimation,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
