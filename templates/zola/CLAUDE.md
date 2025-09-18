# Zola Static Site Development Environment

This project uses Nix flakes for reproducible Zola static site development environments.

## Development Environment

### Getting Started
```bash
# Enter development shell
nix develop

# Or with direnv (recommended)
echo "use flake" > .envrc
direnv allow
```

### Available Tools
- **Zola** for static site generation and development
- **Node.js** with npm for additional frontend tooling
- **Python 3** with pip for scripting and content processing
- **Essential utilities**: wget, yq, jq for data processing and API integration
- **Development tools**: git, curl, tree, nano, vim

## Zola Development Workflows

### Project Initialization
```bash
# Create a new Zola site
zola init my-site
cd my-site

# Initialize git repository
git init

# Start development server
zola serve
```

### Development Commands
```bash
# Start development server with auto-reload
zola serve

# Start on specific port and interface
zola serve --port 3000 --interface 0.0.0.0

# Build for production
zola build

# Build with draft content included
zola build --drafts

# Check for common issues
zola check

# Check including drafts
zola check --drafts
```

### Content Management

#### Creating Content
```bash
# Create a new section
mkdir content/blog
touch content/blog/_index.md

# Create a new page
touch content/blog/my-first-post.md
```

#### Front Matter Patterns
```markdown
+++
title = "Page Title"
date = 2025-01-15
description = "Page description for SEO"
draft = false

[extra]
custom_field = "custom value"

[taxonomies]
tags = ["tag1", "tag2"]
categories = ["category1"]
+++

Content goes here...
```

### Template Development

#### Template Hierarchy
- `base.html` - Base template with common structure
- `index.html` - Homepage template
- `section.html` - Section/list page template
- `page.html` - Individual page template

#### Common Template Patterns
```html
<!-- Extending base template -->
{% extends "base.html" %}

<!-- Block definitions -->
{% block title %}{{ page.title }} - {{ config.title }}{% endblock %}

<!-- Conditional content -->
{% if page.date %}
    <time>{{ page.date | date(format="%B %d, %Y") }}</time>
{% endif %}

<!-- Iterating over content -->
{% for page in section.pages %}
    <article>
        <h2><a href="{{ page.permalink }}">{{ page.title }}</a></h2>
    </article>
{% endfor %}

<!-- Using filters -->
{{ page.content | safe }}
{{ page.summary | striptags | truncate(length=200) }}
```

### Configuration Management

#### Basic Configuration (config.toml)
```toml
base_url = "https://example.com"
title = "Site Title"
description = "Site description"

# Build settings
compile_sass = true
minify_html = true
build_search_index = true

# Language and localization
default_language = "en"

# Theme settings
theme = "my-theme"

[markdown]
highlight_code = true
highlight_theme = "base16-ocean-dark"
render_emoji = true
external_links_target_blank = true

[extra]
# Custom variables accessible in templates
author = "Author Name"
social_links = [
    { name = "GitHub", url = "https://github.com/username" },
    { name = "Twitter", url = "https://twitter.com/username" }
]
```

### Styling and Assets

#### Sass Integration
```scss
// sass/style.scss
$primary-color: #333;
$accent-color: #007acc;

body {
    font-family: system-ui, sans-serif;
    color: $primary-color;
}

.highlight {
    color: $accent-color;
}
```

#### Static Assets
```
static/
├── images/
├── fonts/
├── favicon.ico
└── robots.txt
```

### Content Organization Patterns

#### Blog Structure
```
content/
├── _index.md              # Homepage
├── about.md               # About page
└── blog/
    ├── _index.md          # Blog section index
    ├── 2025/
    │   └── first-post.md
    └── categories/
        └── _index.md
```

#### Documentation Structure
```
content/
├── _index.md
├── docs/
│   ├── _index.md
│   ├── getting-started.md
│   └── advanced/
│       ├── _index.md
│       └── configuration.md
└── api/
    ├── _index.md
    └── reference.md
```

### SEO and Performance

#### Meta Tags Pattern
```html
<head>
    <title>{% block title %}{{ config.title }}{% endblock %}</title>
    <meta name="description" content="{% block description %}{{ config.description }}{% endblock %}">
    
    <!-- Open Graph -->
    <meta property="og:title" content="{{ page.title | default(value=config.title) }}">
    <meta property="og:description" content="{{ page.description | default(value=config.description) }}">
    <meta property="og:type" content="website">
    <meta property="og:url" content="{{ page.permalink | default(value=config.base_url) }}">
</head>
```

#### Image Optimization
```html
<!-- Responsive images -->
<img src="{{ get_url(path='images/photo.jpg') }}" 
     alt="Description"
     loading="lazy"
     width="800" 
     height="600">
```

### Deployment Patterns

#### Cloudflare Pages
```yaml
# Build configuration
Build command: zola build
Build output directory: public
Environment variables:
  ZOLA_VERSION: 0.19.2
```

#### GitHub Pages
```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages
on:
  push:
    branches: [ main ]
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Zola
        uses: taiki-e/install-action@zola
      - name: Build site
        run: zola build
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

### Debugging and Troubleshooting

#### Common Issues
- **Build fails**: Check `config.toml` syntax and file paths
- **Templates not found**: Verify template names match section configurations
- **Images not loading**: Ensure images are in `static/` directory
- **Sass compilation errors**: Check Sass syntax and variable definitions

#### Debug Commands
```bash
# Verbose build output
zola build --verbose

# Check for broken links
zola check

# Build with drafts for testing
zola build --drafts
```

### Content Validation

#### Front Matter Validation
- Ensure all required fields are present
- Check date format: `YYYY-MM-DD` or `YYYY-MM-DDTHH:MM:SS`
- Validate taxonomy configurations

#### Link Checking
```bash
# Check for broken internal links
zola check

# External link validation (manual)
# Use tools like linkchecker after building
```

## Advanced Development

### Custom Shortcodes
```html
<!-- templates/shortcodes/youtube.html -->
<div class="youtube-wrapper">
    <iframe src="https://www.youtube.com/embed/{{ id }}" 
            frameborder="0" 
            allowfullscreen>
    </iframe>
</div>
```

### Multilingual Sites
```toml
# config.toml
[languages.en]
title = "English Site"

[languages.fr]
title = "Site Français"
```

### Custom Taxonomies
```toml
# config.toml
[taxonomies]
tags = { paginate_by = 5 }
categories = { paginate_by = 10, rss = true }
series = { paginate_by = 5, rss = true }
```

## AI Development Guidelines

### AI Notes and Breadcrumbs
- Use `AIDEV-NOTE:`, `AIDEV-TODO:`, or `AIDEV-QUESTION:` (all-caps prefix) text anchors for comments aimed at AI and developers.
- Keep them concise (≤ 120 chars).
- **Important:** Before scanning files, always first try to **locate existing anchors** `AIDEV-*` in relevant subdirectories.
- **Anchors** can and may mention Plane Work Items or GitHub Issues.
- **Update relevant anchors** when modifying associated code.
- **Do not remove `AIDEV-NOTE`s** without explicit human instruction.
- **Convert any existing TODOs to AIDEV format** preserving debugging context and reproduction steps.
- **Structure**:
  - **What**: Action needed (concise)
  - **Why**: Context/constraint (brief)
  - **How to reproduce**: Steps when applicable
  - **Current vs expected**: State difference
- **Principles**: Clear while concise, simplicity over complexity, be specific about content/template context, preserve reproduction steps and debugging context.
- **Examples**:
  - `AIDEV-TODO: Fix pagination config - blog shows all posts instead of 10 per page, breaks navigation on large sites`
  - `AIDEV-TODO: Add image shortcode - current: manual HTML, expected: {% image() %} shortcode with responsive sizes`
  - `AIDEV-QUESTION: Should we use section.html or index.html for homepage? Current: index.html, but content suggests section pattern`

### Accountability - when you don't know
- DO NOT ASSUME information or facts you are unsure about. Either ask, use web search or just say you don't know.

## MCP Server Configuration

This project includes `.mcp.json` with pre-configured MCP servers for enhanced AI assistance:
- **Ref**: Reference and documentation tools
- **Sequential Thinking**: Enhanced reasoning capabilities
- **Perplexity**: Web search and research assistance

Set environment variables:
```bash
export REF_API_KEY="your-ref-api-key"
export PERPLEXITY_API_KEY="your-perplexity-api-key"
```

## Nix Commands Reference

```bash
# Development
nix develop              # Enter dev shell with Zola
nix run                 # Start development server (zola serve)
nix run .#build         # Build static site (zola build)

# Flake management
nix flake update        # Update flake.lock
nix flake check         # Validate flake
nix flake show          # Show flake outputs

# Cleanup
nix-collect-garbage     # Clean old generations
```

## Project Structure Examples

### Minimal Blog
```
my-blog/
├── config.toml
├── content/
│   ├── _index.md
│   └── posts/
│       ├── _index.md
│       └── first-post.md
├── templates/
│   ├── base.html
│   ├── index.html
│   ├── section.html
│   └── page.html
├── sass/
│   └── style.scss
└── static/
    └── favicon.ico
```

### Documentation Site
```
my-docs/
├── config.toml
├── content/
│   ├── _index.md
│   ├── docs/
│   │   ├── _index.md
│   │   ├── installation.md
│   │   └── guide/
│   │       ├── _index.md
│   │       └── basics.md
│   └── api/
│       ├── _index.md
│       └── reference.md
├── templates/
│   ├── base.html
│   ├── index.html
│   ├── docs.html
│   └── page.html
└── static/
    ├── docs.css
    └── search.js
```