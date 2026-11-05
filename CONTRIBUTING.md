# Contributing to Wayback Machine Exclude List

Thank you for contributing to the Wayback Machine Exclude List. This guide outlines how to propose new exclusions, report over-blocked sites, and submit pull requests.

---

## Core Principles

1. **Only `categories/*.txt` are user-editable**:
   Do not create, edit, or commit `exclude-list.txt`. The compiled release list is automatically generated and committed by GitHub Actions when changes merge to `master`.

2. **Avoid over-blocking**:
   The goal of this list is to prevent private sessions, webmail, ephemeral search queries, and dynamic account dashboards from auto-saving, while preserving the ability to archive public knowledge, documentation, and articles.

---

## Rule Guidelines

### 1. Whole-Domain vs. Path-Specific Exclusions

- **Whole-domain exclusions** (`service.com*` and `*.service.com*`):
  Use when the entire service is authenticated, private, or ephemeral.
  Examples: Banking portals (`chase.com*`), password managers (`*.1password.com*`), email services (`mail.yahoo.com*`), AI chat tools (`claude.ai*`).

- **Path-specific exclusions** (`service.com/subpath/*`):
  Use when a platform hosts public content alongside private user sections.
  Examples:
  - Discord: `discord.com/channels/*` (excludes private chats and DMs, allows public Discord links).
  - GitHub: `github.com/settings*`, `github.com/notifications*` (excludes personal account dashboards, allows public repositories).
  - Amazon: `amazon.com/gp/cart*`, `amazon.com/checkout*` (excludes cart/checkout, allows product pages).
  - Social Media: `x.com/messages*`, `reddit.com/message/*` (excludes private DMs, allows public posts).

### 2. Syntax Rules

- **Wildcard**: `*` matches zero or more characters.
- **Subdomains**: To exclude all subdomains, use `*.domain.com*` alongside `domain.com*`.
- **No internal spaces**: Rules must not contain spaces.
- **No redundant asterisks**: Do not use `**`.
- **No hardcoded internal schemes**: Do not add `localhost`, `127.0.0.1`, `chrome://`, or `file://`. The extension engine automatically rejects these at the code level.

### 3. File Organization

Place rules in the relevant file inside `categories/`:
- `ai-assistants.txt`: Generative AI tools and chat platforms.
- `authentication-idp.txt`: Identity providers, SSO, password managers, login paths.
- `banking-finance.txt`: Banks, payment processors, crypto exchanges.
- `cloud-developer.txt`: Cloud consoles, hosting dashboards, developer accounts.
- `email-messaging.txt`: Webmail, Discord channels, messaging platforms.
- `search-engines.txt`: Search queries and result pages.
- `shopping-checkout.txt`: Carts, orders, billing, checkout paths.
- `social-media.txt`: Personal inboxes, notifications, direct messages.
- `streaming-heavy-media.txt`: Video players and bandwidth tests that break snapshots.
- `utility-misc.txt`: Routers, captive portals, Wayback self-exclusion.

Add a short comment before your rule specifying the service name (e.g. `# Service Name`).

---

## How to Submit a Pull Request

1. Fork this repository on GitHub.
2. Clone your fork locally:
   ```bash
   git clone git@github.com:<your-username>/wayback-machine-exclude-list.git
   cd wayback-machine-exclude-list
   ```
3. Create a feature branch:
   ```bash
   git checkout -b add-example-service
   ```
4. Add your patterns to the appropriate file in `categories/*.txt`.
5. Run the test suite:
   ```bash
   ./scripts/test.sh
   ```
6. Commit your changes:
   ```bash
   git add categories/
   git commit -m "Add Example Service to categories/<category>.txt"
   ```
7. Push your branch to GitHub and open a Pull Request targeting the `master` branch.

Do not commit `exclude-list.txt`. GitHub Actions will automatically compile and commit it upon merge.

---

## Reporting Issues

- **New Domain Requests**: If you prefer not to submit a PR, open an issue using the "Domain Addition Request" form.
- **False Positives / Over-blocking**: If a pattern prevents a legitimate public page from being archived, open an issue using the "False Positive Report" form.
