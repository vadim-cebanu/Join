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
    const { data: { user } } = await this.supabase.supabase.auth.getUser();
    if (user) {
      // Try to get display_name from profiles table
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
      .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
      .join(' ');
  }

  /**
   * Loads and calculates task metrics from the database.
   */
  async loadTaskMetrics() {
    const { data: tasks, error } = await this.supabase.supabase
      .from('tasks')
      .select('*');

    if (error || !tasks) return;

    // Calculate metrics
    const todoTasks = tasks.filter((t: any) => t.status === 'todo');
    const doneTasks = tasks.filter((t: any) => t.status === 'done');
    const urgentTasks = tasks.filter((t: any) => t.priority === 'high');
    const inProgressTasks = tasks.filter((t: any) => t.status === 'inProgress');
    const awaitingTasks = tasks.filter((t: any) => t.status === 'awaitFeedback');

    this.toDoCount.set(todoTasks.length);
    this.doneCount.set(doneTasks.length);
    this.urgentCount.set(urgentTasks.length);
    this.tasksInBoard.set(tasks.length);
    this.tasksInProgress.set(inProgressTasks.length);
    this.awaitingFeedback.set(awaitingTasks.length);

    // Find upcoming deadline (nearest future date)
    const tasksWithDates = tasks
      .filter((t: any) => t.due_at)
      .map((t: any) => ({ ...t, dueDate: new Date(t.due_at!) }))
      .sort((a: any, b: any) => a.dueDate.getTime() - b.dueDate.getTime());

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const upcomingTask = tasksWithDates.find((t: any) => t.dueDate >= today);
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
