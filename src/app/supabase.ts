import { Injectable, signal, computed } from '@angular/core';
import { createClient, SupabaseClient, User } from '@supabase/supabase-js';
import { Router } from '@angular/router';

/**
 * Data model for a contact entry.
 *
 * id      - Assigned by the database.
 * user_id - ID of the user who owns the contact.
 * name    - Full name of the contact (required).
 * email   - Email address (required).
 * phone   - Optional phone number.
 */
export interface Contact {
  id?: string;
  user_id?: string;
  name: string;
  email: string;
  phone?: string;
  avatar_url?: string;
}

/**
 * Central Supabase service that manages:
 * - Database connection and authentication
 * - Contact CRUD operations
 * - UI state via Angular Signals
 *
 * Provided in root so it is available as a singleton across the entire app.
 */
@Injectable({
  providedIn: 'root',
})
export class Supabase {

  /** Supabase project URL. */
 private supabaseUrl = 'https://rtunkmriznurqroovzij.supabase.co';

  /** Currently authenticated user. */
  currentUser = signal<User | null>(null);

  /** Whether the user is logged in as a guest. */
  isGuest = signal<boolean>(this.getGuestStatus());

  /** Get guest status from localStorage */
  private getGuestStatus(): boolean {
    if (typeof window !== 'undefined' && window.localStorage) {
      return localStorage.getItem('isGuest') === 'true';
    }
    return false;
  }

  /** Only real authenticated user */
isAuthenticated = computed(() => this.currentUser() !== null);

/** Real user OR guest */
hasAppAccess = computed(() => this.currentUser() !== null || this.isGuest());

  /** Set guest status and persist to localStorage */
  private setGuestStatus(value: boolean): void {
    this.isGuest.set(value);
    if (typeof window !== 'undefined' && window.localStorage) {
      if (value) {
        localStorage.setItem('isGuest', 'true');
      } else {
        localStorage.removeItem('isGuest');
      }
    }
  }

  /** Computed user profile derived from user metadata. */
  currentProfile = computed(() => {
    const user = this.currentUser();
    if (!user) return null;
    return {
      id: user.id,
      email: user.email,
      display_name: user.user_metadata?.['display_name'] || null
    };
  });

  /** Signal to trigger avatar reload across components */
  avatarReloadTrigger = signal<number>(0);

  /** Whether any user (authenticated or guest) is logged in. */
  isLoggedIn = computed(() => !!this.currentUser() || this.isGuest());

  /** Authentication error message, if any. */
  authError = signal<string | null>(null);

  /** Whether an authentication request is in progress. */
  authLoading = signal<boolean>(false);

  /** Public anon key for Supabase API access. */
  private supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0dW5rbXJpem51cnFyb292emlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEyMTI4MjAsImV4cCI6MjA4Njc4ODgyMH0.J4bDrpH72a81aHGBdHvT5Vrl30NgoZTOB8wvAHwmIoE';

  /** Initialized Supabase client instance. */
  supabase: SupabaseClient = createClient(
    this.supabaseUrl,
    this.supabaseKey
  );

  constructor(private router: Router) {
    this.initAuth();
  }


  /**
   * Initializes authentication by checking the current session
   * and subscribing to auth state changes.
   * If "Remember Me" was not checked, signs out existing sessions on page load.
   */
  private async initAuth() {
    const { data: { session } } = await this.supabase.auth.getSession();

    const shouldClearSession = await this.handleSessionPersistence(session);
    if (shouldClearSession) return;

    this.currentUser.set(session?.user ?? null);
    if (session?.user) {
      this.setGuestStatus(false);
    }

    this.setupAuthStateListener();
  }


  /**
   * Handles session persistence based on "Remember Me" preference.
   *
   * @param session Current session object.
   * @returns True if session was cleared, false otherwise.
   */
  private async handleSessionPersistence(session: any): Promise<boolean> {
    if (typeof window === 'undefined' || !window.sessionStorage) {
      return false;
    }

    const shouldNotPersist = sessionStorage.getItem('no-persist-session') === 'true';
    if (shouldNotPersist && session) {
      await this.supabase.auth.signOut({ scope: 'local' });
      sessionStorage.removeItem('no-persist-session');
      this.currentUser.set(null);
      return true;
    }

    return false;
  }


  /**
   * Sets up auth state change listener.
   */
  private setupAuthStateListener(): void {
    this.supabase.auth.onAuthStateChange((event, session) => {
      this.currentUser.set(session?.user ?? null);
      if (session?.user) {
        this.setGuestStatus(false);
      }
    });
  }


  /**
   * Signs in a user with email and password.
   * @param email - The user's email address.
   * @param password - The user's password.
   * @param rememberMe - Whether to persist the session after browser closes (default: true).
   * @returns True if sign-in was successful, false otherwise.
   */
  async signIn(email: string, password: string, rememberMe: boolean = true): Promise<boolean> {
    this.authLoading.set(true);
    this.authError.set(null);

    this.storeRememberMePreference(rememberMe);
    const success = await this.performSignIn(email, password);

    this.authLoading.set(false);
    return success;
  }


  /**
   * Stores the remember me preference in session storage.
   *
   * @param rememberMe Whether to remember the session.
   */
  private storeRememberMePreference(rememberMe: boolean): void {
    if (typeof window === 'undefined' || !window.sessionStorage) {
      return;
    }

    if (rememberMe) {
      sessionStorage.removeItem('no-persist-session');
    } else {
      sessionStorage.setItem('no-persist-session', 'true');
    }
  }


  /**
   * Performs the actual sign-in API call.
   *
   * @param email User's email.
   * @param password User's password.
   * @returns True if successful, false otherwise.
   */
  private async performSignIn(email: string, password: string): Promise<boolean> {
    const { data, error } = await this.supabase.auth.signInWithPassword({
      email,
      password
    });

    if (error) {
      this.authError.set('Your email or password is incorrect. Please try again.');
      return false;
    }

    this.currentUser.set(data.user);
    this.setGuestStatus(false);
    return true;
  }


  /**
   * Registers a new user with email, password, and optional display name.
   * @param email - The user's email address.
   * @param password - The user's chosen password.
   * @param displayName - Optional display name stored in user metadata.
   * @returns True if registration was successful, false otherwise.
   */
  async signUp(email: string, password: string, displayName?: string): Promise<boolean> {
    this.authLoading.set(true);
    this.authError.set(null);
    const { data, error } = await this.supabase.auth.signUp({
      email,
      password,
      options: {
        data: { display_name: displayName }
      }
    });
    this.authLoading.set(false);
    if (error) {
      this.authError.set(error.message);
      return false;
    }
    return true;
  }


  /** Signs out the current user and navigates to the login page. */
  async signOut() {
    await this.supabase.auth.signOut({ scope: 'local' });
    this.currentUser.set(null);
    this.setGuestStatus(false);
    this.router.navigate(['/login']);
  }


  /** Enables guest mode without requiring authentication. */
  guestLogin() {
    this.setGuestStatus(true);
  }

  /** List of all loaded contacts. */
  contacts = signal<Contact[]>([]);

  /** Currently selected contact in the UI. */
  selectedContact = signal<Contact | null>(null);

  /** Whether contact data is currently being loaded. */
  loading = signal<boolean>(false);

  /** Error message from the last failed operation. */
  error = signal<string | null>(null);

  /** Controls the visibility of the contact form dialog. */
  showForm = signal<boolean>(false);

  /** Whether the form is in edit mode (vs. create mode). */
  editMode = signal<boolean>(false);

  /**
   * Fetches all contacts from the database, sorted by name,
   * and stores them in the contacts signal.
   */
  async getContacts() {
    this.loading.set(true);

    const { data, error } = await this.supabase
      .from('contacts')
      .select('*')
      .order('name');

    this.loading.set(false);

    if (error) {
      console.error('Error fetching contacts:', error);
      this.error.set(error.message);
      return;
    }

    this.contacts.set(data || []);
  }


  /**
   * Inserts a new contact into the database and refreshes the contact list.
   * @param contact - The contact data to insert.
   * @returns The created contact with its ID.
   */
  async addContact(contact: Contact): Promise<Contact> {
    const { data, error } = await this.supabase
      .from('contacts')
      .insert([contact])
      .select()
      .single();

    if (error) throw error;

    await this.getContacts();
    return data;
  }


  /**
   * Updates an existing contact in the database and refreshes the contact list.
   * Also updates the selectedContact signal.
   * @param id - The ID of the contact to update.
   * @param contact - The fields to update.
   * @returns The updated contact.
   */
  async updateContact(id: string, contact: Partial<Contact>): Promise<Contact> {
    const { data, error } = await this.supabase
      .from('contacts')
      .update(contact)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    await this.getContacts();

    const updatedContact = this.contacts().find(c => c.id === id);
    if (updatedContact) {
      this.selectedContact.set(updatedContact);
    }

    return data;
  }


  /**
   * Deletes a contact by ID, clears the selection, and refreshes the contact list.
   * @param id - The ID of the contact to delete.
   */
  async deleteContact(id: string) {
    const { error } = await this.supabase
      .from('contacts')
      .delete()
      .eq('id', id);

    if (error) throw error;

    this.selectedContact.set(null);
    await this.getContacts();
  }


  async updateTaskStatus(taskId: string, status: string) {
    const { error } = await this.supabase
      .from('tasks')
      .update({ status })
      .eq('id', taskId);

    if (error) throw error;
  }

  /**
   * SUPABASE STORAGE METHODS (optional for future use with large files)
   * These methods provide an alternative to base64 encoding by using Supabase Storage.
   */

  /**
   * Uploads a file to Supabase Storage.
   *
   * @param bucket - The name of the storage bucket (e.g., 'task-attachments').
   * @param filePath - The path where the file will be stored in the bucket.
   * @param file - The File object to upload.
   * @returns The public URL of the uploaded file, or null if upload failed.
   */
  async uploadFile(bucket: string, filePath: string, file: File): Promise<string | null> {
    try {
      const { data, error } = await this.supabase.storage
        .from(bucket)
        .upload(filePath, file, {
          cacheControl: '3600',
          upsert: false
        });

      if (error) {
        console.error('Upload error:', error);
        return null;
      }

      const { data: urlData } = this.supabase.storage
        .from(bucket)
        .getPublicUrl(filePath);

      return urlData.publicUrl;
    } catch (error) {
      console.error('Upload failed:', error);
      return null;
    }
  }

  /**
   * Deletes a file from Supabase Storage.
   *
   * @param bucket - The name of the storage bucket.
   * @param filePath - The path of the file to delete.
   * @returns True if deletion was successful, false otherwise.
   */
  async deleteFile(bucket: string, filePath: string): Promise<boolean> {
    try {
      const { error } = await this.supabase.storage
        .from(bucket)
        .remove([filePath]);

      if (error) {
        console.error('Delete error:', error);
        return false;
      }

      return true;
    } catch (error) {
      console.error('Delete failed:', error);
      return false;
    }
  }

  /**
   * Gets the public URL for a file in Supabase Storage.
   *
   * @param bucket - The name of the storage bucket.
   * @param filePath - The path of the file.
   * @returns The public URL of the file.
   */
  getFileUrl(bucket: string, filePath: string): string {
    const { data } = this.supabase.storage
      .from(bucket)
      .getPublicUrl(filePath);

    return data.publicUrl;
  }
}
