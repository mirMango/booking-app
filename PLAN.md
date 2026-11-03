# Booking App — Plan

Appointment booking for a small service business (barbershop, tutoring, physio — pick one for the demo data). Customers book time with staff; staff and the owner manage services, working hours, and appointments.

## Stack
- Ruby on Rails (current stable 8.1.x), PostgreSQL
- Hotwire (Turbo + Stimulus), Tailwind CSS
- Devise (authentication) + Pundit (authorization)
- RSpec + FactoryBot, GitHub Actions CI
- Active Job for background work (Rails' default queue is fine)

## Rules for the coding agent
1. Work on ONE step at a time. Do not start the next step.
2. Before changing the database schema, show me the migration and explain it.
3. Do not add gems without asking, and say why each one is needed.
4. Write tests for new behaviour and run the suite before saying a step is done.
5. At the end of each step: tell me how to run and check it, and list the files you changed.
6. Keep code simple and conventional. Prefer plain Rails over clever abstractions.
7. Never commit secrets. Use Rails credentials / environment variables.

## Roles
- **customer**: books, views, and cancels their own appointments
- **staff**: sees their own schedule, manages their own working hours
- **admin (owner)**: manages services, staff, and all appointments

## Data model (first draft)
- `users`: name, email, password (Devise), role (customer / staff / admin)
- `services`: name, duration_minutes, price_cents, active
- `staff_services`: which staff can perform which services
- `working_hours`: staff, weekday, start_time, end_time
- `appointments`: customer, staff, service, starts_at, ends_at, status (confirmed / cancelled / completed), notes

**Key rule:** one staff member cannot have two non-cancelled appointments that overlap. Enforce it in the database (PostgreSQL exclusion constraint with `btree_gist`), not only in Ruby code.

## Steps
Each step = one agent task = one commit. Tick the box when done.

### Phase 0 — Project setup
- [x] 0.1 Create the Rails app in this folder with PostgreSQL; `bin/rails db:create` and the server must work
- [x] 0.2 Add RSpec and FactoryBot, plus a first passing test
- [ ] 0.3 Add GitHub Actions CI that runs the tests
- [ ] 0.4 Write a short README (what it is, how to run it)

### Phase 1 — Accounts and roles
- [ ] 1.1 Devise sign up / log in / log out
- [ ] 1.2 Add `role` to users (customer by default)
- [ ] 1.3 Pundit with a base policy; tests for who can do what
- [ ] 1.4 Seed one admin, two staff, and a few customers

### Phase 2 — Services, staff, working hours
- [ ] 2.1 Admin CRUD for services
- [ ] 2.2 Assign services to staff
- [ ] 2.3 Staff manage their own working hours (validate invalid or overlapping ranges)

### Phase 3 — Available slots
- [ ] 3.1 Plain Ruby class that, given staff + service + date, returns free time slots (working hours minus existing appointments)
- [ ] 3.2 Thorough unit tests for it (day boundaries, back-to-back appointments, cancelled appointments)

### Phase 4 — Booking
- [ ] 4.1 Booking flow: choose service → staff → date → slot → confirm
- [ ] 4.2 Database exclusion constraint against overlapping appointments
- [ ] 4.3 Handle "slot just got taken" with a friendly message
- [ ] 4.4 Test for two simultaneous bookings of the same slot
- [ ] 4.5 Customers see and cancel their appointments (cancellation rule, e.g. at least 24h before)

### Phase 5 — Emails and background jobs
- [ ] 5.1 Confirmation and cancellation emails
- [ ] 5.2 Reminder job 24h before the appointment

### Phase 6 — Staff and admin views
- [ ] 6.1 Staff: daily / weekly schedule
- [ ] 6.2 Admin: all appointments with filters
- [ ] 6.3 Turbo for smooth updates without full page reloads

### Phase 7 — Quality and polish
- [ ] 7.1 Fix N+1 queries; add database indexes
- [ ] 7.2 Request/system tests for the main flows
- [ ] 7.3 Rubocop, clean seeds, error pages
- [ ] 7.4 README with screenshots, architecture notes, and "design decisions"

### Phase 8 — Deploy
- [ ] 8.1 Deploy with a live URL and a production database
- [ ] 8.2 Production email and background jobs working
- [ ] 8.3 Add the live link to the README and the resume

### Phase 9 — Optional: Keycloak SSO
- [ ] 9.1 Run Keycloak locally with Docker Compose
- [ ] 9.2 Add "Log in with Keycloak" through OpenID Connect (keep normal login working)
- [ ] 9.3 Map Keycloak roles to app roles; document it in the README

## Interview talking points (fill in as you build)
- Why the overlap rule lives in the database
- How available slots are calculated
- How roles and permissions are enforced
- What I would improve next
