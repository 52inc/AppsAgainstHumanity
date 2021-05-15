import 'dart:async';

import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/judging_pager.dart';
import 'package:appsagainsthumanity/ui/game/screens/gameplay/widget/judge/player_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class JudgeDredd extends StatefulWidget {
  final GameViewState state;

  JudgeDredd(this.state);

  @override
  _JudgeDreddState createState() => _JudgeDreddState();
}

class _JudgeDreddState extends State<JudgeDredd> {
  final JudgementController controller = JudgementController();

  @override
  void initState() {
    super.initState();
    controller.totalPageCount = widget.state.game.turn?.responses?.length ?? 0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        JudgingPager(
          state: widget.state,
          controller: controller,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 48),
            child: StreamBuilder<int>(
                stream: controller.observePageChanges(),
                builder: (context, snapshot) {
                  var currentPage = snapshot.data ?? 0;
                  var showLeft = currentPage > 0;
                  var showRight = currentPage < controller.totalPageCount - 1;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildPageButton(
                          context: context,
                          iconData: Icons.keyboard_arrow_left,
                          isVisible: showLeft),
                      if (widget.state.isSubmitting)
                        _buildPickingWinnerIndicator(context),
                      if (!widget.state.isSubmitting)
                        _buildPickWinnerButton(context),
                      _buildPageButton(
                          context: context,
                          iconData: Icons.keyboard_arrow_right,
                          isLeft: false,
                          isVisible: showRight),
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }

  Widget _buildPickWinnerButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: StadiumBorder(),
        primary: AppColors.primary,
      ),
      onPressed: () async {
        var currentPlayerResponse = controller.currentPlayerResponse;
        if (currentPlayerResponse != null) {
          Analytics()
              .logSelectContent(contentType: 'judge', itemId: 'pick_winner');
          print("Winner selected! ${currentPlayerResponse.playerId}");
          context
              .bloc<GameBloc>()
              .add(PickWinner(currentPlayerResponse.playerId));
        }
      },
      icon: Icon(
        MdiIcons.crown,
        color: AppColors.colorOnPrimary,
      ),
      label: Container(
        margin: const EdgeInsets.only(left: 16, right: 40),
        child: Text(
          "WINNER",
          style: context.theme.textTheme.button.copyWith(
            color: AppColors.colorOnPrimary,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildPickingWinnerIndicator(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: StadiumBorder(),
        primary: AppColors.primary,
      ),
      icon: Container(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorOnPrimary),
        ),
      ),
      label: Container(
        margin: const EdgeInsets.only(left: 16, right: 40),
        child: Text(
          "SUBMITTING...",
          style: context.theme.textTheme.button.copyWith(
            color: AppColors.colorOnPrimary,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton({
    @required BuildContext context,
    @required IconData iconData,
    isVisible = true,
    isLeft = true,
  }) {
    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: Duration(milliseconds: 150),
      child: Container(
        height: 48,
        width: 56,
        child: Material(
          color: AppColors.primary,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: isLeft
                ? BorderRadius.only(
                    topRight: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                  ),
          ),
          child: InkWell(
            onTap: isVisible
                ? () {
                    if (isLeft) {
                      Analytics().logSelectContent(
                          contentType: 'judge', itemId: 'previous_choice');
                      controller.prevPage();
                    } else {
                      Analytics().logSelectContent(
                          contentType: 'judge', itemId: 'next_choice');
                      controller.nextPage();
                    }
                  }
                : null,
            child: Container(
              alignment: Alignment.center,
              child: Icon(
                iconData,
                color: AppColors.colorOnPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JudgementController {
  static const double VIEWPORT_FRACTION = 0.945;

  final PageController pageController =
      PageController(viewportFraction: VIEWPORT_FRACTION);
  final StreamController<int> _pageChanges = StreamController.broadcast();

  PlayerResponse _currentPlayerResponse;

  PlayerResponse get currentPlayerResponse => _currentPlayerResponse;

  int _index = 0;
  int totalPageCount = 0;

  JudgementController() {
    _pageChanges.onListen = () => _pageChanges.add(_index);
  }

  void dispose() {
    pageController.dispose();
    _pageChanges.close();
  }

  void setCurrentResponse(PlayerResponse playerResponse, int index, int count) {
    _currentPlayerResponse = playerResponse;
    _index = index;
    totalPageCount = count;
    _pageChanges.add(_index);
  }

  void nextPage() {
    if (_index < totalPageCount - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void prevPage() {
    if (_index > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  Stream<int> observePageChanges() => _pageChanges.stream;
}
