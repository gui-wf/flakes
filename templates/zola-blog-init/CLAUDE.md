# PROMPT: Build a Minimal Zola Blog Theme for Cloudflare Pages

## ROLE & CONTEXT
You are an expert Zola static site generator developer with deep knowledge of:
- Tera templating engine (similar to Jinja2)
- Rust-based SSG patterns
- Modern CSS/Sass best practices
- Cloudflare Pages deployment
- Performance-first frontend development

## OBJECTIVE
Create a complete, production-ready Zola blog theme that:
1. Displays blog posts as cards with truncated summaries
2. Uses minimal dependencies (no JavaScript unless essential)
3. Deploys seamlessly to Cloudflare Pages
4. Prioritizes content readability and fast loading

## REQUIREMENTS & CONSTRAINTS

### MANDATORY Features
- **Blog listing page** showing posts as cards with:
  - Post title (clickable link)
  - Publication date
  - 2-3 lines of content preview (auto-truncated)
  - "Read more" link
- **Single post page** with full article content
- **Responsive design** (mobile-first)
- **Summary system** using `<!-- more -->` marker or automatic truncation
- **Sass compilation** for styling
- **SEO meta tags** in templates

### File Structure (MUST FOLLOW)
```
project/
├── config.toml          # Site configuration
├── content/
│   └── blog/
│       └── _index.md    # Section config (sort_by = "date")
├── templates/
│   ├── base.html        # Base template with HTML structure
│   ├── index.html       # Homepage
│   ├── section.html     # Blog listing page
│   └── page.html        # Individual post
├── sass/
│   └── style.scss       # Main stylesheet
└── static/              # Static assets
```

### Technical Specifications
1. **Templating**: Use Tera syntax with `{% block %}` inheritance
2. **Markdown**: CommonMark with TOML front matter (`+++`)
3. **Summaries**: Implement both manual (`<!-- more -->`) and auto-truncate fallback
4. **CSS**: Use Sass variables for theming, no CSS frameworks
5. **Build**: Must work with `zola build` and `zola serve`

## IMPLEMENTATION PLAN

### Phase 1: Core Setup
1. Create `config.toml` with:
   ```toml
   base_url = "https://example.com"
   title = "Blog Title"
   compile_sass = true
   highlight_code = true
   ```

### Phase 2: Templates
2. Build `templates/base.html`:
   - DOCTYPE, meta tags, CSS link
   - Navigation with site title
   - `{% block content %}` placeholder
   - Footer

3. Create `templates/section.html` for blog listing:
   ```html
   {% for page in section.pages %}
   <article class="card">
       <h2><a href="{{ page.permalink }}">{{ page.title }}</a></h2>
       <time>{{ page.date | date(format="%B %d, %Y") }}</time>
       <div class="summary">
           {% if page.summary %}
               {{ page.summary | safe | truncate(length=200) }}
           {% else %}
               {{ page.content | striptags | truncate(length=200) }}
           {% endif %}
       </div>
       <a href="{{ page.permalink }}" class="read-more">Continue reading →</a>
   </article>
   {% endfor %}
   ```

### Phase 3: Styling
4. Create `sass/style.scss` with:
   - Card layout with hover effects
   - Typography optimized for reading
   - Responsive breakpoints
   - Summary truncation with ellipsis

### Phase 4: Content Structure
5. Set up `content/blog/_index.md`:
   ```markdown
   +++
   title = "Blog"
   sort_by = "date"
   template = "section.html"
   +++
   ```

### Phase 5: Testing & Deployment
6. Create sample posts with various content lengths
7. Configure for Cloudflare Pages:
   - Build command: `zola build`
   - Output directory: `public`
   - Environment: `ZOLA_VERSION=0.19.2`

## OUTPUT FORMAT

Generate ALL files needed for a working theme. For each file:
1. State the filepath clearly
2. Provide complete, production-ready code
3. Include helpful comments for customization points
4. NO placeholders or "add your content here" - everything should work immediately

## EXAMPLE PATTERNS TO FOLLOW

### Summary Display Pattern
```html
<!-- GOOD: Handles both manual and auto summaries -->
{% if page.summary %}
    {{ page.summary | safe }}
{% else %}
    {{ page.content | striptags | truncate(length=200) }}
{% endif %}
```

### Date Formatting Pattern
```html
<!-- GOOD: Human-readable dates -->
{{ page.date | date(format="%B %d, %Y") }}
```

### Card Hover Effect Pattern
```scss
// GOOD: Subtle, performant hover effect
.card {
    transition: transform 0.2s, box-shadow 0.2s;
    &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
}
```

## SUCCESS CRITERIA

The theme is complete when:
- [ ] `zola serve` runs without errors
- [ ] Blog posts appear as cards with proper truncation
- [ ] Clicking a card shows the full post
- [ ] Design is responsive on mobile/tablet/desktop
- [ ] Page loads are under 1 second
- [ ] HTML validates without errors
- [ ] Can be deployed to Cloudflare Pages

## COMMON PITFALLS TO AVOID

❌ DON'T use external JavaScript libraries
❌ DON'T hardcode URLs - use `{{ get_url() }}` and `{{ page.permalink }}`
❌ DON'T forget the `safe` filter for HTML content
❌ DON'T use complex CSS frameworks
❌ DON'T create empty placeholder files
❌ DON'T mix YAML and TOML front matter

## TESTING CHECKLIST

After implementation, verify:
1. Run `zola build` - should complete without errors
2. Check `public/` directory contains all expected files
3. Test summary truncation with posts of various lengths
4. Verify responsive design at 320px, 768px, 1024px widths
5. Confirm all internal links work correctly
6. Validate HTML output with W3C validator

## ADDITIONAL CONTEXT

This theme will be used for a personal blog focused on technical writing. Prioritize:
- **Readability**: Clean typography, good contrast
- **Performance**: Minimal CSS, no JavaScript
- **Maintainability**: Clear file organization, commented code
- **Flexibility**: Easy to customize colors/fonts via Sass variables

Remember: Generate COMPLETE, WORKING code. Every file should be production-ready with no placeholders or incomplete sections. The user should be able to copy your output directly into their project and have a functioning blog immediately.

---

**START IMPLEMENTATION NOW** - Begin with config.toml and work through each file systematically.

---

# ZOLA_BLOG_THEME_SETUP

## Project Structure
```
your-blog/
├── config.toml
├── content/
│   └── blog/
│       └── _index.md
├── templates/
│   ├── base.html
│   ├── index.html
│   ├── section.html
│   └── page.html
├── sass/
│   └── style.scss
└── static/
```

## 1. Configuration (config.toml)

```toml
# The URL the site will be built for
base_url = "https://example.com"

# Site title
title = "My Blog"
description = "A simple content-focused blog"

# Whether to automatically compile all Sass files in the sass directory
compile_sass = true

# Whether to build a search index
build_search_index = false

# The default language
default_language = "en"

# Highlight code on build
highlight_code = true
highlight_theme = "one-dark"

[markdown]
# Whether to do syntax highlighting
highlight_code = true

# Whether external links are to be opened in a new tab
external_links_target_blank = true

# Whether external links are to be opened with nofollow
external_links_no_follow = true

# Whether external links are to be opened with noreferrer
external_links_no_referrer = true

# Smart punctuation
smart_punctuation = true

[extra]
# Put any custom variables here
author = "Your Name"
```

## 2. Templates

### templates/base.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}{{ config.title }}{% endblock title %}</title>
    <meta name="description" content="{% block description %}{{ config.description }}{% endblock description %}">
    <link rel="stylesheet" href="{{ get_url(path="style.css", trailing_slash=false) }}">
</head>
<body>
    <nav class="nav">
        <div class="container">
            <a href="/" class="nav-logo">{{ config.title }}</a>
            <a href="/blog" class="nav-link">Blog</a>
        </div>
    </nav>
    
    <main class="container">
        {% block content %}{% endblock content %}
    </main>
    
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 {{ config.extra.author | default(value="Author") }}. Built with <a href="https://www.getzola.org">Zola</a>.</p>
        </div>
    </footer>
</body>
</html>
```

### templates/index.html
```html
{% extends "base.html" %}

{% block content %}
<header class="hero">
    <h1>Welcome to {{ config.title }}</h1>
    <p>{{ config.description }}</p>
</header>

<section class="recent-posts">
    <h2>Recent Posts</h2>
    {% set blog = get_section(path="blog/_index.md") %}
    <div class="post-grid">
        {% for page in blog.pages | slice(end=6) %}
        <article class="post-card">
            <h3><a href="{{ page.permalink }}">{{ page.title }}</a></h3>
            <time datetime="{{ page.date }}">{{ page.date | date(format="%B %d, %Y") }}</time>
            <div class="post-summary">
                {% if page.summary %}
                    {{ page.summary | safe | truncate(length=200) }}
                {% else %}
                    {{ page.content | safe | striptags | truncate(length=200) }}
                {% endif %}
            </div>
            <a href="{{ page.permalink }}" class="read-more">Read more →</a>
        </article>
        {% endfor %}
    </div>
    <a href="/blog" class="view-all">View all posts →</a>
</section>
{% endblock content %}
```

### templates/section.html
```html
{% extends "base.html" %}

{% block title %}{{ section.title }} - {{ config.title }}{% endblock title %}

{% block content %}
<header class="page-header">
    <h1>{{ section.title }}</h1>
    {% if section.description %}
        <p>{{ section.description }}</p>
    {% endif %}
</header>

<div class="post-list">
    {% for page in section.pages %}
    <article class="post-card">
        <h2><a href="{{ page.permalink }}">{{ page.title }}</a></h2>
        <time datetime="{{ page.date }}">{{ page.date | date(format="%B %d, %Y") }}</time>
        <div class="post-summary">
            {% if page.summary %}
                {{ page.summary | safe }}
            {% else %}
                {% set content_words = page.content | striptags | split(pat=" ") %}
                {% for word in content_words | slice(end=50) %}{{ word }} {% endfor %}...
            {% endif %}
        </div>
        <a href="{{ page.permalink }}" class="read-more">Continue reading →</a>
    </article>
    {% endfor %}
</div>
{% endblock content %}
```

### templates/page.html
```html
{% extends "base.html" %}

{% block title %}{{ page.title }} - {{ config.title }}{% endblock title %}
{% block description %}{{ page.description | default(value=page.summary) | striptags | truncate(length=160) }}{% endblock description %}

{% block content %}
<article class="post">
    <header class="post-header">
        <h1>{{ page.title }}</h1>
        <div class="post-meta">
            <time datetime="{{ page.date }}">{{ page.date | date(format="%B %d, %Y") }}</time>
            {% if page.reading_time %}
                <span>• {{ page.reading_time }} min read</span>
            {% endif %}
        </div>
    </header>
    
    <div class="post-content">
        {{ page.content | safe }}
    </div>
    
    <footer class="post-footer">
        <a href="/blog">← Back to all posts</a>
    </footer>
</article>
{% endblock content %}
```

## 3. Styles (sass/style.scss)

```scss
// Variables
$primary-color: #2c3e50;
$accent-color: #3498db;
$text-color: #333;
$light-gray: #f8f9fa;
$border-color: #dee2e6;
$max-width: 900px;

// Reset
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

// Base
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    font-size: 16px;
    line-height: 1.6;
    color: $text-color;
    background: white;
}

a {
    color: $accent-color;
    text-decoration: none;
    transition: color 0.2s;
    
    &:hover {
        color: darken($accent-color, 10%);
        text-decoration: underline;
    }
}

// Container
.container {
    max-width: $max-width;
    margin: 0 auto;
    padding: 0 20px;
}

// Navigation
.nav {
    background: $primary-color;
    padding: 1rem 0;
    margin-bottom: 2rem;
    
    .container {
        display: flex;
        align-items: center;
        gap: 2rem;
    }
    
    .nav-logo {
        color: white;
        font-size: 1.25rem;
        font-weight: bold;
        text-decoration: none;
        
        &:hover {
            color: white;
            text-decoration: none;
        }
    }
    
    .nav-link {
        color: rgba(255, 255, 255, 0.9);
        
        &:hover {
            color: white;
        }
    }
}

// Hero
.hero {
    text-align: center;
    padding: 3rem 0;
    margin-bottom: 3rem;
    
    h1 {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        color: $primary-color;
    }
    
    p {
        font-size: 1.25rem;
        color: #666;
    }
}

// Post Grid
.post-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 2rem;
    margin-bottom: 2rem;
}

// Post Card
.post-card {
    background: $light-gray;
    border-radius: 8px;
    padding: 1.5rem;
    transition: transform 0.2s, box-shadow 0.2s;
    
    &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    
    h2, h3 {
        margin-bottom: 0.5rem;
        
        a {
            color: $primary-color;
            text-decoration: none;
            
            &:hover {
                color: $accent-color;
            }
        }
    }
    
    time {
        display: block;
        color: #666;
        font-size: 0.9rem;
        margin-bottom: 1rem;
    }
    
    .post-summary {
        color: #555;
        margin-bottom: 1rem;
        line-height: 1.6;
        
        // Ensure truncation works properly
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    
    .read-more {
        color: $accent-color;
        font-weight: 500;
        
        &:hover {
            text-decoration: underline;
        }
    }
}

// Post List (for blog section)
.post-list {
    .post-card {
        background: white;
        border: 1px solid $border-color;
        margin-bottom: 2rem;
        
        h2 {
            font-size: 1.5rem;
        }
    }
}

// Single Post
.post {
    .post-header {
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid $border-color;
        
        h1 {
            font-size: 2.5rem;
            color: $primary-color;
            margin-bottom: 0.5rem;
        }
        
        .post-meta {
            color: #666;
        }
    }
    
    .post-content {
        margin-bottom: 3rem;
        
        h2 {
            margin: 2rem 0 1rem;
            color: $primary-color;
        }
        
        h3 {
            margin: 1.5rem 0 0.75rem;
            color: $primary-color;
        }
        
        p {
            margin-bottom: 1rem;
        }
        
        ul, ol {
            margin-bottom: 1rem;
            padding-left: 2rem;
        }
        
        blockquote {
            border-left: 4px solid $accent-color;
            padding-left: 1rem;
            margin: 1rem 0;
            color: #666;
            font-style: italic;
        }
        
        pre {
            background: $light-gray;
            padding: 1rem;
            border-radius: 4px;
            overflow-x: auto;
            margin-bottom: 1rem;
        }
        
        code {
            background: $light-gray;
            padding: 0.2rem 0.4rem;
            border-radius: 3px;
            font-size: 0.9em;
        }
        
        pre code {
            background: none;
            padding: 0;
        }
        
        img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 1rem auto;
        }
    }
    
    .post-footer {
        padding-top: 2rem;
        border-top: 1px solid $border-color;
    }
}

// Footer
.footer {
    margin-top: 4rem;
    padding: 2rem 0;
    background: $light-gray;
    text-align: center;
    color: #666;
    
    a {
        color: $accent-color;
    }
}

// Utilities
.view-all {
    display: inline-block;
    margin-top: 1rem;
    font-weight: 500;
}

.page-header {
    margin-bottom: 2rem;
    
    h1 {
        color: $primary-color;
        margin-bottom: 0.5rem;
    }
    
    p {
        color: #666;
        font-size: 1.1rem;
    }
}

// Responsive
@media (max-width: 768px) {
    .hero h1 {
        font-size: 2rem;
    }
    
    .post h1 {
        font-size: 2rem;
    }
    
    .post-grid {
        grid-template-columns: 1fr;
    }
}
```

## 4. Content Structure

### content/blog/_index.md
```markdown
+++
title = "Blog"
description = "Thoughts and writings on various topics"
sort_by = "date"
template = "section.html"
page_template = "page.html"
+++
```

### Example Blog Post (content/blog/first-post.md)
```markdown
+++
title = "Welcome to My New Blog"
date = 2025-01-15
description = "This is my first blog post on my new Zola-powered blog."
[taxonomies]
tags = ["introduction", "zola"]
+++

This is the introduction to my blog post. It will appear in the summary on the blog listing page.

<!-- more -->

## The Full Content

Here's the rest of the blog post that will only be visible when someone clicks to read the full article. You can write as much content as you want here.

### Adding Code

```rust
fn main() {
    println!("Hello, Zola!");
}
```

### Lists Work Too

- First item
- Second item
- Third item

And regular paragraphs with **bold** and *italic* text.
```

## 5. Deployment to Cloudflare Pages

### Build Configuration
- **Build command**: `zola build`
- **Build output directory**: `public`
- **Environment variables**: 
  - `ZOLA_VERSION`: `0.19.2` (or latest version)

### Steps to Deploy:
1. Push your repository to GitHub/GitLab
2. Go to Cloudflare Pages dashboard
3. Create a new project and connect your repository
4. Set the build configuration as shown above
5. Deploy!

## 6. Features Implemented

✅ **Clean, content-focused design** - Minimal distractions, focus on readability
✅ **Blog post cards** - Shows title and 2-3 lines of content with truncation
✅ **Automatic summary generation** - Uses `<!-- more -->` marker or automatic truncation
✅ **Responsive design** - Works on all devices
✅ **Fast loading** - Minimal CSS, no JavaScript required
✅ **SEO friendly** - Proper meta tags and semantic HTML
✅ **Syntax highlighting** - Built-in code highlighting support

## 7. Customization Tips

### To change colors:
Edit the variables at the top of `sass/style.scss`

### To adjust summary length:
In `templates/section.html`, change the truncate length:
```html
{{ page.summary | safe | truncate(length=200) }}
```

### To add more metadata:
Add fields to your post front matter and access them in templates using `page.extra.field_name`

## Usage

1. Create new blog posts in `content/blog/` as `.md` files
2. Add `<!-- more -->` where you want the summary to end
3. Run `zola serve` to preview locally
4. Push to your repository to auto-deploy to Cloudflare Pages

## Development Environment

This project uses Nix flakes for reproducible development environments.

### Getting Started
```bash
# Enter development shell
nix develop

# Or with direnv (recommended)
echo "use flake" > .envrc
direnv allow
```

### Available Tools
- **Zola** for static site generation
- **Node.js** with npm for additional tooling
- **Python 3** with pip for scripting and preprocessing
- **Essential utilities**: wget, yq, jq for data processing
- **Development tools**: git, curl, tree, nano, vim

### Zola Commands
```bash
# Create a new site
zola init mysite

# Start development server (auto-reload)
zola serve
# or
nix run

# Build for production
zola build
# or  
nix run .#build

# Check site for issues
zola check
```

### Nix Commands Reference
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