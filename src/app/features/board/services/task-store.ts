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
   * @param defer If true, defers the signal update to avoid change detection errors
   * @returns Promise<void>
   */
  async loadTasks(defer: boolean = false): Promise<void> {
    const { data, error } = await this.supabase.supabase
      .from('tasks')
      .select('*')
      .order('position', { ascending: true })
      .order('created_at', { ascending: false });

    if (error) {
      return;
    }

    const tasks: Task[] = (data || []).map((task) => ({
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

    if (defer) {
      setTimeout(() => this.tasksSignal.set(tasks), 0);
    } else {
      this.tasksSignal.set(tasks);
    }
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
   * Internally delegates to helper methods for auth-validation, payload building,
   * database insertion and model mapping to keep each step focused and testable.
   *
   * @param data         Data required to create the task.
   * @param skipReload   If true, skips reloading tasks after insertion (useful for
   *                     dialogs that need to avoid change-detection errors).
   * @returns The created {@link Task} mapped to the app model, or `null` on failure.
   */
  async addTask(
    data: {
      title: string;
      description?: string;
      status: Status;
      type: TaskType;
      priority: TaskPriority;
      assignees?: { id: string; initials: string; name?: string }[];
      subtasks?: { id: string; title: string; done: boolean }[];
      dueDate?: string;
    },
    skipReload: boolean = false,
  ): Promise<Task | null> {
    const { userId, isGuest } = this.resolveAuthContext();

    if (!this.canCreateTask(userId, isGuest)) return null;

    const newTaskPayload = this.buildNewTaskPayload(userId, data);
    const insertedRow = await this.insertTaskIntoDatabase(newTaskPayload);

    if (!insertedRow) return null;

    if (!skipReload) await this.loadTasks(true);

    return this.mapRowToTaskModel(insertedRow);
  }

  /**
   * Reads the current authentication context from the Supabase service.
   *
   * @returns An object containing the authenticated user's id (or `undefined`
   *          for guests) and a flag indicating whether the session is a guest session.
   */
  private resolveAuthContext(): { userId: string | undefined; isGuest: boolean } {
    const userId = this.supabase.currentUser()?.id;
    const isGuest = this.supabase.isGuest();
    console.log('addTask called - userId:', userId, 'isGuest:', isGuest);
    return { userId, isGuest };
  }

  /**
   * Determines whether the current session is allowed to create a task.
   *
   * A task may be created either by an authenticated user or by a guest.
   * Logs an error and returns `false` if neither condition is met.
   *
   * @param userId  The authenticated user's id, or `undefined` if not logged in.
   * @param isGuest `true` when the current session is a guest session.
   * @returns `true` if task creation is permitted; otherwise `false`.
   */
  private canCreateTask(userId: string | undefined, isGuest: boolean): boolean {
    if (!userId && !isGuest) {
      console.error('Cannot create task: Not authenticated and not guest');
      return false;
    }
    return true;
  }

  /**
   * Builds the Supabase insert payload from the task form data.
   *
   * Maps camelCase app-model fields to the snake_case DB column names
   * and applies default values for optional array fields.
   *
   * @param userId   The authenticated user's id (may be `undefined` for guests).
   * @param taskData The raw task form data collected from the UI.
   * @returns A plain object ready to be passed to a Supabase `insert` call.
   */
  private buildNewTaskPayload(
    userId: string | undefined,
    taskData: {
      title: string;
      description?: string;
      status: Status;
      type: TaskType;
      priority: TaskPriority;
      assignees?: { id: string; initials: string; name?: string }[];
      subtasks?: { id: string; title: string; done: boolean }[];
      dueDate?: string;
    },
  ) {
    return {
      created_by: userId ?? null,
      title: taskData.title,
      description: taskData.description,
      status: taskData.status,
      type: taskData.type,
      priority: taskData.priority,
      assignees: taskData.assignees ?? [],
      subtasks: taskData.subtasks ?? [],
      due_at: taskData.dueDate,
    };
  }

  /**
   * Executes the Supabase insert for a single task and returns the persisted row.
   *
   * Logs a detailed error (message, code, details, hint) if the operation fails.
   *
   * @param payload The DB-ready payload produced by {@link buildNewTaskPayload}.
   * @returns The raw Supabase row on success, or `null` if an error occurred.
   */
  private async insertTaskIntoDatabase(payload: object): Promise<Record<string, unknown> | null> {
    const { data: insertedRow, error } = await this.supabase.supabase
      .from('tasks')
      .insert([payload])
      .select()
      .single();

    if (error) {
      console.error('Supabase error creating task:', error);
      console.error('Error details:', {
        message: error.message,
        code: error.code,
        details: error.details,
        hint: error.hint,
      });
      return null;
    }

    return insertedRow;
  }

  /**
   * Maps a raw Supabase task row to the app's {@link Task} model.
   *
   * Handles missing fields by applying safe defaults (e.g. empty arrays for
   * `assignees` / `subtasks`, `'Technical Task'` as fallback task type).
   *
   * @param row The raw database row returned by Supabase after an insert or select.
   * @returns A fully typed {@link Task} object ready for use in the application.
   */
  private mapRowToTaskModel(row: Record<string, unknown>): Task {
    return {
      id: row['id'] as string,
      title: row['title'] as string,
      description: row['description'] as string | undefined,
      status: row['status'] as Status,
      type: (row['type'] as TaskType) ?? 'Technical Task',
      priority: row['priority'] as TaskPriority,
      assignees: (row['assignees'] as Task['assignees']) ?? [],
      subtasks: (row['subtasks'] as Task['subtasks']) ?? [],
      createdAt: row['created_at'] as string,
    };
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
    this.tasksSignal.update((tasks) => tasks.map((t) => (t.id === id ? { ...t, ...updates } : t)));

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
        ...(updates.dueDate !== undefined && { due_at: updates.dueDate }),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Error updating task:', error);
      await this.loadTasks(true);
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
    const { error } = await this.supabase.supabase.from('tasks').delete().eq('id', taskId);

    if (error) {
      return false;
    }

    await this.loadTasks(true);
    return true;
  }
}
