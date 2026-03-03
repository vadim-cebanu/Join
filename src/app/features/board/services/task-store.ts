import { Injectable, signal, computed } from '@angular/core';
import { Task, Status, TaskPriority, TaskType } from '../models/task.model';
import { Supabase } from '../../../supabase';

@Injectable({
  providedIn: 'root',
})
export class TaskStore {
  /**
   * Funktionen sind nach JSDoc Standard dokumentiert:
   *
   * TaskStore is a lightweight state container for tasks.
   * It provides:
   * - a reactive task list via Angular signals
   * - CRUD operations backed by Supabase
   * - convenience methods for loading and mapping DB rows into the Task model
   */

  /** Internal reactive task state. */
  private tasksSignal = signal<Task[]>([]);

  /**
   * Public computed signal for consuming components.
   *
   * @returns Current task array.
   */
  tasks = computed(() => this.tasksSignal());

  /**
   * Creates a new TaskStore.
   *
   * @param supabase Supabase service wrapper used for DB operations and auth.
   */
  constructor(private supabase: Supabase) {}

  /**
   * Loads tasks from Supabase and updates the internal signal.
   *
   * Ordering:
   * - first by `position` ascending (for manual ordering)
   * - then by `created_at` descending (newest first among same position)
   *
   * Notes:
   * - Maps DB column names to the Task model fields (e.g. `created_at` -> `createdAt`).
   * - If an error occurs, this method exits silently (caller can decide how to handle).
   *
   * @returns Promise<void>
   */
  async loadTasks(): Promise<void> {
    const { data, error } = await this.supabase.supabase
      .from('tasks')
      .select('*')
      .order('position', { ascending: true })
      .order('created_at', { ascending: false });

    if (error) {
      return;
    }

    const tasks: Task[] = (data || []).map(task => ({
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      type: task.type || 'Technical Task',
      priority: task.priority,
      assignees: task.assignees || [],
      subtasks: Array.isArray(task.subtasks) ? task.subtasks : [],
      createdAt: task.created_at,
      dueDate: task.due_at,
      // NOTE: This field is not part of the provided Task interface unless you added it elsewhere.
      position: task.position ?? 999,
    })) as Task[];

    queueMicrotask(() => {
      this.tasksSignal.set(tasks);
    });
  }

  /**
   * Convenience method to load tasks and return the current state.
   *
   * @returns Promise resolving to the current task list.
   */
  async getTasks(): Promise<Task[]> {
    await this.loadTasks();
    return this.tasksSignal();
  }

  /**
   * Inserts a new task into Supabase and refreshes local store state.
   *
   * @param data Data required to create the task.
   * @returns The created Task mapped to the app model, or null on failure.
   */
  async addTask(data: {
    title: string;
    description?: string;
    status: Status;
    type: TaskType;
    priority: TaskPriority;
    assignees?: { id: string; initials: string; name?: string }[];
    subtasks?: { id: string; title: string; done: boolean }[];
    dueDate?: string;
  }): Promise<Task | null> {
    const userId = this.supabase.currentUser()?.id;
    if (!userId) {
      return null;
    }

    const { data: result, error } = await this.supabase.supabase
      .from('tasks')
      .insert([
        {
          created_by: userId,
          title: data.title,
          description: data.description,
          status: data.status,
          type: data.type,
          priority: data.priority,
          assignees: data.assignees || [],
          subtasks: data.subtasks || [],
          due_at: data.dueDate,
        },
      ])
      .select()
      .single();

    if (error) {
      return null;
    }

    await this.loadTasks();

    return result
      ? {
          id: result.id,
          title: result.title,
          description: result.description,
          status: result.status,
          type: result.type || 'Technical Task',
          priority: result.priority,
          assignees: result.assignees || [],
          subtasks: result.subtasks || [],
          createdAt: result.created_at,
          dueDate: result.due_at,
        }
      : null;
  }

  /**
   * Updates a task in local state immediately (optimistic update),
   * then persists changes to Supabase.
   *
   * If the DB update fails:
   * - logs the error
   * - reloads tasks from Supabase to restore consistency
   *
   * @param id Task id to update.
   * @param updates Partial Task fields to apply.
   * @returns Updated row returned by Supabase, or null if the update failed.
   */
  async updateTask(id: string, updates: Partial<Task>): Promise<Task | null> {
    // Optimistic local update for snappier UI.
    this.tasksSignal.update(tasks =>
      tasks.map(t => (t.id === id ? { ...t, ...updates } : t))
    );

    const { data, error } = await this.supabase.supabase
      .from('tasks')
      .update({
        title: updates.title,
        description: updates.description,
        status: updates.status,
        type: updates.type,
        priority: updates.priority,
        ...(updates.assignees !== undefined && { assignees: updates.assignees }),
        ...(updates.subtasks !== undefined && { subtasks: updates.subtasks }),
        due_at: updates.dueDate || null,
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Error updating task:', error);
      await this.loadTasks();
      return null;
    }

    return data;
  }

  /**
   * Deletes a task from Supabase and refreshes local store state.
   *
   * @param taskId Id of the task to delete.
   * @returns True if the delete succeeded; otherwise false.
   */
  async deleteTask(taskId: string): Promise<boolean> {
    const { error } = await this.supabase.supabase
      .from('tasks')
      .delete()
      .eq('id', taskId);

    if (error) {
      return false;
    }

    await this.loadTasks();
    return true;
  }
}
