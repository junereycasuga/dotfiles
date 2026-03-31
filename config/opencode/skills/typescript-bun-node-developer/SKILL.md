---
name: typescript-bun-node-developer
description: Build and maintain TypeScript services and tools across Bun and Node.js runtimes.
compatibility: opencode
---

## Overview

Use this skill when implementing, debugging, or refactoring backend services, CLIs, and libraries in TypeScript that run on Bun, Node.js, or both.

This skill emphasizes:
- Runtime-aware coding (Bun vs Node.js)
- Type-safe APIs and data boundaries
- Fast local feedback loops (tests, typecheck, lint)
- Practical production concerns (logging, errors, configuration)

## Runtime Mindset

Default to writing portable TypeScript unless project constraints require runtime-specific APIs.

- Prefer Web-standard APIs (`fetch`, `URL`, `Request`, `Response`, `AbortController`) when possible.
- Use runtime-specific features only when they provide clear value:
  - Bun: fast startup, native test runner, package manager ergonomics
  - Node.js: mature ecosystem, broad production footprint, stable core APIs
- Keep imports explicit and consistent with project module format (ESM/CJS).

## Implementation Workflow

1. Discover project conventions before changing code:
   - package manager (`bun`, `npm`, `pnpm`, `yarn`)
   - TypeScript config style (`strict`, path aliases, module target)
   - Testing stack and linting setup
2. Make the smallest safe change that solves the problem.
3. Validate in this order when available:
   - formatting/lint
   - typecheck
   - targeted tests
   - full test suite for larger changes
4. Keep edits coherent: update types, runtime guards, and tests together.

## TypeScript Standards

- Enable and preserve strict typing patterns already present in the repo.
- Prefer narrow types over `any`; use `unknown` plus validation at boundaries.
- Model domain data with explicit interfaces/types and discriminated unions when useful.
- Favor pure functions for core logic and isolate side effects in small adapters.
- Make async behavior explicit with typed return values (`Promise<Result>` patterns where used).

## Node.js and Bun Guidance

### Compatibility

- If code is shared across runtimes, avoid implicit assumptions about globals and filesystem semantics.
- Guard runtime-specific code paths behind clear adapters.
- Keep entrypoints separated when behavior must diverge by runtime.

### Performance

- Avoid unnecessary serialization/deserialization in hot paths.
- Stream large payloads when practical.
- Reuse parsers/clients instead of recreating per request.

### Error Handling

- Do not swallow exceptions silently.
- Attach context to errors (operation, identifiers, upstream system).
- Prefer typed error shapes where the codebase already uses them.

## API and Service Patterns

- Validate all external input (HTTP, queue messages, env vars, files).
- Keep handler layers thin; delegate business logic to testable modules.
- Use idempotent patterns for retry-prone operations.
- Add structured logs with stable keys; avoid logging secrets.

## Testing Strategy

- Add or update tests for behavior changes.
- Prefer focused unit tests for pure logic and integration tests for boundaries.
- Use table-driven patterns for validation-heavy code.
- For bug fixes, include a regression test that fails before the fix.

## Commands to Prefer

Detect and follow existing scripts first. If absent, use typical defaults:

- Bun:
  - `bun install`
  - `bun test`
  - `bun run typecheck`
  - `bun run lint`
- Node.js (script-driven):
  - `npm test` (or equivalent package manager)
  - `npm run typecheck`
  - `npm run lint`

## Security and Operations

- Treat environment variables as untrusted input; validate on startup.
- Never hardcode credentials or tokens.
- Redact secrets from logs and error surfaces.
- Keep dependency updates scoped and verify lockfile changes.

## When to Use This Skill

Use this skill when tasks involve any of the following:
- TypeScript feature development or refactoring
- Bun/Node runtime compatibility decisions
- API handler implementation and validation logic
- Improving tests, type safety, and reliability in TS services
