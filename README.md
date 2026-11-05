# Wayback Machine Exclude List

> An exclusion list for the [Wayback Machine Web Extension](https://github.com/internetarchive/wayback-machine-webextension).

Because the extension stores its exclude rules locally in the browser, reinstalling your browser or setting up a new machine wipes your custom configuration. This repository provides a **centralized, ready-to-copy master exclude list** that you can paste directly into the extension's **Exclude URLs...** dialogue.

---

## Quick Start

1. Open the raw list: **[exclude-list.txt](https://raw.githubusercontent.com/beabzk/wayback-machine-exclude-list/master/exclude-list.txt)**
2. Select all and copy.
3. Click the **Wayback Machine** icon in your browser toolbar.
4. Open the extension settings and switch to the **General** tab.
5. Under **Auto Save Page**, click **Exclude URLs...**.
6. Paste the copied list into the text area.
7. Click **Save**.

---

## Built-in Exclusions

When you copy and paste this list into the **Exclude URLs...** dialog, the extension **overwrites** its pre-populated starter list.

To make copy-pasting completely safe and seamless, **all overwritable default patterns are included in this repository**.

**What is NOT included here (hardcoded in extension code):**
The extension hardcodes internal checks in `utils.js` (`excluded_urls`) that cannot be overwritten or bypassed through the UI:

- Local addresses: `127.0.0.1`, `localhost`, `0.0.0.0`, `192.168.`, `10.`
- Browser schemes: `chrome:`, `chrome-extension:`, `about:`, `moz-extension:`, `file:`, `edge:`, `extension:`, `safari-web-extension:`, `chrome-error:`

Because the extension automatically rejects these at the engine level, they cannot and do not need to be added to this list.

---

## Categories

The master list is compiled from modular files located in [`categories/`](categories/):

| Category                                                        | Description                                               | Examples Excluded                                                              |
| --------------------------------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **[AI Assistants](categories/ai-assistants.txt)**               | Dynamic chat interfaces, prompts, and tokens              | ChatGPT, Claude, Google Gemini, Perplexity, DeepSeek, Copilot                  |
| **[Authentication & IdP](categories/authentication-idp.txt)**   | SSO, 2FA endpoints, password manager vaults, login forms  | Google Accounts, Microsoft Login, Apple ID, Bitwarden, 1Password, `*/login*`   |
| **[Banking & Finance](categories/banking-finance.txt)**         | Financial dashboards, payment gateways, crypto exchanges  | PayPal, Stripe Checkout, Chase, Bank of America, Wise, Revolut, Coinbase       |
| **[Cloud & Developer Portals](categories/cloud-developer.txt)** | Infrastructure consoles, secret keys, telemetry, settings | AWS Console, Google Cloud, Azure Portal, Cloudflare Dash, GitHub Settings      |
| **[Email & Messaging](categories/email-messaging.txt)**         | Private mailboxes, web chat, and team workspaces          | Gmail, Outlook, Yahoo Mail, Proton Mail, Discord channels, Slack, Telegram     |
| **[Search Engines](categories/search-engines.txt)**             | Ephemeral queries and search history                      | Google Search, DuckDuckGo, Bing, Kagi, Startpage, Yandex, Ecosia, Baidu, SearX |
| **[Shopping & Checkouts](categories/shopping-checkout.txt)**    | Personal orders, shipping details, checkout flows         | Amazon Cart & Orders, eBay Checkout, `*/cart*`, `*/checkout*`                  |
| **[Social Media](categories/social-media.txt)**                 | Direct messages, personal notification feeds              | X/Twitter Messages & Notifications, Facebook Messenger, Instagram Direct       |
| **[Streaming Media](categories/streaming-heavy-media.txt)**     | Video players & diagnostics that break snapshots          | YouTube Watch, Netflix, Spotify Web, Twitch, Speedtest                         |
| **[Utilities & Local](categories/utility-misc.txt)**            | Routers, captive portals, Archive.org self-exclusion      | `archive.org*`, `routerlogin.net*`, `tplinkwifi.net*`, `pi.hole*`              |

---

## Contribution Pipeline

Files in `categories/*.txt` are the only user-editable files in this repository:

1. **Contributors**: Only edit or add patterns in `categories/*.txt`.
2. **Pull Requests**: GitHub Actions runs the linter and functional tests to verify proposed rules.
3. **Master Push / Merge**: GitHub Actions automatically compiles `categories/*.txt` into `exclude-list.txt` and commits it to the `master` branch.

To run tests locally:

```bash
./scripts/test.sh
```

For full contribution instructions and rule guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on submitting domain requests and pull requests.

---

## License

[MIT](LICENSE)
