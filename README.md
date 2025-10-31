# fulfillmenttools-api-reference

Public api assets for the fulfillmenttools platform API

- [Open API Specification](api.swagger.yaml)
- [Technical Documentation](https://docs.fulfillmenttools.com)

## Generate API Client with OpenAPI Generator CLI

### 1. Install the OpenAPI Generator CLI
Install the CLI globally using `npm`. Alternatively, you can install it via other package managers (such as Homebrew) or download the standalone JAR file directly from Maven Central.

```bash
npm install @openapitools/openapi-generator-cli -g
```

### 2. Verify the installation
Confirm that the CLI is available and correctly installed by checking its version:
```bash
openapi-generator-cli version
```

### 3. Obtain the OpenAPI specification
Ensure you have the latest version of FFT’s `api.swagger.yaml` in your working directory. You can download it from [this link](https://github.com/fulfillmenttools/fulfillmenttools-api-reference/blob/master/api.swagger.yaml).

### 4. Generate the client (e.g. node / typescript)
Run the generator with your preferred target language. For example, to generate a TypeScript client using the Fetch API:
```bash
openapi-generator-cli generate -i api.swagger.yaml -g typescript-fetch -o ./generated/typescript-fetch
```


### 5. Use the client in a project (node / typescript)

1. Initialize a new node project
```bash
npm init -y
npm install typescript ts-node node-fetch @types/node
```

2. Compile and Integrate the Generated Client
- Copy the contents of the `generated/typescript-fetch` folder into your project (or ensure it's referenced properly).
- Add a tsconfig.json to configure TypeScript if not present:
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "esModuleInterop": true,
    "strict": true,
    "skipLibCheck": true
  },
  "include": ["./out/typescript-fetch", "./src"]
}
```
- Create a src folder for your own code.

3. Call an API endpoint
- Create a src/index.ts file and add an API
```typescript
import { Configuration, UserManagementCoreApi } from '../generated/typescript-fetch';

const config = new Configuration({
  basePath: 'https://<ocff-mytenant-tier>.api.fulfillmenttools.com'
});

const api = new UserManagementCoreApi(config);

async function run() {
  try {
    const result = await api.getAllUsers(); 
    console.log(result);
  } catch (error) {
    console.error('Request failed:', error);
  }
}

run();
```


4. Run the Code
```bash
npx ts-node src/index.ts
```

5. Build the Code
```bash
npx tsc
```
