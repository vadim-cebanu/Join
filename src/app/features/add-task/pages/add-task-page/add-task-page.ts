import { Component, inject } from '@angular/core';
import { 
  FormControl,
  FormGroup,
  ReactiveFormsModule,
  Validators
} from '@angular/forms';
import { RouterOutlet } from '@angular/router';
import { Supabase } from '../../../../supabase';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-add-task-page',
  imports: [
    RouterOutlet,
    ReactiveFormsModule,
    CommonModule
  ],
  templateUrl: './add-task-page.html',
  styleUrl: './add-task-page.scss',
})

export class AddTaskPage {
  editingIndex: number | null = null;

  subtasksJSON: { task: string | null | undefined }[] = [];

  asOfCategory:boolean = false;
  
  dropdownCategory:boolean = false;

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
    subtasks: new FormControl('', {
      validators: []
    }),
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
actionDropdown(){
  !this.dropdownCategory ? this.dropdownCategory = true : this.dropdownCategory = false 
   }

TTSelction(){
  this.taskForm.patchValue({
    type: "Technical Task"
  })
  this.dropdownCategory = false;
 }

USSelction(){
    this.taskForm.patchValue({
    type: "User Story"
  })
  this.dropdownCategory = false;
 }

 asOfSubtasks() {
  let value = this.taskForm.get('subtasks')?.value;
  value && value?.length > 0 ? this.asOfCategory = true : this.asOfCategory = false;
 }

 subtasksSaveJson() {
  let value = this.taskForm.get('subtasks')?.value;
  this.subtasksJSON.push({
    task: value
  })
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
}