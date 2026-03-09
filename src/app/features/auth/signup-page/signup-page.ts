import { Component, inject, signal } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { Supabase } from '../../../supabase';
import { CommonModule } from '@angular/common';

/**
 * Signup page component that handles new user registration.
 * Validates password confirmation before creating the account.
 */
@Component({
  selector: 'app-signup-page',
  imports: [RouterLink, FormsModule, CommonModule],
  templateUrl: './signup-page.html',
  styleUrl: './signup-page.scss',
})
export class SignupPage {
  supabase = inject(Supabase);
  router = inject(Router);

  /** The user's chosen display name. */
  displayName = signal('');

  /** The user's email address. */
  email = signal('');

  /** The user's chosen password. */
  password = signal('');

  /** Password confirmation for validation. */
  confirmPassword = signal('');

  /** Success message displayed after successful registration. */
  successMessage = signal('');

  /** Whether the privacy policy has been accepted. */
  privacyAccepted = signal(false);

  /** Whether the privacy policy modal is open. */
  showPrivacyModal = signal(false);

  /** Whether the user has read the entire privacy policy. */
  hasReadPrivacy = signal(false);

  isAlternateImage = false;
  isFocused = false;

  lockImage = 'assets/icons/lock.png';
  invisibleImage = 'assets/icons/visibility_off.svg';
  visibleImage = 'assets/icons/visibility.svg';

  onFocus(): void{
    this.isFocused = true;
  }

  onBlur(): void {
    this.isFocused = false;
    this.isAlternateImage = false;
  }

  togglePasswordVisibility(): void {
    this.isAlternateImage = !this.isAlternateImage;
  }

  /**
   * Opens the privacy policy modal.
   */
  openPrivacyModal() {
    this.showPrivacyModal.set(true);
  }

  /**
   * Closes the privacy policy modal.
   */
  closePrivacyModal() {
    this.showPrivacyModal.set(false);
  }

  /**
   * Handles scroll event on privacy policy content to detect if user has read to the end.
   */
  onPrivacyScroll(event: Event) {
    const element = event.target as HTMLElement;
    const scrollTop = element.scrollTop;
    const scrollHeight = element.scrollHeight;
    const clientHeight = element.clientHeight;

    // Check if scrolled to bottom (with 10px tolerance)
    if (scrollTop + clientHeight >= scrollHeight - 10) {
      this.hasReadPrivacy.set(true);
    }
  }

  /**
   * Validates the password confirmation and registers a new user.
   * Sets a success message on completion prompting email verification.
   */
  async signup() {
    if (this.password() !== this.confirmPassword()) {
      this.supabase.authError.set('Passwords do not match');
      return;
    }

    if (!this.privacyAccepted()) {
      this.supabase.authError.set('You must accept the Privacy Policy');
      return;
    }

    const success = await this.supabase.signUp(
      this.email(),
      this.password(),
      this.displayName()
    );

    if (success) {
      this.successMessage.set('You Signed Up successfully');

       setTimeout(() => {
         this.router.navigate(['/login'])}, 800);

    }
  }

  goBack() {
    window.history.back();
  }
}
