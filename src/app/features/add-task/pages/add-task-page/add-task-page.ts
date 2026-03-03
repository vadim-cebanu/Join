import { Component, inject, OnInit, ViewChild, ElementRef, computed, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
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

  today: string = new Date().toISOString().split('T')[0];

  categoryValidator: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
  const valid = (control.value ?? '').toString().trim();
  return valid === 'Select task category' || valid === '' ? { categoryRequired: true } : null;
};

  taskForm = new FormGroup({
    title: new FormControl('', {
      validators: [Validators.required, Validators.minLength(3)]
    }),
     description: new FormControl(''),
    due_at: new FormControl('', {
      validators: [Validators.required]
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


  async formSubmit() {
    if (this.taskForm.invalid) {
      Object.keys(this.taskForm.controls).forEach(key => {
        this.taskForm.get(key)?.markAsTouched();
      });
      return;
    }

    const typeValue = this.taskForm.value.type;
    if (typeValue === 'Select task category') {
      console.log('Please select a valid category');
      return;
    }

    const assignees = this.selectedContacts.map(c => ({
      id: c.id!,
      initials: this.getInitials(c.name),
      name: c.name,
    }));

    const taskData = {
      title: this.taskForm.value.title!,
      description: this.taskForm.value.description || undefined,
      status: 'todo' as Status,
      type: this.taskForm.value.type as 'Technical Task' | 'User Story',
      priority: this.taskForm.value.priority as 'high' | 'medium' | 'low',
      assignees,
      subtasks: this.subtasks,
      dueDate: this.taskForm.value.due_at || undefined,
    };

    try {
      const result = await this.taskStore.addTask(taskData);
      if (result) {
        this.showSuccessMessage.set(true);
        setTimeout(() => {
          this.showSuccessMessage.set(false);
          this.clearForm();
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

  TTSelction() {
    this.taskForm.patchValue({
      type: "Technical Task"
    })
    this.dropdownCategory = false;
  }

  USSelction() {
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
      id: crypto.randomUUID(),
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
  }
}
