# MCP Server Development Guidelines

## Project Overview
Model Context Protocol (MCP) server built with TypeScript. MCP servers expose tools that AI assistants can use to interact with external services and data sources.

## Tech Stack
- **Runtime**: Node.js 20 on Nix
- **Language**: TypeScript 5.3+ with ES modules
- **MCP SDK**: @modelcontextprotocol/sdk ^0.6.0
- **Validation**: Zod for runtime type checking
- **Environment**: Nix flakes for reproducible builds

## Quick Start

### Initial Setup
```bash
# Enter development shell
nix develop

# Initialize npm project
npm init -y

# Install MCP dependencies
npm install @modelcontextprotocol/sdk zod zod-validation-error

# Install dev dependencies
npm install -D typescript @types/node tsx vitest

# Create tsconfig.json (see TypeScript configuration below)

# Create project structure
mkdir -p src/{config,services,tools,types,utils}
```

### Development Workflow
```bash
npm run dev              # Run server in development mode
npm run build            # Compile TypeScript to JavaScript
npm run inspector        # Test with MCP Inspector
npm test                 # Run tests
```

## MCP Server Architecture

### Core Components
```
src/
├── index.ts                   # MCP server entry point
├── config/
│   ├── constants.ts          # Configuration constants
│   └── environment.ts        # Environment validation
├── services/
│   └── api-client.ts         # External API clients
├── tools/
│   └── example-tool.ts       # MCP tool definitions
├── types/
│   └── index.ts              # TypeScript interfaces
└── utils/
    └── helpers.ts            # Helper functions
```

### MCP Server Pattern
```typescript
#!/usr/bin/env node
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  ListToolsRequestSchema,
  CallToolRequestSchema
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server({
  name: "my-mcp-server",
  version: "1.0.0"
}, {
  capabilities: {
    tools: {}
  }
});

// Register tool list handler
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [/* array of tool definitions */]
}));

// Register tool call handler
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  // Handle tool execution
});

// Connect to stdio transport
const transport = new StdioServerTransport();
await server.connect(transport);
```

### Tool Definition Pattern
```typescript
import { z } from "zod";

const inputSchema = z.object({
  param1: z.string().describe("Description of param1"),
  param2: z.boolean().optional().default(false)
});

export class MyTool {
  getDefinition() {
    return {
      name: "my_tool",
      description: "Clear description of what this tool does",
      inputSchema: {
        type: "object",
        properties: {
          param1: {
            type: "string",
            description: "Description of param1"
          },
          param2: {
            type: "boolean",
            description: "Description of param2",
            default: false
          }
        },
        required: ["param1"]
      }
    };
  }

  async execute(args: unknown): Promise<any> {
    const input = inputSchema.parse(args);
    // Implementation here
    return result;
  }
}
```

## TypeScript Configuration

Create `tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "allowSyntheticDefaultImports": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

Create `package.json` scripts:
```json
{
  "type": "module",
  "main": "dist/index.js",
  "bin": {
    "my-mcp-server": "dist/index.js"
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsx src/index.ts",
    "test": "vitest",
    "inspector": "npx @modelcontextprotocol/inspector tsx src/index.ts"
  }
}
```

## MCP Best Practices

### Communication Protocol
- **Use stdio transport**: Standard for MCP servers
- **Log to stderr**: stdout is reserved for MCP protocol
- **Return structured JSON**: All tool responses must be valid JSON

### Error Handling
```typescript
// Good: Structured error with context
return {
  content: [{
    type: "text",
    text: `Error: ${error.message}`
  }],
  isError: true
};

// Bad: Throwing unhandled errors
throw new Error("Something went wrong");
```

### Input Validation
Always validate inputs with Zod:
```typescript
const inputSchema = z.object({
  file_path: z.string().min(1),
  options: z.object({
    format: z.enum(["json", "yaml"])
  }).optional()
});

// In execute method
const input = inputSchema.parse(args);
```

### Tool Design Principles
1. **Single Responsibility**: One tool, one purpose
2. **Clear Naming**: Use snake_case for tool names (e.g., `create_user`)
3. **Detailed Descriptions**: Help AI understand when to use the tool
4. **Type Everything**: Full TypeScript types + Zod schemas
5. **Handle Errors Gracefully**: Never let errors crash the server

## Testing with MCP Inspector

```bash
# Run MCP Inspector
npm run inspector

# Test tool execution in the Inspector UI
# - View available tools
# - Test with different inputs
# - See responses in real-time
```

## Environment Configuration

Use Zod for environment validation:
```typescript
import { z } from "zod";

const envSchema = z.object({
  API_KEY: z.string().min(1),
  DEBUG: z.enum(["true", "false"]).optional()
});

export function validateEnvironment() {
  const parsed = envSchema.parse(process.env);
  return {
    apiKey: parsed.API_KEY,
    debug: parsed.DEBUG === "true"
  };
}
```

## Code Conventions

### TypeScript
- Use ES module imports (`import/export`), NOT CommonJS
- Explicit return types for all functions
- Prefer interfaces over type aliases
- Use `.js` extensions in imports

### Error Messages
- Include context: `Failed to ${operation}: ${details}`
- User-friendly: Avoid technical jargon
- Actionable: Suggest how to fix

### File Organization
- `config/`: Constants and environment
- `services/`: External API clients
- `tools/`: MCP tool implementations
- `types/`: Shared TypeScript types
- `utils/`: Helper functions

## Debugging

### Common Issues
1. **"Module not found"**
   - Check `.js` extensions in imports
   - Verify `tsconfig.json` module settings

2. **"Cannot connect to server"**
   - Ensure using StdioServerTransport
   - Check no console.log (use console.error)

3. **"Tool not found"**
   - Verify tool registered in ListToolsRequestSchema
   - Check tool name matches exactly

### Debug Mode
```bash
DEBUG=* npm run dev  # Verbose MCP protocol logging
```

## Resources

### MCP Documentation
- [MCP Specification](https://modelcontextprotocol.io/docs)
- [MCP SDK TypeScript](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Inspector](https://github.com/modelcontextprotocol/inspector)

### TypeScript & Node.js
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Zod Documentation](https://zod.dev)
- [Node.js ES Modules](https://nodejs.org/api/esm.html)

## AI Development Guidelines

### AIDEV Anchors
Use `AIDEV-NOTE:`, `AIDEV-TODO:`, `AIDEV-QUESTION:` for developer notes:
- Keep concise (≤ 120 chars)
- Update when modifying code
- Preserve debugging context

**Examples:**
- `AIDEV-TODO: Add retry logic for API rate limits`
- `AIDEV-NOTE: Tool schema must match API exactly`

### Accountability
- Don't assume - verify with documentation
- Test changes before committing
- Ask when uncertain
