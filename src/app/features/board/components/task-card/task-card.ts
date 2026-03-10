import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Status, Task, TaskPriority } from '../../models/task.model';
import { CommonModule } from '@angular/common';
import { avatarColors } from '../../../contacts/components/contact-list/contact-list';

/**
 * Task Card component.
 *
 * Displays a single task card in the Kanban board. Shows task details including
 * title, description, type, priority, assignees, subtasks progress, and due date.
 * Supports drag-and-drop, context menu for moving tasks to different columns,
 * and click handling for opening task details.
 */
@Component({
  selector: 'app-task-card',
  imports: [CommonModule],
  templateUrl: './task-card.html',
  styleUrl: './task-card.scss',
})
export class TaskCard {
  @Input({ required: true }) task!: Task;
  @Input() menuOpen = false;
  @Output() menuToggle = new EventEmitter<string>();
  @Output() moveTo = new EventEmitter<{ taskId: string; status: Status }>();

  /**
   * Available status options for moving tasks.
   * This list is used to generate move targets excluding the current status.
   */
  readonly statusOptions: { label: string; value: Status }[] = [
    { label: 'To Do', value: 'todo' },
    { label: 'In Progress', value: 'inProgress' },
    { label: 'Awaiting Feedback', value: 'awaitFeedback' },
    { label: 'Done', value: 'done' }
  ];

  /**
   * Returns the available status options excluding the task's current status.
   *
   * @returns Array of status options that the task can be moved to.
   */
  get moveTargets() {
    return this.statusOptions.filter(option => option.value !== this.task.status);
  }

  /**
   * Emits a move event to change the task status.
   * Stops event propagation to prevent triggering card selection/click handlers.
   *
   * @param status Target status to move the task to.
   * @param e Optional DOM event to stop propagation.
   * @returns void
   */
  onMove(status: Status, e?: Event): void {
    e?.stopPropagation();
    this.moveTo.emit({ taskId: this.task.id, status });
  }


  /**
   * Returns the number of completed subtasks.
   * Safely handles missing or non-array `subtasks`.
   *
   * @returns Count of subtasks where `done === true`.
   */
  get doneSubtasksCount(): number {
    if (!Array.isArray(this.task.subtasks)) {
      return 0;
    }
    return this.task.subtasks.filter(sub => sub.done).length;
  }


  /**
   * Returns the total number of subtasks.
   *
   * @returns Total subtasks count (0 if none exist).
   */
  get totalSubtasksCount(): number {
    return this.task.subtasks ? this.task.subtasks.length : 0;
  }

  /**
   * Maps task priority levels to icon asset paths.
   */
  priorityIcon: Record<TaskPriority, string> = {
    high: 'assets/icons/prio-high.png',
    medium: 'assets/icons/prio-medium.png',
    low: 'assets/icons/prio-low.png'
  };

  /**
   * Extracts up to two initials from a full name.
   *
   * @param name The full name of the contact.
   * @returns Up to two uppercase initials (e.g. "JD" for "John Doe").
   */
  getInitials(name?: string): string {
    return name
      ? name
          .split(' ')
          .map(n => n[0])
          .join('')
          .toUpperCase()
          .slice(0, 2)
      : '';
  }


  /**
   * Returns a consistent avatar color based on a contact's name.
   * The same name always maps to the same color.
   *
   * @param name The full name of the contact.
   * @returns A hex color string from the predefined avatar color palette.
   */
  getAvatarColor(name?: string): string {
    if (!name) {
      return avatarColors[0];
    }
    let hash = 0;
    for (let i = 0; i < name.length; i++) {
      hash = name.charCodeAt(i) + ((hash << 5) - hash);
    }
    const index = Math.abs(hash) % avatarColors.length;
    return avatarColors[index];
  }


  /**
   * Toggles the card's context/FAB menu.
   * Stops event propagation to avoid triggering parent click handlers.
   *
   * @param e Optional DOM event to stop propagation.
   * @returns void
   */
  toggleFab(e?: Event): void {
    e?.stopPropagation();
    this.menuToggle.emit(this.task.id);
  }
}
