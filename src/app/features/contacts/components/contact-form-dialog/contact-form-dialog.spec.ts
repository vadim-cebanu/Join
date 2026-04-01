import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ContactFormDialog } from './contact-form-dialog';
import { ContactsPage } from '../../pages/contacts-page/contacts-page';
import { signal } from '@angular/core';

describe('ContactFormDialog', () => {
  let component: ContactFormDialog;
  let fixture: ComponentFixture<ContactFormDialog>;
  let mockContactsPage: Partial<ContactsPage>;

  beforeEach(async () => {
    mockContactsPage = {
      showForm: signal(false),
      showDetailOnMobile: signal(false),
      showNotificationBriefly: jasmine.createSpy('showNotificationBriefly')
    };

    await TestBed.configureTestingModule({
      imports: [ContactFormDialog],
      providers: [
        { provide: ContactsPage, useValue: mockContactsPage }
      ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ContactFormDialog);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
