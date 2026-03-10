import { Component, OnInit, AfterViewInit, inject, ChangeDetectorRef, effect, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Task , Status} from '../../models/task.model';
import { BoardColumn } from '../../components/board-column/board-column';
import { TaskDetailDialog } from '../../components/task-detail-dialog/task-detail-dialog';
import { AddTaskDialog } from '../../../add-task/components/add-task-dialog/add-task-dialog';
import { TaskStore } from '../../services/task-store';

/**
 * Funktionen sind nach JSDoc Standard dokumentiert:
 *
 * BoardPage is the main kanban board container page. It is responsible for:
 * - loading tasks from the TaskStore
 * - filtering tasks by search query
 * - distributing tasks into status-based columns
 * - coordinating dialogs (task detail / add task)
 * - handling cross-column task moves (drag & drop and menu actions)
 */
@Component({
  selector: 'app-board-page',
  imports: [BoardColumn, TaskDetailDialog, AddTaskDialog, CommonModule, FormsModule],
  standalone: true,
  templateUrl: './board-page.html',
  styleUrl: './board-page.scss',
})
export class BoardPage implements OnInit, AfterViewInit {
  private taskStore = inject(TaskStore);
  private cdr = inject(ChangeDetectorRef);
  dropListIds: string[] = ['todo', 'inProgress', 'awaitFeedback', 'done'];
  searchQuery = '';
  allTasks: Task[] = [];
  openMenuTaskId: string | null = null;

  /**
   * Column definitions for the board.
   * Each column corresponds to one Status and contains the filtered tasks.
   */
  columns: Array<{ title: string; status: Status; tasks: Task[] }> = [
    { title: 'To do', status: 'todo', tasks: [] },
    { title: 'In progress', status: 'inProgress', tasks: [] },
    { title: 'Await feedback', status: 'awaitFeedback', tasks: [] },
    { title: 'Done', status: 'done', tasks: [] }
  ];

  isLoading = true;
  error: string | null = null;
  showTaskDetail = false;
  showAddTask = false;
  selectedTask: Task | null = null;
  selectedStatus: Status | null = null;

  /**
   * Sets up a reactive effect that watches TaskStore tasks.
   *
   * When tasks change:
   * - updates the local task list
   * - re-applies the current search filter
   * - refreshes the selected task reference (if the task was updated)
   */
  constructor() {
    effect(() => {
      const updatedTasks = this.taskStore.tasks();

      if (updatedTasks.length > 0) {
        this.allTasks = updatedTasks;
        this.filterTasks(this.allTasks);

        if (this.selectedTask) {
          const updatedSelectedTask = updatedTasks.find(t => t.id === this.selectedTask!.id);
          if (updatedSelectedTask) {
            this.selectedTask = updatedSelectedTask;
          }
        }
      }
    });
  }


  /**
   * Angular lifecycle hook.
   * Initializes the component.
   *
   * @returns void
   */
  ngOnInit(): void {
    // Initialization happens here
  }


  /**
   * Angular lifecycle hook.
   * Loads tasks after the view is initialized to avoid change detection errors.
   *
   * @returns void
   */
  ngAfterViewInit(): void {
    this.loadTasks();
  }


  /**
   * Loads tasks from the TaskStore and updates UI state.
   *
   * Flow:
   * - set loading state
   * - fetch tasks
   * - apply filtering into columns
   * - handle and display errors
   *
   * @returns Promise<void>
   */
  async loadTasks(): Promise<void> {
    this.isLoading = true;
    this.cdr.detectChanges();
    this.error = null;

    try {
      this.allTasks = await this.taskStore.getTasks();
      this.filterTasks(this.allTasks);
    } catch (error: any) {
      this.error = `Failed to load tasks: ${error.message}`;
      console.error('Error loading tasks:', error);
    } finally {
      this.isLoading = false;
      this.cdr.detectChanges();
    }
  }


  /**
   * Filters a list of tasks by the current searchQuery and distributes them into columns.
   *
   * Filtering rules:
   * - if query is empty: show all tasks
   * - otherwise: match by title or description (case-insensitive)
   *
   * @param allTasks The full task list to filter.
   * @returns void
   */
  filterTasks(allTasks: Task[]): void {
    const query = this.searchQuery.toLowerCase().trim();

    let filteredTasks = allTasks;

    if (query.length >= 1) {
      filteredTasks = allTasks.filter(task =>
        task.title.toLowerCase().includes(query) ||
        (task.description && task.description.toLowerCase().includes(query))
      );
    }

    this.columns.forEach(col => {
      col.tasks = filteredTasks.filter(t => t.status === col.status);
    });
  }


  /**
   * Called when the search input changes.
   * Re-applies the filtering using the current searchQuery.
   *
   * @returns void
   */
  onSearchChange(): void {
    this.filterTasks(this.allTasks);
  }


  /**
   * Checks if there are any tasks available after filtering.
   * Used to show "no results" message.
   *
   * @returns boolean
   */
  get hasFilteredTasks(): boolean {
    return this.columns.some(col => col.tasks.length > 0);
  }


  /**
   * Toggles the context menu for the given task id.
   * If the menu is already open for that task, it closes it.
   *
   * @param taskId The task id whose menu should be toggled.
   * @returns void
   */
  onMenuToggle(taskId: string): void {
    this.openMenuTaskId = this.openMenuTaskId === taskId ? null : taskId;
  }


  /**
   * Closes any open task context menu when clicking outside.
   *
   * @returns void
   */
  @HostListener('document:click')
  onDocClick(): void {
    this.openMenuTaskId = null;
  }


  /**
   * Opens the "Add Task" dialog with a default status of 'todo'.
   *
   * @returns void
   */
  openAddTaskDialog(): void {
    this.selectedStatus = 'todo';
    this.showAddTask = true;
  }


  /**
   * Selects a task and opens the task detail dialog.
   *
   * @param task The task to open in the detail dialog.
   * @returns void
   */
  selectTask(task: Task): void {
    this.selectedTask = task;
    this.showTaskDetail = true;
  }


  /**
   * Closes the task detail dialog and clears the selected task.
   *
   * @returns void
   */
  closeTaskDetail(): void {
    this.showTaskDetail = false;
    this.selectedTask = null;
  }


  /**
   * Called after a task was updated in the detail dialog.
   * Closes the dialog and reloads tasks from the store.
   *
   * @returns Promise<void>
   */
  async onTaskUpdated(): Promise<void> {
    this.closeTaskDetail();
  }


  /**
   * Opens the "Add Task" dialog for a specific status (e.g., when clicking "+" on a column).
   *
   * @param status The status that should be preselected for the new task.
   * @returns void
   */
  addTask(status: Status): void {
    this.selectedStatus = status;
    this.showAddTask = true;
    this.cdr.detectChanges();
  }


  /**
   * Closes the add task dialog and clears the selectedStatus.
   * Reloads tasks to reflect any newly created task.
   *
   * @returns void
   */
  async closeAddTask(): Promise<void> {
    this.showAddTask = false;
    this.selectedStatus = null;
    // Reload tasks in case a task was created
    await this.loadTasks();
  }


  /**
   * Called after a task was created in the add task dialog.
   * Closes the dialog, reloads tasks, and triggers change detection.
   *
   * @returns Promise<void>
   */
  async onTaskCreated(): Promise<void> {
    this.closeAddTask();
    this.cdr.detectChanges();
  }


  /**
   * Handles a task drop event coming from a BoardColumn (drag & drop between columns).
   * Updates the task's status, then reloads tasks to reflect the latest data.
   *
   * @param event Payload containing the moved task and its new status.
   * @returns Promise<void>
   */
  async onTaskDropped(event: { task: Task; newStatus: Status }): Promise<void> {
    await this.taskStore.updateTask(event.task.id, { status: event.newStatus });
    await this.taskStore.loadTasks();
  }


  /**
   * Handles moving a task via a menu action (not drag & drop).
   * Closes any open menu, updates the task status, and reloads tasks.
   *
   * @param evt Payload containing the task id and the destination status.
   * @returns Promise<void>
   */
  async onMoveTask(evt: { taskId: string; status: Status }): Promise<void> {
    this.openMenuTaskId = null;
    await this.taskStore.updateTask(evt.taskId, { status: evt.status });
  }
}
