/**
 * Funktionen sind nach JSDoc Standard dokumentiert:
 *
 * This file defines the core task domain model used by the board application.
 * It includes:
 * - status/type/priority unions
 * - interfaces for assignees and subtasks
 * - the Task interface as the central entity
 */

/**
 * Represents the workflow status of a task on the board.
 *
 * - `todo`: Task is not started yet.
 * - `inProgress`: Task is currently being worked on.
 * - `awaitFeedback`: Task is awaiting review/feedback.
 * - `done`: Task is completed.
 */
export type Status = 'todo' | 'inProgress' | 'awaitFeedback' | 'done';

/**
 * Describes the category/type of work a task represents.
 *
 * - `User Story`: User-facing requirement or feature.
 * - `Technical Task`: Implementation/maintenance/technical work item.
 */
export type TaskType = 'User Story' | 'Technical Task';

/**
 * Indicates the priority level of a task.
 *
 * - `high`: Needs urgent attention.
 * - `medium`: Normal priority.
 * - `low`: Can be addressed later.
 */
export type TaskPriority = 'high' | 'medium' | 'low';

/**
 * Represents a person assigned to a task.
 */
export interface Assignee {
  id: string;
  initials: string;
  name?: string;
}

/**
 * Represents a single subtask belonging to a parent task.
 */
export interface Subtask {
  id: string;
  title: string;
  done: boolean;
}

/**
 * Represents an attachment file associated with a task.
 */
export interface TaskAttachment {
  id: string;
  name: string;
  base64: string;
  type: string;
}

/**
 * Central model representing a task in the application.
 *
 * Notes:
 * - `description`, `assignees`, `subtasks`, `attachments`, and `dueDate` are optional.
 * - `createdAt` should be stored as an ISO string.
 */
export interface Task {
  id: string;
  title: string;
  description?: string;
  status: Status;
  type: TaskType;
  priority: TaskPriority;
  assignees?: Assignee[];
  subtasks?: Subtask[];
  attachments?: TaskAttachment[];
  createdAt: string;
  dueDate?: string;
}
