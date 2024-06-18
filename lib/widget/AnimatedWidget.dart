import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    required this.closedChild,
    required this.openedChild
  });

  final Widget closedChild;
  final Widget openedChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return openedChild;
      },
      openColor: theme.cardColor,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kTextFieldCornerRadius)),
      ),
      closedElevation: 0,
      // closedColor: appBG,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: () {
            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}

class OpenButtonContainerWrapper extends StatelessWidget {
  const OpenButtonContainerWrapper({
    required this.closedChild,
    required this.openedChild
  });

  final Widget closedChild;
  final Widget openedChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return openedChild;
      },
      openColor: theme.cardColor,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kTextFieldCornerRadius)),
      ),
      closedElevation: 0,
      // closedColor: appBG,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: () {
            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}

