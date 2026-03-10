import { Component, inject, signal, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Supabase } from '../../../supabase';
import { CommonModule } from '@angular/common';

/**
 * Greeting page component that displays a welcome message after login.
 * Automatically redirects to summary page after a short delay.
 */
@Component({
  selector: 'app-greeting-page',
  imports: [CommonModule],
  templateUrl: './greeting-page.html',
  styleUrl: './greeting-page.scss',
})
export class GreetingPage implements OnInit {
  supabase = inject(Supabase);
  router = inject(Router);

  userName = signal<string>('');

  async ngOnInit() {
    await this.loadUserName();

    // Redirect to summary after 3 seconds
    setTimeout(() => {
      this.router.navigate(['/summary']);
    }, 3000);
  }


  /**
   * Loads the current user's name from profiles table.
   */
  async loadUserName() {
    const { data: { user } } = await this.supabase.supabase.auth.getUser();
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
      .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
      .join(' ');
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
