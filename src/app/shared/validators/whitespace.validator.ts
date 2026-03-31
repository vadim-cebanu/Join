import { AbstractControl, ValidationErrors } from '@angular/forms';

/**
 * Validator that prevents inputs containing only whitespace characters.
 * Returns an error if the trimmed value is empty but the original value is not.
 *
 * @param control - The form control to validate
 * @returns ValidationErrors if value is only whitespace, null otherwise
 *
 * @example
 * new FormControl('', [Validators.required, noWhitespaceValidator])
 */
export function noWhitespaceValidator(control: AbstractControl): ValidationErrors | null {
  const value = control.value;

  // If there's no value, let 'required' validator handle it
  if (!value) {
    return null;
  }

  // Check if value is only whitespace
  const trimmedValue = value.toString().trim();
  if (trimmedValue.length === 0) {
    return { whitespace: 'This field cannot contain only spaces' };
  }

  return null;
}
