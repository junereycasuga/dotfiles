---
name: go-developer
description: Build and maintain reliable Go services, CLIs, and libraries with idiomatic patterns.
compatibility: opencode
---

## Overview

Use this skill when implementing, debugging, or improving Go codebases, especially backend services and command-line tools.

This skill emphasizes:
- Idiomatic Go design and package structure
- Clear error handling and observability
- Concurrency correctness
- Fast feedback with tests, vetting, and formatting

## Implementation Workflow

1. Inspect repository conventions first:
   - module layout (`cmd`, `internal`, `pkg`)
   - logging/tracing approach
   - testing style and helper patterns
2. Make focused, minimal changes that fit existing abstractions.
3. Validate in this order:
   - `go fmt` / `gofmt`
   - `go test` for touched packages
   - `go test ./...` for broader changes
   - `go vet ./...` when available
4. Keep behavior, tests, and documentation aligned in the same change.

## Idiomatic Go Principles

- Prefer simple APIs and small interfaces defined at point of use.
- Return concrete types where practical; avoid interface overuse.
- Keep package boundaries clear and acyclic.
- Use composition over inheritance-like patterns.
- Minimize global mutable state.

## Error Handling

- Handle errors explicitly and early.
- Wrap errors with context using `%w` when propagating.
- Avoid panic for expected runtime failures.
- Keep error messages actionable (operation + cause).

## Concurrency and Context

- Accept `context.Context` for request-scoped operations and pass it through call chains.
- Respect context cancellation in I/O and goroutines.
- Avoid goroutine leaks: ensure workers exit on context done or channel close.
- Protect shared state with clear ownership, channels, or mutexes as appropriate.

## API and Service Patterns

- Validate external input at boundaries.
- Keep handlers thin; move domain logic into dedicated packages.
- Use dependency injection via constructors for testability.
- Add structured logs with stable fields; never log secrets.

## Testing Strategy

- Write table-driven tests for branch-heavy logic.
- Use subtests (`t.Run`) for clarity.
- Prefer deterministic tests; avoid timing fragility.
- Add regression tests for bug fixes.
- Use benchmarks (`go test -bench`) for performance-sensitive paths.

## Project Hygiene

- Keep `go.mod` and `go.sum` tidy; avoid unnecessary dependency churn.
- Run formatting tools consistently.
- Keep exported APIs documented when adding public symbols.
- Preserve backward compatibility unless change is intentional and documented.

## Commands to Prefer

Use repository scripts if present; otherwise standard Go tooling:

- `go test ./...`
- `go test ./path/to/pkg -run TestName`
- `go vet ./...`
- `gofmt -w .`
- `go mod tidy`

## Security and Reliability

- Treat config and env vars as untrusted input; validate on startup.
- Enforce timeouts on outbound calls.
- Use `http.Client` reuse and sane transport settings.
- Review retry behavior for idempotency and backoff.

## When to Use This Skill

Use this skill when tasks involve:
- New Go feature work or refactors
- Debugging production issues in Go services
- Improving error handling, concurrency safety, or test coverage
- Hardening Go APIs, workers, and CLI tools
