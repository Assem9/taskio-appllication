import '../../models/task.dart';

abstract class AppStates {}

class InitialState extends AppStates{}

class ChangeBottomNavigationBar extends AppStates{}

class ThemeChanged extends AppStates{}

class DateTimeFormatSet extends AppStates {}

class ColorPicked extends AppStates{}

class CurrentAccountChanged extends AppStates{}

class AnimatingAccountWidget extends AppStates{}

class WeekDaysDatesInitialized extends AppStates{}

class DayPicked extends AppStates{}

class PickedDayDataLoaded extends AppStates{}

class Loading extends AppStates{}