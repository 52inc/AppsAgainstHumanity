import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/game/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlayerResponsePicker extends StatefulWidget {
  @override
  _PlayerResponsePickerState createState() => _PlayerResponsePickerState();
}

class _PlayerResponsePickerState extends State<PlayerResponsePicker> {
  final PageController _pageController =
      PageController(viewportFraction: 0.945);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameViewState>(
      builder: (context, state) {
        // Determine if we need to show the response picker, or to hide this part
        if (!state.areWeJudge && !state.haveWeSubmittedResponse) {
          // Get the player's current hand, omitting any card's they MAY have submitted
          var hand = state.currentHand.reversed.toList();
          return Stack(
            children: <Widget>[
              AnimatedOpacity(
                opacity: state.isSubmitting ? 0 : 1,
                duration: Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: hand.length,
                  itemBuilder: (context, index) {
                    var card = hand[index];
                    return HandCard(
                      key: ValueKey(card),
                      card: card,
                    );
                  },
                ),
              ),
              if (state.isSubmitting)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: _buildSubmittingWidget(context),
                  ),
                ),
              if (state.selectCardsMeetPromptRequirement && !state.isSubmitting)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    child: _buildSubmitCardsButton(context),
                  ),
                )
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _buildSubmittingWidget(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: StadiumBorder(),
        primary: AppColors.primary,
      ),
      onPressed: null,
      icon: Container(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorOnPrimary),
        ),
      ),
      label: Container(
        margin: const EdgeInsets.only(left: 8, right: 20),
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

  Widget _buildSubmitCardsButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: StadiumBorder(),
        primary: AppColors.primary,
      ),
      onPressed: () async {
        Analytics().logSelectContent(
            contentType: 'action', itemId: 'submit_responses');
        context.bloc<GameBloc>().add(SubmitResponses());
      },
      icon: Icon(
        MdiIcons.uploadMultiple,
        color: AppColors.colorOnPrimary,
      ),
      label: Container(
        margin: const EdgeInsets.only(left: 8, right: 20),
        child: Text(
          "SUBMIT RESPONSE",
          style: context.theme.textTheme.button.copyWith(
            color: AppColors.colorOnPrimary,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class HandCard extends StatelessWidget {
  static const textPadding = 20.0;

  final ResponseCard card;

  HandCard({
    Key key,
    this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: double.maxFinite,
      child: Material(
        color: context.responseCardHandColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: context.responseBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          highlightColor: AppColors.primary.withOpacity(0.26),
          splashColor: AppColors.primary.withOpacity(0.26),
          onTap: () {
            Analytics().logSelectContent(
                contentType: 'action', itemId: 'picked_response');
            context.bloc<GameBloc>().add(PickResponseCard(card));
          },
          child: Column(
            children: <Widget>[
              _buildText(context, card.text),
              Expanded(
                child: _buildCaptionText(context, card.set),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, String text) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(textPadding),
      child: Text(
        text,
        style: context.cardTextStyle(context.colorOnCard),
      ),
    );
  }

  Widget _buildCaptionText(BuildContext context, String text) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(right: textPadding, bottom: 16),
      alignment: Alignment.bottomRight,
      child: Text(
        text,
        textAlign: TextAlign.end,
        style: context.theme.textTheme.caption.copyWith(
          color: context.secondaryColorOnCard,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
