import {Component,EventEmitter,Input,Output,ViewChild, ViewChildren,QueryList,ElementRef,TemplateRef,ChangeDetectorRef,ChangeDetectionStrategy} from '@angular/core';
import { TaskCard } from '../task-card/task-card';
import { Task, Status } from '../../models/task.model';
import { CommonModule } from '@angular/common';
import {CdkDrag,CdkDropList,CdkDragDrop,moveItemInArray,transferArrayItem,DragDropModule} from '@angular/cdk/drag-drop';
import { inject } from '@angular/core';
import { Supabase } from '../../../../supabase';

/**
 * Funktionen sind nach JSDoc Standard dokumentiert:
 *
 * BoardColumn represents a single kanban column and is responsible for:
 * - rendering tasks for a given status
 * - handling drag & drop interactions
 * - emitting events to the parent container
 * - persisting status changes to Supabase
 */
@Component({
  selector: 'app-board-column',
  standalone: true,
  imports: [CommonModule, TaskCard, CdkDrag, CdkDropList, DragDropModule],
  templateUrl: './board-column.html',
  styleUrl: './board-column.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class BoardColumn  {
  @Input() title = '';
  @Input() tasks: Task[] = [];
  @Input() columnId!: Status;

  /**
   * IDs of connected drop lists, enabling cross-column dragging.
   * Defaults to the standard board columns.
   */
  @Input() connectedDropLists: string[] = [
    'todo',
    'inProgress',
    'awaitFeedback',
    'done'
  ];

  @Output() taskSelected = new EventEmitter<Task>();
  @Output() addClicked = new EventEmitter<void>();
  @Output() taskDropped = new EventEmitter<{ task: Task; newStatus: Status }>();
  @Output() moveTask = new EventEmitter<{ taskId: string; status: Status }>();
  @Input() openMenuTaskId: string | null = null;
  @Output() menuToggleGlobal = new EventEmitter<string>();
  @ViewChild(CdkDropList) dropList!: CdkDropList<Task[]>;
  @ViewChildren('taskElement') taskElements!: QueryList<ElementRef>;
  @ViewChild('previewContainer', { read: TemplateRef }) previewTemplate!: TemplateRef<any>;

  private supabase = inject(Supabase);
  private cdr = inject(ChangeDetectorRef);

  isDragOver = false;
  isDragging = false;
  draggedTaskIndex = -1;

  previewContainer: TemplateRef<any> | string = 'body';
  draggedElement: ElementRef | null = null;

  /**
   * Handles a drop event from Angular CDK Drag & Drop.
   *
   * Delegates to {@link reorderTaskWithinColumn} for same-column drops or
   * {@link transferTaskToNewColumn} for cross-column drops, then resets
   * the drag-over state and triggers change detection.
   *
   * @param event Drag & drop event containing source/target containers and indices.
   */
  onDrop(event: CdkDragDrop<Task[]>): void {
    const droppedTask = event.previousContainer.data[event.previousIndex];

    if (!droppedTask) {
      console.error('Task not found');
      return;
    }

    if (event.previousContainer === event.container) {
      this.reorderTaskWithinColumn(event);
    } else {
      this.transferTaskToNewColumn(droppedTask, event);
    }

    this.isDragOver = false;
    this.cdr.markForCheck();
  }

  /**
   * Reorders a task within the same column after an in-column drag & drop.
   *
   * Uses CDK's `moveItemInArray` to update the column's task array in-place.
   *
   * @param event The drag & drop event from Angular CDK.
   */
  private reorderTaskWithinColumn(event: CdkDragDrop<Task[]>): void {
    moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
  }

  /**
   * Moves a task from another column into this column.
   *
   * Updates the task's status to this column's `columnId`, transfers it
   * between the two data arrays, persists the new status to Supabase
   * and emits the `taskDropped` output event.
   *
   * @param droppedTask  The task being moved.
   * @param event        The drag & drop event from Angular CDK.
   */
  private transferTaskToNewColumn(droppedTask: Task, event: CdkDragDrop<Task[]>): void {
    droppedTask.status = this.columnId;

    transferArrayItem(
      event.previousContainer.data,
      event.container.data,
      event.previousIndex,
      event.currentIndex,
    );

    this.updateTaskStatus(droppedTask);
    this.taskDropped.emit({ task: droppedTask, newStatus: this.columnId });
  }


  /**
   * Persists a task status update to the database via Supabase.
   *
   * @param task The task whose status should be updated.
   * @returns Promise<void>
   */
  private async updateTaskStatus(task: Task): Promise<void> {
    try {
      const { error } = await this.supabase.supabase
        .from('tasks')
        .update({ status: task.status })
        .eq('id', task.id);

      if (error) {
        console.error('Database error:', error);
        throw error;
      }
    } catch (error) {
      console.error('Error updating task status:', error);
      alert('Failed to update task. Please try again.');
    }
  }


  /**
   * Marks the column as being hovered by a draggable element.
   * Typically used to show a visual highlight on the drop area.
   *
   * @returns void
   */
  onDropListEntered(): void {
    this.isDragOver = true;
    this.cdr.markForCheck();
  }


  /**
   * Clears the column hover state when a draggable element leaves the drop area.
   *
   * @returns void
   */
  onDropListExited(): void {
    this.isDragOver = false;
    this.cdr.markForCheck();
  }


  /**
   * Called when dragging starts.
   * Used to prevent click selection while dragging.
   *
   * @param event Drag start event (type depends on template binding).
   * @returns void
   */
  onDragStarted(event: any): void {
    this.isDragging = true;
    this.cdr.markForCheck();
  }


  /**
   * Called when dragging ends.
   *
   * @param event Drag end event (type depends on template binding).
   * @returns void
   */
  onDragEnded(event: any): void {
    this.isDragging = false;
    this.cdr.markForCheck();
  }


  /**
   * Emits the selected task when a task card is clicked.
   * Selection is ignored while dragging to avoid accidental opens.
   *
   * @param task Selected task.
   * @returns void
   */
  onTaskSelected(task: Task): void {
    if (!this.isDragging) {
      this.taskSelected.emit(task);
    }
  }


  /**
   * Emits an event indicating the user wants to add a new task to this column.
   *
   * @returns void
   */
  onAddTask(): void {
    this.addClicked.emit();
  }


  /**
   * Returns a contextual empty-state message when the column has no tasks.
   *
   * @returns A string message if empty; otherwise an empty string.
   */
  getEmptyMessage(): string {
    return this.tasks.length === 0 ? `No tasks in ${this.title}` : '';
  }


  /**
   * Handles moving a task via the context/FAB menu rather than drag & drop.
   * If the requested target status equals the current column status, it does nothing.
   *
   * @param event Object containing the task id and the destination status.
   * @returns void
   */
  onMoveFromMenu(event: { taskId: string; status: Status }): void {
    if (event.status === this.columnId) {
      return;
    }
    this.moveTask.emit(event);
  }


  /**
   * Requests a global menu toggle for a given task id.
   * The parent component decides which menu is open at any time.
   *
   * @param taskId The task id whose menu should be toggled.
   * @returns void
   */
  onMenuToggle(taskId: string): void {
    this.menuToggleGlobal.emit(taskId);
  }
}
