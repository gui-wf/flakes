# perplexity-webui-scraper

Lightweight Perplexity AI MCP server using HTTP session tokens.

## Usage

```bash
# Run the MCP server
nix run github:gui-wf/flakes#perplexity-webui-scraper
```

## Configuration

Requires a Perplexity Pro subscription and session token.

### Getting Your Session Token

1. Log into [perplexity.ai](https://perplexity.ai) in your browser
2. Open Developer Tools (F12) → Application → Cookies
3. Copy the value of `__Secure-next-auth.session-token`

### Environment Variable

```bash
export PERPLEXITY_SESSION_TOKEN="your-token-here"
```

## MCP Client Configuration

Add to your MCP client config (e.g., Claude Desktop):

```json
{
  "mcpServers": {
    "perplexity": {
      "command": "nix",
      "args": ["run", "github:gui-wf/flakes#perplexity-webui-scraper"],
      "env": {
        "PERPLEXITY_SESSION_TOKEN": "your-token-here"
      }
    }
  }
}
```

## License

MIT (upstream project)
