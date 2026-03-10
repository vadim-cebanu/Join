import { Component, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { Supabase } from '../../../supabase';

/**
 * Login page component that handles user authentication.
 * Supports email/password login and guest access.
 */
@Component({
  selector: 'app-login-page',
  imports: [FormsModule],
  templateUrl: './login-page.html',
  styleUrl: './login-page.scss',
})
export class LoginPage {
  supabase = inject(Supabase);
  router = inject(Router);
  isAlternateImage = false;
  isFocused = false;

  /** True when navigating from another page — skips the intro animation. */
  skipIntroAnimation = (history.state?.navigationId ?? 1) > 1;

  lockImage = 'assets/icons/lock.png';
  invisibleImage = 'assets/icons/visibility_off.svg';
  visibleImage = 'assets/icons/visibility.svg';


  /**
   * Handles focus event on password input.
   * Shows password visibility toggle icon.
   */
  onFocus(): void {
    this.isFocused = true;
  }


  /**
   * Handles blur event on password input.
   * Hides password visibility toggle and resets visibility state.
   */
  onBlur(): void {
    this.isFocused = false;
    this.isAlternateImage = false;
  }


  /**
   * Toggles password visibility between plain text and masked.
   */
  togglePasswordVisibility(): void {
    this.isAlternateImage = !this.isAlternateImage;
  }

  /** The user's email input. */
  email = signal('');

  /** The user's password input. */
  password = signal('');

  /** Whether to keep the user logged in after closing the browser. */
  rememberMe = signal(true);

  /** Clears the auth error when the user starts typing. */
  clearAuthError() {
    this.supabase.authError.set(null);
  }


  /**
   * Attempts to sign in the user with the provided email and password.
   * Navigates to the greeting page on success.
   */
  async login() {
    const success = await this.supabase.signIn(this.email(), this.password(), this.rememberMe());
    if (success) {
      this.router.navigate(['/greeting']);
    }
  }


  /** Logs the user in as a guest and navigates to the greeting page. */
  guestLogin() {
    this.supabase.guestLogin();
    this.router.navigate(['/greeting']);
  }
}
