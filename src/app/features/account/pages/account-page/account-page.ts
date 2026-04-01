import { Component, inject, signal, effect } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { Supabase } from '../../../../supabase';
import { Router } from '@angular/router';
import { compressImage } from '../../../../shared/utils/image-compression.utils';
import { avatarColors } from '../../../contacts/components/contact-list/contact-list';
import { noWhitespaceValidator } from '../../../../shared/validators/whitespace.validator';

@Component({
  selector: 'app-account-page',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './account-page.html',
  styleUrl: './account-page.scss'
})
export class AccountPageComponent {
  fb = inject(FormBuilder);
  supabase = inject(Supabase);
  router = inject(Router);

  isClosing = signal(false);
  saving = signal(false);
  editMode = signal(false);
  avatarUrl = signal<string | null>(null);

  accountForm = this.fb.group({
    name: ['', [Validators.required, noWhitespaceValidator, Validators.maxLength(30)]],
    email: ['', [Validators.required, noWhitespaceValidator, Validators.email, Validators.maxLength(30)]],
    phone: ['', [Validators.maxLength(20)]]
  });

  /** Effect to load user data when user changes - using field initializer for proper injection context */
  private userDataEffect = effect(() => {
    const user = this.supabase.currentUser();
    if (user) {
      this.loadUserData();
    }
  });

  constructor() {
    this.accountForm.disable();
  }

  get nameField() { return this.accountForm.get('name')!; }
  get emailField() { return this.accountForm.get('email')!; }
  get phoneField() { return this.accountForm.get('phone')!; }

  /**
   * Extracts the first two initials from a full name.
   */
  getInitials(name: string): string {
    if (!name) return '';
    return name
      .split(' ')
      .map((n) => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  }

  /**
   * Returns a consistent avatar color based on the user's name.
   */
  getAvatarColor(name: string): string {
    if (!name) return avatarColors[0];
    let hash = 0;
    for (let i = 0; i < name.length; i++) {
      hash = name.charCodeAt(i) + ((hash << 5) - hash);
    }
    const index = Math.abs(hash) % avatarColors.length;
    return avatarColors[index];
  }

  getErrorMessage(controlName: string): string {
    const control = this.accountForm.get(controlName);
    if (!control || !control.errors) return '';

    const errors = control.errors;
    if (errors['required']) return `${controlName.charAt(0).toUpperCase() + controlName.slice(1)} is required`;
    if (errors['whitespace']) return errors['whitespace'];
    if (errors['maxlength']) {
      const maxLength = errors['maxlength'].requiredLength;
      return `Maximum ${maxLength} characters allowed`;
    }
    if (errors['email']) return 'Please enter a valid email address';
    return '';
  }

  /**
   * Loads the current user's data from Supabase and populates the form.
   */
  async loadUserData() {
    const user = this.supabase.currentUser();
    if (!user) return;

    try {
      const { data: profile } = await this.supabase.supabase
        .from('profiles')
        .select('display_name, avatar_url')
        .eq('id', user.id)
        .single();

      if (profile?.avatar_url) {
        this.avatarUrl.set(profile.avatar_url);
      }

      this.accountForm.patchValue({
        name: profile?.display_name || user.user_metadata?.['display_name'] || '',
        email: user.email || '',
        phone: ''
      });
    } catch (err) {
      console.error('Error loading user data:', err);
      this.accountForm.patchValue({
        name: user.user_metadata?.['display_name'] || '',
        email: user.email || '',
        phone: ''
      });
    }
  }

  closeForm() {
    this.isClosing.set(true);
    setTimeout(() => {
      this.isClosing.set(false);
      this.router.navigate(['/summary']);
    }, 400);
  }

  toggleEditMode() {
    const newEditMode = !this.editMode();
    this.editMode.set(newEditMode);

    if (newEditMode) {
      this.accountForm.enable();
      this.emailField.disable();
    } else {
      this.accountForm.disable();
      this.loadUserData();
    }
  }

  async onAvatarClick() {
    if (!this.editMode()) return;

    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/*';
    input.onchange = async (e: any) => {
      const file = e.target.files[0];
      if (file) {
        await this.uploadAvatar(file);
      }
    };
    input.click();
  }

  async uploadAvatar(file: File) {
    try {
      const compressedBase64 = await compressImage(file, 400, 400, 0.8);
      this.avatarUrl.set(compressedBase64);
    } catch (err) {
      console.error('Error compressing image:', err);
    }
  }

  async deleteAccount() {
    if (!confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
      return;
    }

    const user = this.supabase.currentUser();
    if (!user) return;

    try {
      await this.supabase.supabase
        .from('profiles')
        .delete()
        .eq('id', user.id);

      await this.supabase.supabase
        .from('contacts')
        .delete()
        .eq('user_id', user.id);

      await this.supabase.signOut();
    } catch (err) {
      console.error('Error deleting account:', err);
    }
  }

  async saveAccount() {
    this.markAllFieldsAsTouched();
    if (!this.accountForm.valid) return;

    const user = this.supabase.currentUser();
    if (!user) return;

    this.saving.set(true);
    try {
      const formValue = this.accountForm.value;
      const avatarToSave = this.avatarUrl();

      const { error: metadataError } = await this.supabase.supabase.auth.updateUser({
        data: { display_name: formValue.name }
      });

      if (metadataError) throw metadataError;

      const profileData = {
        display_name: formValue.name,
        avatar_url: avatarToSave
      };

      const { error: profileError } = await this.supabase.supabase
        .from('profiles')
        .update(profileData)
        .eq('id', user.id);

      if (profileError) throw profileError;

      // Trigger avatar reload in header
      this.supabase.avatarReloadTrigger.set(Date.now());

      // Close the modal after save
      this.closeForm();
    } catch (err: any) {
      console.error('Error saving account:', err);
    } finally {
      this.saving.set(false);
    }
  }

  private markAllFieldsAsTouched() {
    Object.keys(this.accountForm.controls).forEach(key => {
      this.accountForm.get(key)?.markAsTouched();
    });
  }
}
