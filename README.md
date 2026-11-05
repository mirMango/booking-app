# Booking App

[![CI](https://github.com/mirMango/booking-app/actions/workflows/ci.yml/badge.svg)](https://github.com/mirMango/booking-app/actions/workflows/ci.yml)

An appointment booking platform designed for small service businesses (such as barbershops, tutoring services, or physiotherapy clinics). The application accommodates three core roles: customers who can browse, book, view, and cancel their own appointments; staff members who manage their working hours and view their personal schedules; and administrators/owners who oversee all appointments, staff members, and services offered.

## Status

This project is currently in **early development** (Phase 0 complete). The application skeleton, database configuration, test suite framework, and continuous integration pipeline are in place. Core application features (accounts, services, scheduling, and booking workflows) are currently planned. Detailed roadmap and implementation milestones are tracked in [PLAN.md](PLAN.md).

## Tech Stack

- **Framework**: Ruby on Rails 8.1.x
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus) with Tailwind CSS
- **Authentication & Authorization**: Devise + Pundit *(planned)*
- **Testing**: RSpec, FactoryBot
- **CI / Quality**: GitHub Actions, RuboCop, Brakeman, bundler-audit

## Prerequisites

- **Ruby**: `3.4.12` (specified in `.ruby-version`)
- **PostgreSQL**: 9.5+ (running locally and accepting connections)

## Setup

1. **Install gem dependencies**:
   ```bash
   bundle install
   ```

2. **Create and migrate the database**:
   ```bash
   bin/rails db:create db:migrate
   ```

3. **Start the development server (with Tailwind watcher)**:
   ```bash
   bin/dev
   ```
   Open [http://localhost:3000](http://localhost:3000) in your browser.

## Running Tests & CI

- **Run unit and integration tests**:
  ```bash
  bundle exec rspec
  ```

- **Run all continuous integration checks locally (setup, style, security, tests)**:
  ```bash
  bin/ci
  ```
