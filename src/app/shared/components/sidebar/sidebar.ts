import { Component, inject } from '@angular/core';
import { RouterLink, RouterLinkActive } from "@angular/router";
import { Supabase } from '../../../supabase';

/**
 * Sidebar navigation component displayed on the left side of the main layout.
 * Provides links to the main application sections (Summary, Board, Add Task, Contacts).
 */
@Component({
  selector: 'app-sidebar',
  imports: [RouterLink, RouterLinkActive],
  templateUrl: './sidebar.html',
  styleUrl: './sidebar.scss',
})
export class Sidebar {
  supabase = inject(Supabase);
}
