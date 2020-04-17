enum GameState {
  waitingRoom,
  starting,
  inProgress,
  completed,
}

extension GameStateExt on GameState {
  String get label {
    switch (this) {
      case GameState.waitingRoom:
        return "Waiting Room";
      case GameState.starting:
        return "Game Starting";
      case GameState.inProgress:
        return "In Progress";
      default:
        return "Completed";
    }
  }
}
