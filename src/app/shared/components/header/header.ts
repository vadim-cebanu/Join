import { CommonModule } from '@angular/common';
import { Component, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { Supabase } from '../../../supabase';

/**
 * Application header component displayed at the top of the main layout.
 * Contains the logo, help button, user initials, and a dropdown menu
 * with navigation links and logout.
 */
@Component({
  selector: 'app-header',
  imports: [RouterLink, CommonModule],
  templateUrl: './header.html',
  styleUrl: './header.scss',
})
export class Header {
  supabase = inject(Supabase);
  isClosing = signal(false);

  /**
   * Returns the initials of the currently logged-in user.
   * Falls back to '?' if no user is available.
   * @returns Up to two uppercase initials derived from the display name or email.
   */
  getInitials(): string {
    const user = this.supabase.currentUser();
    if (!user) return 'G';
    const name = user.user_metadata?.['display_name'] || user.email || '';
    return name.split(' ').map((n: string) => n[0]).join('').toUpperCase().slice(0, 2) || 'G';
  }


  isMenuOpen = false;

  /** Toggles the header dropdown menu visibility. */
  toggleMenu() {
    if (this.isMenuOpen) {
      this.closeMenu();
    } else {
      this.isMenuOpen = true;
    }
  }


  /** Closes the header dropdown menu. */
  closeMenu() {
    if (window.innerWidth <= 1024) {
      this.isClosing.set(true);
      setTimeout(() => {
        this.isMenuOpen = false;
        this.isClosing.set(false);
      }, 400);
    } else {
      this.isMenuOpen = false;
    }
  }


  /** Logs out the current user and closes the menu. */
  async logout() {
    this.closeMenu();
    await this.supabase.signOut();
  }
}
