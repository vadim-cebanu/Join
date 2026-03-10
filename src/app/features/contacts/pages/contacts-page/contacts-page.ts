import { Component, signal } from '@angular/core';
import { ContactList } from '../../components/contact-list/contact-list';
import { ContactDetail } from '../../components/contact-detail/contact-detail';
import { ContactFormDialog } from '../../components/contact-form-dialog/contact-form-dialog';

/**
 * Main page component for the contacts feature.
 * Orchestrates the contact list, detail view, and form dialog.
 * Handles mobile-specific behavior like the detail slide-in.
 */
@Component({
  selector: 'app-contacts-page',
  imports: [ContactList, ContactDetail, ContactFormDialog],
  templateUrl: './contacts-page.html',
  styleUrl: './contacts-page.scss',
})
export class ContactsPage {

  showForm = signal(false);
  showDetailOnMobile = signal(false);

  /**
   * Toggles the toast notification visibility.
   * When enabled, automatically hides after 3 seconds.
   * @param onOff - Whether to show or hide the notification.
   */
  disappearSwitch(onOff: boolean) {
    this.showForm.set(onOff);

    if (onOff) {
      setTimeout(() => {
        this.showForm.set(false);
      }, 3000);
    }
  }


  /**
   * Listens for the 'contact-selected' custom event to show
   * the detail view on mobile devices (screen width <= 991px).
   */
  ngOnInit() {
    if (typeof window !== 'undefined') {
      window.addEventListener('contact-selected', () => {
        if (window.innerWidth <= 991) {
          this.showDetailOnMobile.set(true);
        }
      });
    }
  }


  /** Hides the mobile detail view by resetting the signal. */
  closeDetail() {
    this.showDetailOnMobile.set(false);
  }
}
