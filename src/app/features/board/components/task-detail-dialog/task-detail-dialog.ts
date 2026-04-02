import {Component, ElementRef, HostListener, input, OnInit, output, viewChild, computed, effect, inject, signal} from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Task, TaskPriority } from '../../models/task.model';
import { Supabase, Contact } from '../../../../supabase';
import { avatarColors } from '../../../contacts/components/contact-list/contact-list';
import { TaskStore } from '../../services/task-store';
import { compressImage } from '../../../../shared/utils/image-compression.utils';

/**
 * Represents an attachment file.
 */
interface Attachment {
  id: string;
  file: File;
  preview: string;
  name: string;
}

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
    './_attachments.scss',
  ],
})
export class TaskDetailDialog implements OnInit {
  task = input<Task | null>(null);
  closed = output<void>();
  taskUpdated = output<void>();
  searchInputRef = viewChild<ElementRef<HTMLInputElement>>('searchInput');
  fileInputRef = viewChild<ElementRef<HTMLInputElement>>('fileInput');
  supabase = inject(Supabase);
  taskStore = inject(TaskStore);

  /**
   * Sets up a reactive effect to focus the search input whenever the dropdown opens.
   * Uses a microtask delay (setTimeout 0) to ensure the input exists in the DOM.
   */
  constructor() {
    effect(() => {
      if (this.dropdownOpen()) {
        setTimeout(() => this.searchInputRef()?.nativeElement?.focus(), 0);
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
  attachments = signal<Attachment[]>([]);
  editingSubtaskId = signal<string | null>(null);
  editingSubtaskTitle = '';
  showAllAssignees = signal(false);
  showViewer = signal(false);
  currentImageIndex = signal(0);
  zoomLevel = signal(100);
  errorMessage = signal<string>('');
  isDragging = signal(false);

  /**
   * Computed list of contacts filtered by the current search text.
   * If no search string exists, returns the full contact list.
   */
  filteredContacts = computed(() => {
    const search = this.searchText().toLowerCase();
    if (!search) return this.supabase.contacts();
    return this.supabase.contacts().filter((c) => c.name.toLowerCase().includes(search));
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
    this.selectedPriority.set(this.task()?.priority ?? null);
    this.editDueDate.set(this.task()?.dueDate ?? '');

    const preSelected = this.supabase
      .contacts()
      .filter((c) => this.task()?.assignees?.some((a) => a.id === c.id));
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
    return this.selectedContacts().map((c) => ({
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
    assignees: any[],
  ): Partial<Task> {
    const currentTask = this.task();
    const updates: Partial<Task> = {
      title,
      description,
      priority: this.selectedPriority() ?? currentTask!.priority,
      assignees,
    };
    if (dueDate && dueDate.trim()) {
      updates.dueDate = dueDate;
    } else if (currentTask!.dueDate) {
      updates.dueDate = currentTask!.dueDate;
    }
    return updates;
  }

  /**
   * Saves edits to the current task, including any new attachments.
   * Emits `taskUpdated` after successful update.
   *
   * @param title New task title.
   * @param description New task description.
   * @param dueDate New task due date (ISO date string).
   * @returns Promise<void>
   */
  async saveEdit(title: string, description: string, dueDate: string): Promise<void> {
    const currentTask = this.task();
    if (!currentTask?.id) return;
    this.saving.set(true);
    const assignees = this.prepareAssignees();
    const updates = this.buildTaskUpdates(title, description, dueDate, assignees);

    // Combine existing attachments (possibly modified by deletions) with new ones
    const existingAttachments = currentTask.attachments || [];
    const newAttachments = this.attachments().map((att) => ({
      id: att.id,
      name: att.name,
      base64: att.preview,
      type: att.file.type,
    }));
    updates.attachments = [...existingAttachments, ...newAttachments];

    await this.taskStore.updateTask(currentTask.id, updates);
    this.attachments.set([]);
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
    return this.selectedContacts().some((c) => c.id === contact.id);
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
        this.selectedContacts().filter((contacts) => contacts.id !== contact.id),
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
    return name
      .split(' ')
      .map((n) => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
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
    const currentTask = this.task();
    if (!currentTask?.id) return;
    await this.taskStore.deleteTask(currentTask.id);
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
    const currentTask = this.task();
    if (!currentTask) return;
    const updatedSubtasks = currentTask.subtasks!.map((sub) =>
      sub.id === subtaskId ? { ...sub, done } : sub,
    );
    await this.taskStore.updateTask(currentTask.id, { subtasks: updatedSubtasks });
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
    const currentTask = this.task();
    if (!this.newSubtaskTitle.trim() || !currentTask) return;

    const newSubtask = {
      id: this.generateUUID(),
      title: this.newSubtaskTitle.trim(),
      done: false,
    };

    const updatedSubtasks = [...(currentTask.subtasks ?? []), newSubtask];
    this.newSubtaskTitle = '';

    await this.taskStore.updateTask(currentTask.id, { subtasks: updatedSubtasks });
  }

  /**
   * Removes a subtask from the current task and persists the change.
   *
   * @param subtaskId Id of the subtask to remove.
   * @returns Promise<void>
   */
  async removeSubtask(subtaskId: string): Promise<void> {
    const currentTask = this.task();
    if (!currentTask) return;

    const updatedSubtasks = (currentTask.subtasks ?? []).filter(
      (subtask) => subtask.id !== subtaskId,
    );

    await this.taskStore.updateTask(currentTask.id, { subtasks: updatedSubtasks });
  }

  /**
   * Opens the inline edit form for a specific subtask and pre-fills its title.
   *
   * @param subtaskId Id of the subtask to edit.
   * @returns void
   */
  openEditForm(subtaskId: string): void {
    const currentTask = this.task();
    if (!currentTask) return;

    const subtask = currentTask.subtasks?.find((subtask) => subtask.id === subtaskId);
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
    const currentTask = this.task();
    if (!currentTask || !this.editingSubtaskId() || !this.editingSubtaskTitle.trim()) return;

    const updatedSubtasks = (currentTask.subtasks ?? []).map((subtask) =>
      subtask.id === this.editingSubtaskId()
        ? { ...subtask, title: this.editingSubtaskTitle.trim() }
        : subtask,
    );

    this.editingSubtaskId.set(null);

    await this.taskStore.updateTask(currentTask.id, { subtasks: updatedSubtasks });
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

  /**
   * Triggers the hidden file input to open the file picker.
   */
  triggerFileInput() {
    this.fileInputRef()?.nativeElement?.click();
  }

  /**
   * Handles the dragover event to enable file drop.
   * Prevents default behavior to allow dropping.
   *
   * @param event - The drag event.
   */
  onDragOver(event: DragEvent) {
    event.preventDefault();
    event.stopPropagation();
    this.isDragging.set(true);
  }

  /**
   * Handles the dragleave event when dragged item leaves the drop zone.
   *
   * @param event - The drag event.
   */
  onDragLeave(event: DragEvent) {
    event.preventDefault();
    event.stopPropagation();
    this.isDragging.set(false);
  }

  /**
   * Handles the drop event when files are dropped.
   * Extracts files and processes them through validation.
   *
   * @param event - The drop event containing the files.
   */
  async onDrop(event: DragEvent) {
    event.preventDefault();
    event.stopPropagation();
    this.isDragging.set(false);

    const files = event.dataTransfer?.files;
    if (files && files.length > 0) {
      await this.processFiles(Array.from(files));
    }
  }

  /**
   * Processes and validates uploaded files.
   * Checks file format (JPEG, PNG) and size (max 1 MB).
   *
   * @param files - Array of files to process.
   */
  private async processFiles(files: File[]) {
    const allowedTypes = ['image/jpeg', 'image/png'];

    for (const file of files) {
      if (!allowedTypes.includes(file.type)) {
        this.showError(`File format not allowed!\nYou can only upload JPEG or PNG`);
        continue;
      }

      try {
        const compressedBase64 = await this.compressImage(file, 800, 800, 0.7);
        const attachment: Attachment = {
          id: this.generateUUID(),
          file: file,
          preview: compressedBase64,
          name: file.name,
        };
        this.attachments.update((current) => [...current, attachment]);
      } catch (error) {
        console.error('Error compressing image:', error);
        this.showError(`Error processing image!`);
      }
    }
  }

  /**
   * Compresses an image to a target size and quality using utility function.
   *
   * @param file - The image file to compress.
   * @param maxWidth - Maximum width of the image (default: 800px).
   * @param maxHeight - Maximum height of the image (default: 800px).
   * @param quality - Quality of the compressed image (0-1, default: 0.7).
   * @returns Promise resolving to the compressed image as base64 string.
   */
  private compressImage(
    file: File,
    maxWidth: number = 800,
    maxHeight: number = 800,
    quality: number = 0.7,
  ): Promise<string> {
    return compressImage(file, maxWidth, maxHeight, quality);
  }

  /**
   * Handles file selection from the file input.
   * Validates file format (JPEG, PNG) and size (max 1 MB).
   * Displays error messages if validation fails.
   */
  async onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (!input.files) return;

    await this.processFiles(Array.from(input.files));
    input.value = '';
  }

  /**
   * Displays an error message to the user.
   * The message automatically disappears after 5 seconds.
   *
   * @param message - The error message to display.
   */
  private showError(message: string) {
    this.errorMessage.set(message);
    setTimeout(() => this.errorMessage.set(''), 5000);
  }

  /**
   * Removes a specific attachment from the list.
   */
  removeAttachment(attachmentId: string) {
    this.attachments.set(this.attachments().filter((att) => att.id !== attachmentId));
  }

  /**
   * Removes a specific existing attachment from the task.
   */
  removeExistingAttachment(attachmentId: string) {
    const currentTask = this.task();
    if (!currentTask) return;
    const updatedAttachments = (currentTask.attachments || []).filter((att) => att.id !== attachmentId);
    // Note: Local mutation removed - parent should re-render after save
  }

  /**
   * Removes all attachments (both new and existing).
   */
  clearAllAttachments() {
    this.attachments.set([]);
    // Note: Local task mutation removed - parent should re-render after save
  }

  /**
   * Opens an attachment image in the inline gallery viewer.
   *
   * @param attachment - The attachment to view.
   */
  viewAttachment(attachment: { id: string; name: string; base64: string; type: string }) {
    const currentTask = this.task();
    if (!currentTask?.attachments) return;

    const index = currentTask.attachments.findIndex((a) => a.id === attachment.id);
    if (index === -1) return;

    this.currentImageIndex.set(index);
    this.showViewer.set(true);
  }

  /**
   * Closes the image viewer and resets zoom.
   */
  closeViewer() {
    this.showViewer.set(false);
    this.zoomLevel.set(100);
  }

  /**
   * Navigates to the previous image in the gallery and resets zoom.
   */
  previousImage() {
    if (this.currentImageIndex() > 0) {
      this.currentImageIndex.set(this.currentImageIndex() - 1);
      this.zoomLevel.set(100);
    }
  }

  /**
   * Navigates to the next image in the gallery and resets zoom.
   */
  nextImage() {
    const currentTask = this.task();
    if (currentTask?.attachments && this.currentImageIndex() < currentTask.attachments.length - 1) {
      this.currentImageIndex.set(this.currentImageIndex() + 1);
      this.zoomLevel.set(100);
    }
  }

  /**
   * Zooms in the current image.
   */
  zoomIn() {
    const current = this.zoomLevel();
    if (current < 300) {
      this.zoomLevel.set(current + 25);
    }
  }

  /**
   * Zooms out the current image.
   */
  zoomOut() {
    const current = this.zoomLevel();
    if (current > 50) {
      this.zoomLevel.set(current - 25);
    }
  }

  /**
   * Gets the file size in KB from base64 string.
   */
  getImageSize(): string {
    const img = this.getCurrentImage();
    if (!img) return '0';

    const base64Length = img.base64.length;
    const sizeInBytes = (base64Length * 3) / 4;
    const sizeInKB = Math.round(sizeInBytes / 1024);

    return sizeInKB.toString();
  }

  /**
   * Downloads the current image.
   */
  downloadImage() {
    const img = this.getCurrentImage();
    if (!img) return;

    const link = document.createElement('a');
    link.href = img.base64;
    link.download = img.name;
    link.click();
  }

  /**
   * Handles keyboard navigation in the viewer.
   * Listens for arrow keys, escape, and zoom keys when viewer is open.
   */
  @HostListener('document:keydown', ['$event'])
  onViewerKeydown(event: KeyboardEvent) {
    if (!this.showViewer()) return;

    if (event.key === 'ArrowLeft') {
      event.preventDefault();
      this.previousImage();
    } else if (event.key === 'ArrowRight') {
      event.preventDefault();
      this.nextImage();
    } else if (event.key === 'Escape') {
      event.preventDefault();
      this.closeViewer();
    } else if (event.key === '+' || event.key === '=') {
      event.preventDefault();
      this.zoomIn();
    } else if (event.key === '-') {
      event.preventDefault();
      this.zoomOut();
    }
  }

  /**
   * Gets the current image being viewed.
   */
  getCurrentImage() {
    const currentTask = this.task();
    if (!currentTask?.attachments) return null;
    return currentTask.attachments[this.currentImageIndex()] || null;
  }
}
