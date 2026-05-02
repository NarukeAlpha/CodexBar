# OpenAI-Only Fork

This fork intentionally narrows CodexBar to OpenAI/Codex usage only.

## Current Scope

- Keep the macOS menu bar app, Codex/OpenAI usage fetching, Codex token-cost history, WidgetKit snapshots, Sparkle packaging, and release scripts.
- Keep Codex CLI probing as a fallback source, but prefer HTTP-based OpenAI usage data when OAuth credentials or cached/manual OpenAI cookies are available.
- Keep optional OpenAI dashboard enrichments, but do not run WebKit scraping from normal background refreshes.
- Remove the standalone `codexbar` CLI target, Linux CLI packaging, keyboard-shortcut integration, Claude helper executables, and provider UI choices outside Codex/OpenAI.
- Runtime-supported providers are restricted to `UsageProvider.allCases == [.codex]`.

## Battery Policy

Background refresh should stay cheap:

- Default cadence remains 5 minutes, but repeated unchanged background snapshots back off to 15 minutes.
- Background refreshes use provider context `.background` so expensive paths can opt out.
- OpenAI WebKit dashboard refresh is disabled for stale/menu-open background requests.
- HTTP usage fetches should use existing OAuth credentials or cached/manual cookies; browser cookie imports should stay explicit/user-driven.

## OpenAI Sources

Codex/OpenAI usage can come from these sources, in preferred order:

1. **OpenAI OAuth HTTP**: reads Codex OAuth credentials, refreshes access tokens when needed, and calls OpenAI usage endpoints directly.
2. **OpenAI cookie HTTP**: uses a manual or cached OpenAI cookie header for the same HTTP usage fetch path.
3. **Codex CLI fallback**: local Codex CLI status/probe data remains as a lower-priority fallback.
4. **Dashboard WebKit**: reserved for explicit/on-demand dashboard enrichment, not routine background polling.

## API Billing Credits Plan

OpenAI officially documents organization usage and costs endpoints, and the Costs endpoint is the best source for invoice-aligned API spend. The prepaid credit balance shown in API Billing, such as a remaining `$23.00` balance, does not currently appear to have a documented public API endpoint in the OpenAI API reference. Treat that balance as billing-portal data until proven otherwise.

Planned shape:

1. Add an `OpenAIAPIBillingCreditSnapshot` model with `balanceUSD`, `source`, `updatedAt`, and `error`.
2. Add an optional Admin API key setting for official organization costs/usage queries. Use it for spend history only, not as the credit-balance source.
3. Investigate the billing portal network call that backs the visible prepaid balance. If it is stable enough, fetch it through the existing OpenAI cookie HTTP path, never through background WebKit.
4. Cache billing balance for at least 30-60 minutes and refresh only on explicit refresh, menu open after staleness, or app launch. Do not poll it on the normal usage timer.
5. Render API billing balance inside the Cost card as `API credits: $23.00 remaining`, and include its timestamp/source in the Cost hover alongside cost history and subscription utilization.
6. Keep the old token-credit UI removed. If upstream changes the Codex token-credit model, port only the parser pieces needed by this billing-credit snapshot.

## Upstream Porting

When pulling from upstream:

1. Prefer isolated commits or patches that touch `Sources/CodexBarCore/Providers/Codex`, `Sources/CodexBar/Providers/Codex`, OpenAI dashboard code, menu rendering, WidgetKit snapshot rendering, packaging, or shared bug fixes.
2. Avoid reintroducing new providers into `UsageProvider.allCases`, the provider registry bootstrap, widget provider choices, or initial provider detection.
3. Re-check `Package.swift` after merges. The standalone CLI, Commander, KeyboardShortcuts, Claude helper executables, and Linux-only targets should stay out.
4. Re-run `./Scripts/compile_and_run.sh` after each merge chunk so the packaged app and running bundle reflect the current source.
5. If an upstream OpenAI feature depends on shared provider infrastructure, keep the shared primitive only when Codex uses it. Do not restore provider-specific UI or auth stores by default.

## Cleanup Status

Completed:

- Removed standalone CLI targets and keyboard shortcut dependency.
- Removed Claude helper targets from the package.
- Restricted runtime provider ordering/config normalization to Codex.
- Restricted widget provider choices to Codex.
- Switched Codex OAuth fetch strategy to an HTTP-first OAuth/cookie fetch path.
- Disabled background WebKit refresh and added unchanged-data backoff.

Still intentionally staged:

- Non-Codex provider source files still exist in parts of the tree until their shared type references are untangled safely.
- Historical docs for removed providers may remain until the final documentation cleanup pass.
