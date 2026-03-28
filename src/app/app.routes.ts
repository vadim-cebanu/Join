import { Routes } from '@angular/router';
import { ContactsPage } from './features/contacts/pages/contacts-page/contacts-page';
import { LoginPage } from './features/auth/login-page/login-page';
import { SignupPage } from './features/auth/signup-page/signup-page';
import { AuthLayout } from './layouts/auth-layout/auth-layout';
import { AppLayout } from './layouts/app-layout/app-layout';
import { AddTaskPage } from './features/add-task/pages/add-task-page/add-task-page';
import { BoardPage } from './features/board/components/board-page/board-page';
import { SummaryPage } from './features/summary/pages/summary-page/summary-page';
import { GreetingPage } from './features/greeting/greeting-page/greeting-page';
import { authGuard } from './auth.guard';
import { PrivacyPolicyPage } from './features/privacy/privacy-policy-page/privacy-policy-page';
import { LegalNoticePage } from './features/legal/legal-notice-page/legal-notice-page';
import { HelpPage } from './features/help/help-page/help-page';
import { AccountPageComponent } from './features/account/pages/account-page/account-page';

/**
 * Application routing configuration split into two main areas:
 *
 * 1. AuthLayout - Public routes for authentication (login, signup).
 * 2. AppLayout  - Protected routes for the main application, guarded by authGuard.
 *
 * The root path redirects to /login, and unknown URLs fall back to /login.
 */
export const routes: Routes = [
  {
    path: '',
    component: AuthLayout,
    children: [
      { path: 'login', component: LoginPage },
      { path: 'signup', component: SignupPage },
      { path: '', pathMatch: 'full', redirectTo: 'login' },
    ],
  },
  {
    path: 'greeting',
    component: GreetingPage,
    canActivate: [authGuard],
  },
  {
    path: '',
    component: AppLayout,
    canActivate: [authGuard],
    children: [
      { path: 'contacts', component: ContactsPage },
      { path: 'summary', component: SummaryPage },
      { path: 'add-task', component: AddTaskPage },
      { path: 'board', component: BoardPage },
      { path: 'help', component: HelpPage },
      {path: 'account', component: AccountPageComponent}
    ],
  },
  {
    path: '',
    component: AppLayout,
    children: [
      { path: 'privacy', component: PrivacyPolicyPage },
      { path: 'legal', component: LegalNoticePage },
    ],
  },
  { path: '**', redirectTo: 'login' },
];
