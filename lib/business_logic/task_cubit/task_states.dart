import '../../models/task.dart';

abstract class TaskStates{}

class InitialState extends TaskStates {}

class DataLoading extends TaskStates{}

class DatabaseOpened extends TaskStates{}

class DatabaseOpeningError extends TaskStates{}

class AvatarPicked extends TaskStates{}

class CreatingAccount extends TaskStates{}

class AccountCreated extends TaskStates{}

class AccountCreatingError extends TaskStates{}

class AccountUpdated extends TaskStates{}

class AccountUpdatingError extends TaskStates{}

class AccountDeleted extends TaskStates{}

class CurrentAccountChanged extends TaskStates{}

class TaskAdded extends TaskStates{}

class TaskAddingError extends TaskStates{}

class TaskUpdated extends TaskStates{}

class TaskUpdatingError extends TaskStates{}

class PlanAdded extends TaskStates{}

class PlanAddingError extends TaskStates{}

class PlanUpdated extends TaskStates{}

class PlanUpdatingError extends TaskStates{}

class TaskArchived extends TaskStates{
  final String taskTitle ;
  TaskArchived(this.taskTitle);
}

class TaskDeleted extends TaskStates{
  final String taskTitle ;
  TaskDeleted(this.taskTitle);
}

class TaskIsDone extends TaskStates{
  final Task task ;
  TaskIsDone(this.task);
}

class SubTaskAddedToList extends TaskStates{}

class AddingSubTaskToDatabase extends TaskStates{}

class SubTaskAddedToDatabase extends TaskStates{}

class AccountDataLoaded extends TaskStates{}

class AccountTasksLoaded extends TaskStates{}

class PlanSubTasksLoaded extends TaskStates{
  final Task plan ;
  PlanSubTasksLoaded(this.plan);
}

class NewNoteAdded extends TaskStates{}

class NoteDeleted extends TaskStates{}

class NewLinkAdded extends TaskStates{}

class LinkDeleted extends TaskStates{}

class AnimatingProgress extends TaskStates{}

class AllItemsListSorted extends TaskStates{}