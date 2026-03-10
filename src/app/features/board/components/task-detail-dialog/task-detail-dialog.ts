import {
  Component,
  ElementRef,
  EventEmitter,
  Input,
  OnInit,
  Output,
  ViewChild,
  computed,
  effect,
  inject,
  signal
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Task, TaskPriority } from '../../models/task.model';
import { Supabase, Contact } from '../../../../supabase';
import { avatarColors } from '../../../contacts/components/contact-list/contact-list';
import { TaskStore } from '../../services/task-store';

/**
 * Funktionen sind nach JSDoc Standard dokumentiert:
 *
 * TaskDetailDialog displays the details of a single task and provides functionality to:
 * - open/close the dialog with animation state
 * - edit core task fields (title, description, due date, priority, assignees)
 * - manage assigned contacts (dropdown + search + selection)
 * - manage subtasks (toggle, add, remove, inline edit)
 * - delete the task
 */
@Component({
  selector: 'app-task-detail-dialog',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './task-detail-dialog.html',
  styleUrls: [
    './task-detail-dialog.scss',
    './task-detail-dialog-view.scss',
    './task-detail-dialog-edit.scss',
  ],
})
export class TaskDetailDialog implements OnInit {
  @Input() task: Task | null = null;
  @Output() closed = new EventEmitter<void>();
  @Output() taskUpdated = new EventEmitter<void>();
  @ViewChild('searchInput') searchInputRef!: ElementRef<HTMLInputElement>;
  supabase = inject(Supabase);
  taskStore = inject(TaskStore);

  /**
   * Sets up a reactive effect to focus the search input whenever the dropdown opens.
   * Uses a microtask delay (setTimeout 0) to ensure the input exists in the DOM.
   */
  constructor() {
    effect(() => {
      if (this.dropdownOpen()) {
        setTimeout(() => this.searchInputRef?.nativeElement?.focus(), 0);
      }
    });
  }

  isClosing = signal(false);
  isEditMode = signal(false);
  dropdownOpen = signal(false);
  saving = signal(false);
  selectedContacts = signal<Contact[]>([]);
  selectedPriority = signal<TaskPriority | null>(null);
  searchText = signal('');
  editDueDate = signal('');
  newSubtaskTitle = '';
  editingSubtaskId = signal<string | null>(null);
  editingSubtaskTitle = '';
  showAllAssignees = signal(false);

  /**
   * Computed list of contacts filtered by the current search text.
   * If no search string exists, returns the full contact list.
   */
  filteredContacts = computed(() => {
    const search = this.searchText().toLowerCase();
    if (!search) return this.supabase.contacts();
    return this.supabase.contacts().filter(c => c.name.toLowerCase().includes(search));
  });

  /**
   * Enters edit mode and initializes local edit state from the current task.
   * - priority and due date are copied to local signals
   * - preselects assignees based on the task's current assignees list
   *
   * @returns void
   */
  enterEditMode(): void {
    this.isEditMode.set(true);
    this.selectedPriority.set(this.task?.priority ?? null);
    this.editDueDate.set(this.task?.dueDate ?? '');

    const preSelected = this.supabase.contacts().filter(c =>
      this.task?.assignees?.some(a => a.id === c.id)
    );
    this.selectedContacts.set(preSelected);
  }


  /**
   * Cancels edit mode without persisting changes.
   *
   * @returns void
   */
  cancelEdit(): void {
    this.isEditMode.set(false);
  }



  /**
   * Prepares assignee list from selected contacts.
   *
   * @returns Array of assignee objects with id, initials, and name.
   */
  private prepareAssignees() {
    return this.selectedContacts().map(c => ({
      id: c.id!,
      initials: this.getInitials(c.name),
      name: c.name,
    }));
  }



  /**
   * Builds the updates object for task modification.
   *
   * @param title New task title.
   * @param description New task description.
   * @param dueDate New task due date.
   * @param assignees List of assignees.
   * @returns Partial task object with updates.
   */
  private buildTaskUpdates(
    title: string,
    description: string,
    dueDate: string,
    assignees: any[]
  ): Partial<Task> {
    const updates: Partial<Task> = {
      title,
      description,
      priority: this.selectedPriority() ?? this.task!.priority,
      assignees,
    };

    if (dueDate && dueDate.trim()) {
      updates.dueDate = dueDate;
    } else if (this.task!.dueDate) {
      updates.dueDate = this.task!.dueDate;
    }

    return updates;
  }



  /**
   * Saves edits to the current task.
   * Emits `taskUpdated` after successful update.
   *
   * @param title New task title.
   * @param description New task description.
   * @param dueDate New task due date (ISO date string).
   * @returns Promise<void>
   */
  async saveEdit(title: string, description: string, dueDate: string): Promise<void> {
    if (!this.task?.id) return;

    this.saving.set(true);
    const assignees = this.prepareAssignees();
    const updates = this.buildTaskUpdates(title, description, dueDate, assignees);

    await this.taskStore.updateTask(this.task.id, updates);

    this.saving.set(false);
    this.isEditMode.set(false);
    this.taskUpdated.emit();
  }


  /**
   * Angular lifecycle hook.
   * Loads contacts so the assignee dropdown can be populated.
   *
   * @returns void
   */
  ngOnInit(): void {
    this.supabase.getContacts();
  }


  /**
   * Closes the dialog with an animation delay.
   * Sets `isClosing` to true, then emits `closed` after 400ms.
   *
   * @returns void
   */
  close(): void {
    this.isClosing.set(true);
    setTimeout(() => {
      this.isClosing.set(false);
      this.closed.emit();
    }, 400);
  }


  /**
   * Toggles the assignee dropdown open/closed.
   *
   * @returns void
   */
  toggleDropdown(): void {
    this.dropdownOpen.set(!this.dropdownOpen());
  }


  /**
   * Updates the contact search text and ensures the dropdown is open.
   *
   * @param event Input event from the search field.
   * @returns void
   */
  onSearchInput(event: Event): void {
    this.searchText.set((event.target as HTMLInputElement).value);
    this.dropdownOpen.set(true);
  }


  /**
   * Checks whether a contact is currently selected as an assignee.
   *
   * @param contact Contact to check.
   * @returns True if selected; otherwise false.
   */
  isSelected(contact: Contact): boolean {
    return this.selectedContacts().some(c => c.id === contact.id);
  }


  /**
   * Toggles a contact in/out of the selected assignees list.
   *
   * @param contact Contact to toggle.
   * @returns void
   */
  toggleContact(contact: Contact): void {
    if (this.isSelected(contact)) {
      this.selectedContacts.set(
        this.selectedContacts().filter(contacts => contacts.id !== contact.id)
      );
    } else {
      this.selectedContacts.set([...this.selectedContacts(), contact]);
    }
  }


  /**
   * Extracts up to two initials from a full name.
   *
   * @param name Full name.
   * @returns Up to two uppercase initials.
   */
  getInitials(name: string): string {
    return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  }


  /**
   * Returns a consistent avatar color derived from the given name.
   *
   * @param name Full name used as hash input.
   * @returns A color string from the predefined palette.
   */
  getAvatarColor(name: string): string {
    let hash = 0;
    for (let i = 0; i < name.length; i++) {
      hash = name.charCodeAt(i) + ((hash << 5) - hash);
    }
    return avatarColors[Math.abs(hash) % avatarColors.length];
  }


  /**
   * Returns today's date as an ISO date string (YYYY-MM-DD).
   */
  get today(): string {
    return new Date().toISOString().split('T')[0];
  }


  /**
   * Ensures the selected due date is not in the past.
   * If the user selects a past date, it is clamped to today's date.
   *
   * @param input The date input element.
   * @returns void
   */
  onDateChange(input: HTMLInputElement): void {
    if (input.value && input.value < this.today) {
      input.value = this.today;
    }
    this.editDueDate.set(input.value);
  }


  /**
   * Stops click propagation inside the card and closes the dropdown if the click
   * happened outside of the ".assigned-dropdown" container.
   *
   * @param event Mouse click event.
   * @returns void
   */
  onCardClick(event: MouseEvent): void {
    event.stopPropagation();
    const target = event.target as HTMLElement;
    if (!target.closest('.assigned-dropdown')) {
      this.dropdownOpen.set(false);
    }
    if (!target.closest('.edit-input') && !target.closest('.edit-subtask-item')) {
      this.cancelSubtaskEdit();
    }
  }


  /**
   * Deletes the current task via the TaskStore and closes the dialog afterwards.
   *
   * @returns Promise<void>
   */
  async deleteTask(): Promise<void> {
    if (!this.task?.id) return;
    await this.taskStore.deleteTask(this.task.id);
    this.closed.emit();
  }


  /**
   * Toggles completion state of a subtask and persists the change.
   * Updates the local task instance immediately for optimistic UI.
   *
   * @param subtaskId Id of the subtask to update.
   * @param done New done state.
   * @returns Promise<void>
   */
  async toggleSubtask(subtaskId: string, done: boolean): Promise<void> {
    if (!this.task) return;

    const updatedSubtasks = this.task.subtasks!.map(sub =>
      sub.id === subtaskId ? { ...sub, done } : sub
    );

    const taskId = this.task.id;
    this.task = { ...this.task, subtasks: updatedSubtasks };

    await this.taskStore.updateTask(taskId, { subtasks: updatedSubtasks });
  }


  /**
   * Event handler for subtask checkbox changes.
   * Reads the checked state and forwards to `toggleSubtask`.
   *
   * @param subtaskId Subtask id.
   * @param event Checkbox change event.
   * @returns void
   */
  onSubtaskChange(subtaskId: string, event: Event): void {
    const checked = (event.target as HTMLInputElement).checked;
    this.toggleSubtask(subtaskId, checked);
  }


  /**
   * Creates a new subtask and persists it to the current task.
   * Clears the input after creation.
   *
   * @returns Promise<void>
   */
  async addSubtask(): Promise<void> {
    if (!this.newSubtaskTitle.trim() || !this.task) return;

    const newSubtask = {
      id: this.generateUUID(),
      title: this.newSubtaskTitle.trim(),
      done: false
    };

    const updatedSubtasks = [...(this.task.subtasks ?? []), newSubtask];
    this.task = { ...this.task, subtasks: updatedSubtasks };
    this.newSubtaskTitle = '';

    await this.taskStore.updateTask(this.task.id, { subtasks: updatedSubtasks });
  }


  /**
   * Removes a subtask from the current task and persists the change.
   *
   * @param subtaskId Id of the subtask to remove.
   * @returns Promise<void>
   */
  async removeSubtask(subtaskId: string): Promise<void> {
    if (!this.task) return;

    const taskId = this.task.id;
    const updatedSubtasks = (this.task.subtasks ?? []).filter(
      subtask => subtask.id !== subtaskId
    );

    this.task = { ...this.task, subtasks: updatedSubtasks };
    await this.taskStore.updateTask(taskId, { subtasks: updatedSubtasks });
  }


  /**
   * Opens the inline edit form for a specific subtask and pre-fills its title.
   *
   * @param subtaskId Id of the subtask to edit.
   * @returns void
   */
  openEditForm(subtaskId: string): void {
    if (!this.task) return;

    const subtask = this.task.subtasks?.find(subtask => subtask.id === subtaskId);
    if (!subtask) return;

    this.editingSubtaskId.set(subtaskId);
    this.editingSubtaskTitle = subtask.title;
  }


  /**
   * Saves the inline subtask title edit and persists the change.
   * Resets the editing state afterwards.
   *
   * @returns Promise<void>
   */
  async saveSubtaskEdit(): Promise<void> {
    if (!this.task || !this.editingSubtaskId() || !this.editingSubtaskTitle.trim()) return;

    const taskId = this.task.id;
    const updatedSubtasks = (this.task.subtasks ?? []).map(subtask =>
      subtask.id === this.editingSubtaskId()
        ? { ...subtask, title: this.editingSubtaskTitle.trim() }
        : subtask
    );

    this.task = { ...this.task, subtasks: updatedSubtasks };
    this.editingSubtaskId.set(null);

    await this.taskStore.updateTask(taskId, { subtasks: updatedSubtasks });
  }


  /**
   * Cancels inline subtask editing without saving changes.
   *
   * @returns void
   */
  cancelSubtaskEdit(): void {
    this.editingSubtaskId.set(null);
  }


  /**
   * Checks if a given date is in the past (before today).
   *
   * @param dueDate The due date to check
   * @returns boolean True if the date is overdue
   */
  isOverdue(dueDate: string | undefined): boolean {
    if (!dueDate) return false;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const due = new Date(dueDate);
    due.setHours(0, 0, 0, 0);
    return due < today;
  }


  /**
   * Toggles between showing 5 assignees or all assignees.
   *
   * @returns void
   */
  toggleShowAllAssignees(): void {
    this.showAllAssignees.set(!this.showAllAssignees());
  }


  /**
   * Generates a UUID compatible with all browsers.
   *
   * @returns string A UUID v4 string
   */
  private generateUUID(): string {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = (Math.random() * 16) | 0;
      const v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  }
}
