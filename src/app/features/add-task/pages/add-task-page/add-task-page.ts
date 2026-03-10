import { Component, inject, OnInit, ViewChild, ElementRef, computed, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import {
  FormControl,
  FormGroup,
  FormsModule, AbstractControl, ValidationErrors,
  ReactiveFormsModule,
  Validators, ValidatorFn
} from '@angular/forms';
import { Supabase, Contact } from '../../../../supabase';
import { avatarColors } from '../../../contacts/components/contact-list/contact-list';
import { TaskStore } from '../../../board/services/task-store';
import { Status } from '../../../board/models/task.model';

interface Subtask {
  id: string;
  title: string;
  done: boolean;
}

@Component({
  selector: 'app-add-task-page',
  imports: [
    CommonModule,
    ReactiveFormsModule,
    FormsModule
  ],
  standalone: true,
  templateUrl: './add-task-page.html',
  styleUrl: './add-task-page.scss',
})
export class AddTaskPage implements OnInit {
  @ViewChild('searchInput') searchInputRef!: ElementRef<HTMLInputElement>;

  dropdownCategory = false;
  dropdownOpen = false;
  searchText = signal('');
  selectedContacts: Contact[] = [];
  newSubtaskTitle = '';
  subtasks: Subtask[] = [];
  editingSubtaskId: string | null = null;
  editingSubtaskTitle = '';
  showSuccessMessage = signal(false);

  supabaseService = inject(Supabase);
  taskStore = inject(TaskStore);
  router = inject(Router);

  today: string = new Date().toISOString().split('T')[0];

  categoryValidator: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
  const valid = (control.value ?? '').toString().trim();
  return valid === 'Select task category' || valid === '' ? { categoryRequired: true } : null;
};

  minDateValidator: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
    if (!control.value) return null;
    const entered = new Date(control.value);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    return entered < today ? { pastDate: true } : null;
  };

  taskForm = new FormGroup({
    title: new FormControl('', {
      validators: [Validators.required, Validators.minLength(3)]
    }),
     description: new FormControl(''),
    due_at: new FormControl('', {
      validators: [Validators.required, this.minDateValidator]
    }),
    priority: new FormControl('medium'),
  type: new FormControl('Select task category', {
  validators: [this.categoryValidator]
}),
    subtasks: new FormControl('')
  });

    filteredContacts = computed(() => {
    const search = this.searchText().toLowerCase();
    if (!search) return this.supabaseService.contacts();
    return this.supabaseService.contacts().filter(c => c.name.toLowerCase().includes(search));
  });

  ngOnInit() {
    this.supabaseService.getContacts();
  }



  /**
   * Handles the task form submission.
   *
   * Validates the form, assembles the task data and delegates to
   * {@link saveTaskAndNavigateToBoard}. Returns early if validation fails.
   */
  async formSubmit(): Promise<void> {
    if (!this.validateFormBeforeSubmit()) return;

    const taskData = this.buildTaskDataFromForm();

    await this.saveTaskAndNavigateToBoard(taskData);
  }


  /**
   * Marks all form controls as touched to trigger validation messages,
   * and checks that a valid task category has been selected.
   *
   * @returns `true` if the form is valid and ready for submission; otherwise `false`.
   */
  private validateFormBeforeSubmit(): boolean {
    if (this.taskForm.invalid) {
      Object.keys(this.taskForm.controls).forEach((key) =>
        this.taskForm.get(key)?.markAsTouched(),
      );
      return false;
    }

    if (this.taskForm.value.type === 'Select task category') {
      console.log('Please select a valid category');
      return false;
    }

    return true;
  }


  /**
   * Maps the currently selected contacts to the assignee format expected by the task model.
   *
   * @returns An array of assignee objects containing `id`, `initials` and `name`.
   */
  private buildAssigneeList(): { id: string; initials: string; name: string }[] {
    return this.selectedContacts.map((contact) => ({
      id: contact.id!,
      initials: this.getInitials(contact.name),
      name: contact.name,
    }));
  }


  /**
   * Assembles the task data object from the current form values, selected contacts
   * and added subtasks.
   *
   * @returns A fully populated task data object ready to be passed to {@link TaskStore.addTask}.
   */
  private buildTaskDataFromForm() {
    return {
      title: this.taskForm.value.title!,
      description: this.taskForm.value.description || undefined,
      status: 'todo' as Status,
      type: this.taskForm.value.type as 'Technical Task' | 'User Story',
      priority: this.taskForm.value.priority as 'high' | 'medium' | 'low',
      assignees: this.buildAssigneeList(),
      subtasks: this.subtasks,
      dueDate: this.taskForm.value.due_at || undefined,
    };
  }


  /**
   * Calls the task store to persist the new task, shows a success message on
   * completion and navigates to the board after a short delay.
   *
   * Logs an error to the console if the store call fails or throws.
   *
   * @param taskData The assembled task data produced by {@link buildTaskDataFromForm}.
   */
  private async saveTaskAndNavigateToBoard(
    taskData: ReturnType<typeof this.buildTaskDataFromForm>,
  ): Promise<void> {
    try {
      const createdTask = await this.taskStore.addTask(taskData);

      if (createdTask) {
        this.showSuccessMessage.set(true);
        setTimeout(() => {
          this.showSuccessMessage.set(false);
          this.clearForm();
          this.router.navigate(['/board']);
        }, 2000);
      } else {
        console.error('Failed to create task');
      }
    } catch (error) {
      console.error('Error creating task:', error);
    }
  }


  clearForm() {
    this.taskForm.reset({
      title: '',
      description: '',
      due_at: '',
      priority: 'medium',
      type: 'Select task category',
    });
    this.dropdownCategory = false;
    this.selectedContacts = [];
    this.subtasks = [];
    this.newSubtaskTitle = '';
  }


  actionDropdown() {
    this.dropdownCategory = !this.dropdownCategory;
  }


  selectTechnicalTask() {
    this.taskForm.patchValue({
      type: "Technical Task"
    })
    this.dropdownCategory = false;
  }


  selectUserStory() {
    this.taskForm.patchValue({
      type: "User Story"
    })
    this.dropdownCategory = false;
  }


  toggleDropdown() {
    this.dropdownOpen = !this.dropdownOpen;
    if (this.dropdownOpen) {
      setTimeout(() => this.searchInputRef?.nativeElement?.focus(), 0);
    }
  }


  onSearchInput(event: Event) {
    this.searchText.set((event.target as HTMLInputElement).value);
    this.dropdownOpen = true;
  }


  isContactSelected(contact: Contact): boolean {
    return this.selectedContacts.some(c => c.id === contact.id);
  }


  toggleContact(contact: Contact) {
    if (this.isContactSelected(contact)) {
      this.selectedContacts = this.selectedContacts.filter(c => c.id !== contact.id);
    } else {
      this.selectedContacts = [...this.selectedContacts, contact];
    }
  }


  getInitials(name: string): string {
    return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  }


  getAvatarColor(name: string): string {
    let hash = 0;
    for (let i = 0; i < name.length; i++) {
      hash = name.charCodeAt(i) + ((hash << 5) - hash);
    }
    return avatarColors[Math.abs(hash) % avatarColors.length];
  }


  addSubtask() {
    if (!this.newSubtaskTitle.trim()) return;
    const newSubtask: Subtask = {
      id: this.generateUUID(),
      title: this.newSubtaskTitle.trim(),
      done: false
    };
    this.subtasks = [...this.subtasks, newSubtask];
    this.newSubtaskTitle = '';
  }


  removeSubtask(subtaskId: string) {
    this.subtasks = this.subtasks.filter(sub => sub.id !== subtaskId);
  }


  openEditForm(subtaskId: string) {
    const subtask = this.subtasks.find(sub => sub.id === subtaskId);
    if (!subtask) return;
    this.editingSubtaskId = subtaskId;
    this.editingSubtaskTitle = subtask.title;
  }


  saveSubtaskEdit() {
    if (!this.editingSubtaskId || !this.editingSubtaskTitle.trim()) return;
    this.subtasks = this.subtasks.map(sub =>
      sub.id === this.editingSubtaskId
        ? { ...sub, title: this.editingSubtaskTitle.trim() }
        : sub
    );
    this.editingSubtaskId = null;
  }


  onBackdropClick(event: MouseEvent) {
    const target = event.target as HTMLElement;
    if (!target.closest('.assigned-dropdown')) {
      this.dropdownOpen = false;
    }
    if (!target.closest('.category-dropdown')) {
      this.dropdownCategory = false;
    }
  }


  private generateUUID(): string {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = (Math.random() * 16) | 0;
      const v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  }
}
