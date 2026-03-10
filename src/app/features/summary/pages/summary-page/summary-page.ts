import { CommonModule, DatePipe } from '@angular/common';
import { Component, inject, signal, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { Supabase } from '../../../../supabase';

/** Dashboard summary page showing an overview of tasks and project status. */
@Component({
  selector: 'app-summary-page',
  imports: [CommonModule, DatePipe, RouterLink],
  templateUrl: './summary-page.html',
  styleUrl: './summary-page.scss',
})
export class SummaryPage implements OnInit {
  supabase = inject(Supabase);
  userName = signal<string>('');
  toDoCount = signal<number>(0);
  doneCount = signal<number>(0);
  urgentCount = signal<number>(0);
  upcomingDeadline = signal<string | null>(null);
  tasksInBoard = signal<number>(0);
  tasksInProgress = signal<number>(0);
  awaitingFeedback = signal<number>(0);

  async ngOnInit() {
    await this.loadUserName();
    await this.loadTaskMetrics();
  }


  /**
   * Loads the current user's name from user metadata.
   */
  async loadUserName() {
    const {
      data: { user },
    } = await this.supabase.supabase.auth.getUser();
    if (user) {
      const { data: profile } = await this.supabase.supabase
        .from('profiles')
        .select('display_name')
        .eq('id', user.id)
        .single();
      const name = profile?.display_name || user.user_metadata?.['display_name'] || '';
      this.userName.set(name ? this.capitalizeWords(name) : '');
    }
  }


  /**
   * Capitalizes the first letter of each word.
   */
  private capitalizeWords(text: string): string {
    return text
      .split(' ')
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
      .join(' ');
  }


  /**
   * Loads all tasks and updates the dashboard metrics signals.
   *
   * Delegates fetching, count calculation and deadline resolution to
   * dedicated helper methods. Exits silently on database error.
   */
  async loadTaskMetrics() {
    const tasks = await this.fetchTasks();
    if (!tasks) return;

    this.calculateTaskCounts(tasks);
    this.findUpcomingDeadline(tasks);
  }



  /**
   * Fetches all tasks from the database.
   *
   * @returns Array of tasks or null if error.
   */
  private async fetchTasks() {
    const { data: tasks, error } = await this.supabase.supabase
      .from('tasks')
      .select('*');

    return error ? null : tasks;
  }



  /**
   * Calculates and updates task count signals.
   *
   * @param tasks Array of tasks.
   */
  private calculateTaskCounts(tasks: any[]) {
    this.toDoCount.set(tasks.filter(t => t.status === 'todo').length);
    this.doneCount.set(tasks.filter(t => t.status === 'done').length);
    this.urgentCount.set(tasks.filter(t => t.priority === 'high').length);
    this.tasksInBoard.set(tasks.length);
    this.tasksInProgress.set(tasks.filter(t => t.status === 'inProgress').length);
    this.awaitingFeedback.set(tasks.filter(t => t.status === 'awaitFeedback').length);
  }



  /**
   * Finds and sets the nearest upcoming deadline.
   *
   * @param tasks Array of tasks.
   */
  private findUpcomingDeadline(tasks: any[]) {
    const tasksWithDates = tasks
      .filter(t => t.due_at)
      .map(t => ({ ...t, dueDate: new Date(t.due_at!) }))
      .sort((a, b) => a.dueDate.getTime() - b.dueDate.getTime());

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const upcomingTask = tasksWithDates.find(t => t.dueDate >= today);
    if (upcomingTask) {
      this.upcomingDeadline.set(upcomingTask.due_at!);
    }
  }


  /**
   * Returns greeting based on current time of day.
   */
  get greeting(): string {
    const hour = new Date().getHours();
    const suffix = this.isGuestUser ? '!' : ',';
    if (hour < 12) return `Good morning${suffix}`;
    if (hour < 18) return `Good afternoon${suffix}`;
    return `Good evening${suffix}`;
  }


  /**
   * Check if current user is a guest.
   */
  get isGuestUser(): boolean {
    return this.supabase.isGuest();
  }
}
