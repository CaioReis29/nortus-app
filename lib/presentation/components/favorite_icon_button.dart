import 'package:flutter/material.dart';

class FavoriteIconButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onPressed;
  final Color? iconColor;
  const FavoriteIconButton({super.key, required this.isFavorite, this.onPressed, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isFavorite ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          key: ValueKey<bool>(isFavorite),
          color: iconColor ?? Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
