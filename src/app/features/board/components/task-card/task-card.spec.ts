import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TaskCard } from './task-card';
import { Task } from '../../models/task.model';

describe('TaskCard', () => {
  let component: TaskCard;
  let fixture: ComponentFixture<TaskCard>;
  let mockTask: Task;

  beforeEach(async () => {
    mockTask = {
      id: 'test-id',
      title: 'Test Task',
      description: 'Test Description',
      status: 'todo',
      type: 'User Story',
      priority: 'medium',
      assignedTo: [],
      subtasks: [],
      dueDate: new Date().toISOString(),
      createdAt: new Date().toISOString()
    } as Task;

    await TestBed.configureTestingModule({
      imports: [TaskCard]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TaskCard);
    component = fixture.componentInstance;
    component.task = mockTask;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
