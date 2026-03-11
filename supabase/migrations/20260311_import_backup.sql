-- Migration: Import backup data
-- Created: 2026-03-11

-- =====================================================
-- 1. Create ENUM Types
-- =====================================================

CREATE TYPE IF NOT EXISTS public.task_priority AS ENUM (
    'low',
    'medium',
    'high'
);

CREATE TYPE IF NOT EXISTS public.task_status AS ENUM (
    'todo',
    'inProgress',
    'awaitFeedback',
    'done'
);

-- =====================================================
-- 2. Create Tables
-- =====================================================

-- Contacts Table
CREATE TABLE IF NOT EXISTS public.contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid DEFAULT auth.uid(),
    name text,
    email text,
    phone text,
    created_at timestamp with time zone DEFAULT now(),
    PRIMARY KEY (id)
);

-- Profiles Table
CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid NOT NULL,
    email text,
    display_name text,
    created_at timestamp with time zone DEFAULT now(),
    PRIMARY KEY (id)
);

-- Projects Table
CREATE TABLE IF NOT EXISTS public.projects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    owner_id uuid,
    is_guest_project boolean DEFAULT false,
    guest_token text,
    created_at timestamp with time zone DEFAULT now(),
    PRIMARY KEY (id)
);

-- Project Members Table
CREATE TABLE IF NOT EXISTS public.project_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    user_id uuid,
    role text DEFAULT 'member'::text,
    created_at timestamp with time zone DEFAULT now(),
    PRIMARY KEY (id),
    FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE
);

-- Task Comments Table
CREATE TABLE IF NOT EXISTS public.task_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid,
    author_id uuid,
    guest_token text,
    body text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    PRIMARY KEY (id)
);

-- Tasks Table
CREATE TABLE IF NOT EXISTS public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    title text NOT NULL,
    description text,
    status public.task_status DEFAULT 'todo'::public.task_status,
    priority public.task_priority DEFAULT 'medium'::public.task_priority,
    created_by uuid DEFAULT auth.uid(),
    guest_token text,
    due_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    assignees jsonb DEFAULT '[]'::jsonb,
    subtasks jsonb,
    type text DEFAULT 'Technical Task'::text,
    "position" integer DEFAULT 0,
    PRIMARY KEY (id),
    FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE,
    CONSTRAINT tasks_type_check CHECK ((type = ANY (ARRAY['User Story'::text, 'Technical Task'::text])))
);

-- Add foreign key for task_comments after tasks table is created
ALTER TABLE public.task_comments
ADD CONSTRAINT task_comments_task_id_fkey
FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;

-- =====================================================
-- 3. Insert Data
-- =====================================================

-- Insert Contacts
INSERT INTO public.contacts (id, user_id, name, email, phone, created_at) VALUES
('b093bfb7-d409-4a84-8aa1-cd174a9866ca', 'd071f9b2-ce73-44a2-b015-2a2d8efe1503', 'Benjamin Blarr', 'b.blarr@gmx.de', '34567889', '2026-02-25 08:28:24.948851+00'),
('f1095bee-d4ab-438c-9d52-39665e8f9c88', '05e11232-a2be-4a94-aa31-fe8bbdfa9b23', 'Mark Müller', 'Mark@gmail.com', '+39586922294', '2026-02-19 07:54:27.30656+00'),
('20d9a60d-208a-4f4d-a9f2-7760b13c81af', NULL, 'Ulf Kirsten', 'ulf.kirsten@gmx.com', '02179744032', '2026-02-17 11:12:02.283942+00'),
('91c2abdf-ced0-42f1-9694-7aca31860993', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', 'Vadim Cebanu', 'vadykdeeja@gmail.com', '015175984788', '2026-02-18 14:45:16.165225+00'),
('77021d33-03ae-4e55-ac46-f068b5594db9', 'd071f9b2-ce73-44a2-b015-2a2d8efe1503', 'Anni Berge', 'anni.berger@web.de', '04329801', '2026-02-20 14:12:58.862072+00'),
('816ac477-bb70-4425-a7ea-a814394e618c', NULL, 'Peter Meyer', 'peterm@t-online.de', '017835553343', '2026-03-05 10:51:05.86235+00'),
('0450c92a-b258-404f-965a-7136a9ebaea9', NULL, 'Serhat Özcakir', 'serhat35@gmail.com', '+44909210192', '2026-02-17 11:12:02.283942+00')
ON CONFLICT (id) DO NOTHING;

-- Insert Profiles
INSERT INTO public.profiles (id, email, display_name, created_at) VALUES
('2bb9bfb9-e2ac-41e9-9c2f-fbfa2c928de5', 'uasea@mail.de', 'vadim cebanu', '2026-02-17 11:00:46.384789+00'),
('9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', 'vadykdeejay@gmail.com', 'vadim cebanu', '2026-02-17 11:02:29.141394+00'),
('312fbd38-46b4-4611-bf01-ea5b58854967', 'vadykdeejay@mail.com', 'vadim cebanu', '2026-02-17 14:25:19.764851+00'),
('849e4383-8caf-420f-a13d-4e3393ee4645', 'klaus@tester.de', 'klaus', '2026-03-05 10:10:37.968335+00'),
('3a846c33-7c2d-4ec2-9fe5-ff4eaa092dcc', 'vadim@mail.de', 'vadim cebanu', '2026-03-05 19:05:52.781829+00'),
('21f90788-2d49-4547-b867-d52455e0d56b', 'vadim@mail.dee', 'vadim cebanu', '2026-03-05 19:09:07.482836+00'),
('8642c8b5-f0b9-4811-8f7a-425155de9d1d', 'vadim@gmail.de', 'vadim cebanu', '2026-03-05 19:12:42.324389+00'),
('3f062642-a3ec-45c2-be36-4b05fe0b5235', 'vadim34@mail.de', 'vadim cebanu', '2026-03-05 19:13:18.451549+00'),
('05e11232-a2be-4a94-aa31-fe8bbdfa9b23', 'serhatozcakir35@gmail.com', 'serhat ozcakir', '2026-02-17 13:17:05.275437+00'),
('306b5d39-a4ee-4848-a64a-01ad4ffa241d', 'giuliano@da.de', 'giuliano gioia', '2026-02-17 13:17:05.275437+00'),
('da0ff70f-fb32-418b-b84f-f66d7fcf6685', 'vadykdeejay@gmail.comwer', 'vadim cebanu', '2026-03-06 16:03:28.182782+00'),
('b6ccc057-3ea9-4e5f-89b0-d28e37acb208', 'vadykdeejay@gmail.comqweq', 'vadim cebanu', '2026-03-06 16:05:08.973302+00'),
('d071f9b2-ce73-44a2-b015-2a2d8efe1503', 'b.blarr@gmx.de', 'Benjamin Blarr', '2026-02-17 13:17:05.275437+00'),
('924c7e03-fc42-479c-b841-c7eaa607cdc6', 'zar.gr@web.de', 'Gregor Zar', '2026-03-09 08:09:54.051665+00'),
('993dc109-8d6c-4369-8011-8b39b0059830', 'vadyk@mail.com', 'vadim cebanu', '2026-03-09 09:01:18.116453+00'),
('092175d3-fa6b-4b6d-9a62-67a547151b5c', 'uaseea@mgail.de', 'uasea', '2026-03-09 10:23:51.611032+00'),
('73ebb754-d8b0-46d2-bea9-846fa82d3657', 'alladin@mail.de', 'alladin', '2026-03-09 10:25:40.932285+00'),
('b0187f61-fe65-436d-a9f8-dc1a2b4d307e', 'mario@mail.de', 'mario', '2026-03-09 10:27:30.537541+00'),
('1c0f7c19-3851-4429-91c9-6b8d67d4e7b7', 'marrio@mgail.de', 'marrio', '2026-03-09 10:32:02.807485+00'),
('bcefc261-a2e7-4936-80c7-ff01bf33cb38', 'aladinnn@mail.de', 'alladin', '2026-03-09 10:34:50.922555+00'),
('217a05cc-7709-4e39-a0cf-ede8b02d87a4', '12@1.de', 'A', '2026-03-09 13:48:09.267248+00'),
('0934afbd-f66b-4497-b251-4dbab6283576', 'klaus@tester2.de', 'KlausDerZweite', '2026-03-10 15:02:52.277249+00'),
('fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf', 'klausderzwoelfte@web.de', 'klausder zwölfte', '2026-03-10 15:21:08.276958+00'),
('ff94c710-a33a-498c-a6a6-6ce84f1977fc', 'mario@web.de', 'mario', '2026-03-10 15:45:09.430782+00'),
('c14fea5b-d484-4c2f-b022-c5ed8a34a2c1', 'alladin@web.de', 'alladin', '2026-03-10 15:59:29.592942+00'),
('9647ef90-fd59-4dde-8a76-26668af98700', 'alladdin@web.de', 'alladin', '2026-03-10 16:00:11.013018+00'),
('750436b2-3280-4fc1-88a6-92cdee4b774c', 'hannikohl@web.de', 'Hannelore Kohl', '2026-03-11 08:14:58.95152+00'),
('abc33f51-f7fe-45aa-ba58-71be49d0cf4f', 'klausi@web.de', 'klausi', '2026-03-11 09:27:36.50126+00')
ON CONFLICT (id) DO NOTHING;

-- Insert Tasks (contains all task data from backup)
INSERT INTO public.tasks (id, project_id, title, description, status, priority, created_by, guest_token, due_at, created_at, updated_at, assignees, subtasks, type, "position") VALUES
('c9abc566-f6ea-441b-be84-2643c3590d92', NULL, 'sign up succes message ', '', 'inProgress', 'high', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-12 00:00:00+00', '2026-03-06 17:59:41.324496+00', '2026-03-06 17:59:41.324496+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[]', 'User Story', 0),
('e351ea1f-39d1-4e0f-967c-1daa718a31d0', NULL, 'Authentication Service:', 'Zentraler Service für Login, Logout und Gast-Zugang.', 'done', 'high', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-12 00:00:00+00', '2026-03-05 18:23:42.706825+00', '2026-03-05 18:23:42.706825+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[{"id": "c03ba5ea-4bf4-4ca3-b7fa-9a6333261c91", "done": true, "title": "Der eigene Account ist in der \"Contacts\"-Liste sichtbar."}, {"id": "068e573e-10a1-4ed2-ba93-80dfb21eb4f9", "done": true, "title": "Der eigene Kontakt kann wie jeder andere Kontakt bearbeitet werden."}]', 'Technical Task', 0),
('1da55de8-2fab-44ee-8d5f-9872ab83afdb', NULL, 'User Story -4', '', 'todo', 'medium', NULL, NULL, '2026-03-12 00:00:00+00', '2026-03-06 11:23:19.694141+00', '2026-03-06 11:23:19.694141+00', '[]', '[]', 'User Story', 0),
('48308fa9-4e95-4867-b499-3c75c8664ca9', NULL, 'Greeting Message', 'when login , a greeting page must be created like in figma', 'done', 'high', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-12 00:00:00+00', '2026-03-06 17:59:01.367292+00', '2026-03-06 17:59:01.367292+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[]', 'User Story', 0),
('a2ee77cf-3806-4ed8-8fe8-2f0c975fd3d6', NULL, 'Namentliche Begrüßung nicht Email', '', 'done', 'medium', 'd071f9b2-ce73-44a2-b015-2a2d8efe1503', NULL, '2026-03-12 00:00:00+00', '2026-03-06 13:35:37.82648+00', '2026-03-06 13:35:37.82648+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[]', 'Technical Task', 0),
('7f5f9f32-3a9e-4511-8fc3-920cb33d5c03', NULL, 'remember option create', NULL, 'done', 'medium', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-12 00:00:00+00', '2026-03-09 10:04:03.577582+00', '2026-03-09 10:04:03.577582+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[]', 'Technical Task', 0),
('46d9433e-68d8-436b-97ab-252bbc4ceec6', NULL, 'Guest Login:', 'Ein spezieller Account, der vordefinierte Daten lädt, aber die gleichen Komponenten wie ein normaler User nutzt.', 'done', 'medium', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-07 00:00:00+00', '2026-03-05 18:24:11.643866+00', '2026-03-05 18:24:11.643866+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[{"id": "5c0e367f-b9de-4102-893f-4591a9519142", "done": true, "title": "\"Logout\"-Option ist in der Benutzeroberfläche leicht findbar."}, {"id": "d14471fd-1efc-4784-9eec-e4f67d9a6c37", "done": true, "title": "Sicherer Logout und automatische Weiterleitung zum Login-Bildschirm."}, {"id": "164a208a-ad9f-4003-a551-4049681ef804", "done": true, "title": "Persönliche Daten sind ohne erneutes Login nicht mehr zugänglich."}, {"id": "27f622f1-481f-4bcb-a103-8c3e51cf9a56", "done": true, "title": "After signup automatic linked to login"}]', 'Technical Task', 0),
('1d638547-0acb-41cc-8d0a-470667efd5e5', NULL, 'Hilfe (Help)', '', 'done', 'low', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-07 00:00:00+00', '2026-03-05 18:40:55.198262+00', '2026-03-05 18:40:55.198262+00', '[{"id": "0450c92a-b258-404f-965a-7136a9ebaea9", "name": "Serhat Özcakir", "initials": "SÖ"}]', '[{"id": "748ae378-815b-4f82-98f5-3244735cc2f5", "done": true, "title": "Hilfe-Button im Header neben dem User-Icon."}, {"id": "fdb78aca-fdd8-4601-bda3-fe274ad72e41", "done": true, "title": "Informationsseite zur Funktionsweise des Kanban-Boards."}, {"id": "f7529992-4310-40c8-8403-0e5d79a8e8c3", "done": true, "title": "Zurück-Button, der zur letzten besuchten Seite führt."}]', 'Technical Task', 0),
('3a3fe371-94f4-4a2c-99c1-2b6d755990ab', NULL, 'Sidebar umbauen für nicht eingeloggte User', '', 'done', 'medium', NULL, NULL, '2026-03-12 00:00:00+00', '2026-03-06 06:25:46.382685+00', '2026-03-06 06:25:46.382685+00', '[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]', '[{"id": "80076ab8-927f-4bb3-a273-596f68d9d369", "done": true, "title": "if else Einbauen zur Unterscheidung der Bereiche"}, {"id": "263f0496-004d-44c2-9f27-065aa67b8dca", "done": true, "title": "HTML bauen"}, {"id": "f4841278-935e-4034-a973-d2089f491cbf", "done": true, "title": "Styling für Desktop"}, {"id": "f42cd983-7412-4e18-83c7-806749131b29", "done": true, "title": "Styling für Mobile"}, {"id": "1aafc69c-38da-4859-a52e-1ad4d1396878", "done": true, "title": "Responsiveness"}, {"id": "6be68aa8-09fa-424e-8d3b-63a5b1f973af", "done": true, "title": "Korrekte Verlinkung/Routing"}]', 'User Story', 0),
('9c8631d0-dcde-42f1-9a07-afeacb82d8d5', NULL, 'Responsiveness', '', 'done', 'medium', 'd071f9b2-ce73-44a2-b015-2a2d8efe1503', NULL, '2026-03-10 00:00:00+00', '2026-03-07 08:45:43.883466+00', '2026-03-07 08:45:43.883466+00', '[{"id": "0450c92a-b258-404f-965a-7136a9ebaea9", "name": "Serhat Özcakir", "initials": "SÖ"}]', '[{"id": "e0e0c58f-1088-4047-b869-4c3e65b3e741", "done": false, "title": "Login Page"}, {"id": "45aaf90d-fef7-4395-bdb3-f544eadfdd1d", "done": false, "title": "Submit Page"}, {"id": "da3ae339-5fb2-428f-a292-b4dcd55fbcaf", "done": false, "title": "Summary Page"}]', 'Technical Task', 0),
('e1195a7b-b07a-4c8f-9b8d-277bd41fbc05', NULL, 'User Story - 5', '', 'done', 'medium', NULL, NULL, '2026-03-12 00:00:00+00', '2026-03-06 11:24:22.581439+00', '2026-03-06 11:24:22.581439+00', '[]', '[]', 'User Story', 0),
('e87a7ec1-472e-4695-9220-0cd78bdc2335', NULL, 'Header für nicht eingeloggte User bearbeiten', 'Buttons oben rechts dürfen nicht angezeigt werden', 'awaitFeedback', 'medium', 'd071f9b2-ce73-44a2-b015-2a2d8efe1503', NULL, '2026-03-12 00:00:00+00', '2026-03-06 14:22:00.235559+00', '2026-03-06 14:22:00.235559+00', '[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]', '[]', 'User Story', 0),
('a711ee34-09db-4d9b-800a-902114db6b46', NULL, 'Mobile screen logo', '', 'awaitFeedback', 'medium', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-12 00:00:00+00', '2026-03-09 10:23:11.013608+00', '2026-03-09 10:23:11.013608+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[]', 'User Story', 0),
('a029f9ab-1a52-4c40-bca4-0c83f05e2659', NULL, 'Impressum / Datenschutzerklärung', '', 'awaitFeedback', 'medium', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-07 00:00:00+00', '2026-03-05 18:39:13.056237+00', '2026-03-05 18:39:13.056237+00', '[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]', '[{"id": "d30ca03b-7476-4851-92e5-1d27690b8ebc", "done": true, "title": "Bereich für Privacy Policy (Datenschutz) vorhanden (nutze einen Generator)."}, {"id": "c978426d-f3aa-43e8-97cb-e765c6ecfa84", "done": true, "title": "Sicherheit: Unangemeldete User sehen auf diesen Seiten keine Sidebar-Links zum Board."}, {"id": "e69818d4-0b3e-4f96-aee9-5470ac269d78", "done": true, "title": "Links auf der Login-Seite klickbar machen"}, {"id": "40dc73af-98cb-47f4-b925-8d2a6419553e", "done": true, "title": "Impressum schreiben"}, {"id": "1121dd2b-14ae-41d2-8ed3-951951dc725d", "done": true, "title": "Impressum stylen"}, {"id": "b51baff1-595d-4c3e-abd9-f72e520c5aa5", "done": true, "title": "Datenschutz schreiben"}, {"id": "f6ae8214-2a34-4a78-a873-365277e2a97e", "done": true, "title": "Datenschutz stylen"}]', 'Technical Task', 0),
('c9a985df-c351-4a80-aabe-da8cc9117b42', NULL, 'Reactive Forms oder Template-driven Forms', 'Nutze Angular Forms für die Registrierung/Login (inkl. Custom Validators für E-Mail & Passwort).', 'awaitFeedback', 'high', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-07 00:00:00+00', '2026-03-05 18:21:50.150919+00', '2026-03-05 18:21:50.150919+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[{"id": "000a948b-e485-44bb-a050-15761ae49e48", "done": true, "title": "Registrierungsformular mit Feldern für: Name, E-Mail und Passwort."}, {"id": "2dc8b0b2-c740-462d-a238-fd47aaa90190", "done": true, "title": "Die Datenschutzerklärung muss vor Abschluss akzeptiert werden (Checkbox)."}, {"id": "6c090db6-0d12-43f1-90a2-fee72a6a8e40", "done": true, "title": "Fehlermeldungen bei ungültigen Eingaben (z. B. falsches E-Mail-Format)."}, {"id": "f13af8cf-35bd-4672-a72f-6ccd378a4d26", "done": true, "title": "Der \"Registrieren\"-Button ist deaktiviert, bis alle Pflichtfelder ausgefüllt sind."}]', 'Technical Task', 0),
('119cb481-a392-4081-a6df-fbf30d7fc50a', NULL, 'Passwort beim Login sichtbar/unsichtbar machen können', 'Im Figma sieht man das man das switchen kann zwischen sichtbar und verschlüsselt wenn man auf das Symbol rechts im Input klickt', 'done', 'medium', NULL, NULL, '2026-03-10 00:00:00+00', '2026-03-06 14:50:23.339004+00', '2026-03-06 14:50:23.339004+00', '[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]', '[{"id": "4411526e-0045-49dd-a9a9-15ad2d9d4762", "done": true, "title": "Icons wechseln beim Klick"}, {"id": "a7f3e0b9-b224-4cf3-bb30-d47777a8f5f4", "done": true, "title": "Schrift sichtbar/unsichtbar machen beim Klick"}]', 'User Story', 0),
('28463534-8d1f-4c23-8b4a-32ad56f5edd7', NULL, 'Priorities in Taskvorschau müssen immer angezeigt werden', 'Beim erstellen eines Tasks werden die Priorities nicht angezeigt wenn kein assignee hinzugefügt wurde', 'done', 'high', 'd071f9b2-ce73-44a2-b015-2a2d8efe1503', NULL, '2026-03-10 00:00:00+00', '2026-03-07 08:47:12.51839+00', '2026-03-07 08:47:12.51839+00', '[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]', '[]', 'Technical Task', 0),
('2d49d346-d61a-4340-b675-cefb3b56f3bb', NULL, 'after sign up do not  automatic login', NULL, 'awaitFeedback', 'medium', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-11 00:00:00+00', '2026-03-10 15:44:19.211339+00', '2026-03-10 15:44:19.211339+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[]', 'Technical Task', 0),
('11426196-6034-41d9-b184-995f25ef8079', NULL, 'Due date Anzeige', 'Due date wird nicht bei allen Tasks angezeigt', 'done', 'high', 'd071f9b2-ce73-44a2-b015-2a2d8efe1503', NULL, '2026-03-07 00:00:00+00', '2026-03-07 08:48:07.647708+00', '2026-03-07 08:48:07.647708+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[{"id": "65e4b511-57f3-446f-9eab-6125000e2e10", "done": true, "title": "check"}]', 'Technical Task', 0),
('e6368b55-2998-4973-aeaf-8da019564b18', NULL, 'animation starting page', NULL, 'awaitFeedback', 'medium', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-12 00:00:00+00', '2026-03-09 15:31:57.534107+00', '2026-03-09 15:31:57.534107+00', '[]', '[]', 'Technical Task', 0),
('dff03a52-5f6a-4f78-b04e-bcdf9ecd6389', NULL, 'User story 2', 'Schütze Routen wie /board oder /summary vor unbefugtem Zugriff (Redirect zum Login).', 'awaitFeedback', 'high', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-07 00:00:00+00', '2026-03-05 18:23:12.598046+00', '2026-03-05 18:23:12.598046+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[{"id": "43741e79-4541-4558-9931-489bc0a0ff16", "done": true, "title": "Login-Formular mit Feldern für E-Mail und Passwort."}, {"id": "82d6e694-d5d2-4cc9-870e-140d6b7104f6", "done": true, "title": "Fehlermeldung bei falscher Kombination (E-Mail/Passwort)."}, {"id": "aa28b193-ab12-48ed-8996-9af6820a7f32", "done": true, "title": "Gast-Login Option vorhanden."}, {"id": "f08a0634-0a76-4f8c-b092-000dbe534e52", "done": true, "title": "Wichtig: Registrierte User und Gäste sehen die gleichen Daten im Board und in den Kontakten."}, {"id": "95e91c5b-09c2-4d61-bff0-8be5f64d8c83", "done": true, "title": "Zugriffsschutz: Nicht angemeldete Besucher werden von geschützten Seiten (Summary, Board, Task, etc.) zur Login-Seite umgeleitet."}]', 'Technical Task', 0),
('02951a63-a1c5-4eba-804a-60d99b7f0946', NULL, 'Sign Up Page anpassen', 'Viele Styles müssen angepasst werden', 'done', 'medium', NULL, NULL, '2026-03-12 00:00:00+00', '2026-03-06 14:55:05.489325+00', '2026-03-06 14:55:05.489325+00', '[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]', '[{"id": "8c8ec3da-d21e-4af4-b25f-9a6eaea633ea", "done": true, "title": "Zurück Button implementieren"}, {"id": "27a4578a-49b4-49a7-9e30-0b1e41c3034f", "done": true, "title": "Styles anpassen"}]', 'User Story', 0),
('fcd406de-3ae7-43df-aec0-fc400f665297', NULL, 'Checkliste: Max 400 LOCs (Lines of Code) pro Datei', '', 'inProgress', 'high', NULL, NULL, '2026-03-10 00:00:00+00', '2026-03-10 06:50:25.692697+00', '2026-03-10 06:50:25.692697+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[]', 'Technical Task', 0),
('f72dfc28-07ee-48ff-a169-369344ef994a', NULL, 'Summary page scroll Problem', '', 'done', 'medium', NULL, NULL, '2026-03-12 00:00:00+00', '2026-03-06 11:48:15.953136+00', '2026-03-06 11:48:15.953136+00', '[{"id": "0450c92a-b258-404f-965a-7136a9ebaea9", "name": "Serhat Özcakir", "initials": "SÖ"}]', '[]', 'User Story', 0),
('7522a31e-0f04-4697-a820-2189d474fc78', NULL, 'Dashboard (Summary)', '/**\n * Ermittelt die Begrüßung basierend auf der aktuellen Uhrzeit.\n * @returns {string} Die passende Begrüßungsformel.\n */\ngetGreeting(): string {\n  const hour = new Date().getHours();\n  if (hour < 12) return ''Good morning'';\n  if (hour < 18) return ''Good afternoon'';\n  return ''Good evening'';\n}', 'awaitFeedback', 'medium', '9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1', NULL, '2026-03-12 00:00:00+00', '2026-03-05 18:37:51.821729+00', '2026-03-05 18:37:51.821729+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[{"id": "3a751c26-3c55-496f-b919-4a0b71be44d1", "done": true, "title": "Anzeige der Task-Anzahl pro Status (To Do, In Progress, Awaiting Feedback, Done)."}, {"id": "4addfea0-25b4-425f-8177-293123b53c17", "done": true, "title": "Anzeige der nächsten Deadline und der Anzahl der Aufgaben mit dieser Deadline."}, {"id": "8691196b-412c-48d0-853f-fc8606498df7", "done": true, "title": "Begrüßungsnachricht (z. B. \"Good morning, [User]\"), die sich nach der Tageszeit richtet."}]', 'User Story', 0),
('0bec467f-4b10-41f7-a5c4-30454fc5e903', NULL, 'Überprüfen: Eine Funktion ist maximal 14 Zeilen lang', 'Überprüfen und refactoring', 'done', 'high', NULL, NULL, '2026-03-10 00:00:00+00', '2026-03-10 06:49:57.367952+00', '2026-03-10 06:49:57.367952+00', '[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]', '[]', 'Technical Task', 0),
('e0652e54-7b42-487a-9a42-761859e904c7', NULL, 'Summary Pages Card Hover Effekt', 'The hover effect should be adapted according to the design.', 'done', 'medium', NULL, NULL, '2026-03-12 00:00:00+00', '2026-03-06 12:54:53.979821+00', '2026-03-06 12:54:53.979821+00', '[{"id": "0450c92a-b258-404f-965a-7136a9ebaea9", "name": "Serhat Özcakir", "initials": "SÖ"}]', '[]', 'User Story', 0),
('6027f508-0c6c-4b1b-bccb-6f949d7865fa', NULL, 'JS Doc in allen TS Dateien', '', 'inProgress', 'medium', NULL, NULL, '2026-03-10 00:00:00+00', '2026-03-10 06:52:18.082551+00', '2026-03-10 06:52:18.082551+00', '[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]', '[]', 'Technical Task', 0),
('19e8336f-2564-40c1-bc5c-f9f66064b930', NULL, 'User Story -3', '', 'todo', 'medium', NULL, NULL, '2026-03-07 00:00:00+00', '2026-03-06 11:21:17.160301+00', '2026-03-06 11:21:17.160301+00', '[]', '[]', 'User Story', 0)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 4. Enable Row Level Security (RLS)
-- =====================================================

ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 5. Create RLS Policies (Basic - adjust as needed)
-- =====================================================

-- Contacts: Users can view and manage their own contacts
CREATE POLICY "Users can view own contacts" ON public.contacts
    FOR SELECT USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can insert own contacts" ON public.contacts
    FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can update own contacts" ON public.contacts
    FOR UPDATE USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can delete own contacts" ON public.contacts
    FOR DELETE USING (auth.uid() = user_id OR user_id IS NULL);

-- Profiles: Users can view their own profile
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Tasks: Users can manage their own tasks
CREATE POLICY "Users can view tasks" ON public.tasks
    FOR SELECT USING (true); -- Adjust based on your requirements

CREATE POLICY "Users can insert tasks" ON public.tasks
    FOR INSERT WITH CHECK (auth.uid() = created_by OR guest_token IS NOT NULL);

CREATE POLICY "Users can update tasks" ON public.tasks
    FOR UPDATE USING (auth.uid() = created_by OR guest_token IS NOT NULL);

CREATE POLICY "Users can delete tasks" ON public.tasks
    FOR DELETE USING (auth.uid() = created_by OR guest_token IS NOT NULL);

-- Projects: Basic policies
CREATE POLICY "Users can view projects" ON public.projects
    FOR SELECT USING (true);

CREATE POLICY "Users can insert projects" ON public.projects
    FOR INSERT WITH CHECK (auth.uid() = owner_id OR is_guest_project = true);

-- Task Comments: Users can manage their own comments
CREATE POLICY "Users can view task comments" ON public.task_comments
    FOR SELECT USING (true);

CREATE POLICY "Users can insert task comments" ON public.task_comments
    FOR INSERT WITH CHECK (auth.uid() = author_id OR guest_token IS NOT NULL);
