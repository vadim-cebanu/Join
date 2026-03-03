import { Component, inject, OnInit, signal } from '@angular/core';
import {
  FormControl,
  FormGroup,
  ReactiveFormsModule,
  Validators
} from '@angular/forms';
import { RouterOutlet } from '@angular/router';
import { Supabase } from '../../../../supabase';
import { CommonModule, JsonPipe } from '@angular/common';

@Component({
  selector: 'app-add-task-page',
  imports: [
    RouterOutlet,
    ReactiveFormsModule,
    CommonModule,
    JsonPipe
  ],
  templateUrl: './add-task-page.html',
  styleUrl: './add-task-page.scss',
})
export class AddTaskPage implements OnInit {

    ngOnInit() {
    this.getProducts();
  }

  showAssignedDropdown: boolean = false;

  filteredContacts: any[] = [];

  contacts = signal<{name:string}[]>([]);

  showSuccessMessage = signal(false);

  editingIndex: number | null = null;

  subtasksJSON: { task: string | null | undefined }[] = [];

  asOfCategory: boolean = false;

  dropdownCategory: boolean = false;

  supabaseService = inject(Supabase);

  today: string = new Date().toISOString().split('T')[0];

  taskForm = new FormGroup({
    title: new FormControl('', {
      validators: [Validators.required, Validators.minLength(3)]
    }),
    description: new FormControl('', {
      validators: [Validators.required, Validators.maxLength(10)]
    }),
    due_at: new FormControl('', {
      validators: [Validators.required]
    }),
    priority: new FormControl('medium'),
    type: new FormControl('Select task category', {
      validators: [Validators.required]
    }),
    subtasks: new FormControl('')
  });

  async formSubmit() {
    if (this.taskForm.invalid) return;

    console.log(this.taskForm.value);

    const { data, error } = await this.supabaseService.supabase
      .from('tasks')
      .insert([this.taskForm.value])
      .select();

    if (error) {
      console.error(error);
      return;
    }

    console.log('Task erstellt:', data);

    this.showSuccessMessage.set(true);
    setTimeout(() => {
      this.showSuccessMessage.set(false);
      this.clearForm();
    }, 2000);
  }

  clearForm() {
    this.taskForm.reset({
      title: '',
      description: '',
      due_at: '',
      priority: 'medium',
      type: 'Select task category',
      subtasks: ''
    });
    this.dropdownCategory = false;
  }

  actionDropdown() {
    this.dropdownCategory = !this.dropdownCategory;
  }

  TTSelction() {
    this.taskForm.patchValue({ type: 'Technical Task' });
    this.dropdownCategory = false;
  }

  USSelction() {
    this.taskForm.patchValue({ type: 'User Story' });
    this.dropdownCategory = false;
  }

  asOfSubtasks() {
    const value = this.taskForm.get('subtasks')?.value;
    this.asOfCategory = !!value && value.length > 0;
  }

  subtasksSaveJson() {
    const value = this.taskForm.get('subtasks')?.value;

    this.subtasksJSON.push({ task: value });

    this.taskForm.get('subtasks')?.setValue('');
    this.asOfCategory = false;
  }

  inputReset() {
    this.taskForm.get('subtasks')?.setValue('');
  }

  removeSubtask(index: number) {
    this.subtasksJSON.splice(index, 1);
  }

  editSubtask(index: number) {
    this.editingIndex = index;
  }

  refreshSubtasks(index: number, input: HTMLInputElement) {
    const newValue = input.value?.trim();
    if (!newValue) return;

    this.subtasksJSON[index].task = newValue;
    this.editingIndex = null;
  }

  async getProducts() {
   /* An dieser Stelle werden die Daten, die durch .select() von der Datenbank geholt wurden,
   in dein Angular-Signal products hineingeschrieben. */
  const { data, error } = await this.supabaseService.supabase
    .from('contacts')
    .select('name')
    /* Begrenzen Anzeige */
    .range(0, 10)
    /* Begrenzen nach Werten */
/*     .lt('count', '50')
    .lte('count', '5') */

  if (error) {
    console.error(error)
    return
  }

  if (!data) return

  this.contacts.set(data)
 }

  getInitials(name: string): string {
    if (!name) return '';

    const parts = name.trim().split(' ');

    if (parts.length === 1) {
      return parts[0].substring(0, 2).toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

      colorAvatar(name: string): string {
      const colors: string[] = [
        '#FF7A00',
        '#FF5EB3',
        '#6E52FF',
        '#9327FF',
        '#00BEE8',
        '#1FD7C1',
        '#FF745E',
        '#FFA35E',
        '#FC71FF',
        '#FFC701',
        '#0038FF',
        '#C3FF2B'
      ];

      let hash = 0;

      for (let i = 0; i < name.length; i++) {
        hash = name.charCodeAt(i) + ((hash << 5) - hash);
      }

      const index = Math.abs(hash % colors.length);
      return colors[index];
      }

  filterContacts(value: string) {
    this.filteredContacts = this.contacts().filter(contact =>
      contact.name.toLowerCase().includes(value.toLowerCase())
    );
  }

  hideDropdown(event: FocusEvent) {
  const relatedTarget = event.relatedTarget as HTMLElement;

  if (!event.currentTarget ||
      !(event.currentTarget as HTMLElement).contains(relatedTarget)) {
    this.showAssignedDropdown = false;
  }
}

openAssignedDropdown() {
  this.filteredContacts = this.contacts();
  this.showAssignedDropdown = true;
}
}
