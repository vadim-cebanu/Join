import { ContactsPage } from './contacts-page';

describe('ContactsPage', () => {
  it('should create instance', () => {
    const component = new ContactsPage();
    expect(component).toBeTruthy();
  });

  it('should have showForm signal', () => {
    const component = new ContactsPage();
    expect(component.showForm()).toBe(false);
  });

  it('should have showDetailOnMobile signal', () => {
    const component = new ContactsPage();
    expect(component.showDetailOnMobile()).toBe(false);
  });

  it('should toggle showForm with showNotificationBriefly', (done) => {
    const component = new ContactsPage();
    component.showNotificationBriefly(true);
    expect(component.showForm()).toBe(true);

    setTimeout(() => {
      expect(component.showForm()).toBe(false);
      done();
    }, 3100);
  });
});
