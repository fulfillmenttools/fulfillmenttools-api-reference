# fulfillmenttools-api-reference

Public api assets for the fulfillmenttools platform API

- [Open API Specification](api.swagger.yaml)
- [Technical Documentation](https://docs.fulfillmenttools.com)

## Generate API Client with HeyAPI OpenAPI Generator

### 1. Obtain the OpenAPI specification
Ensure you have the latest version of FFT’s `api.swagger.yaml` in your working directory. You can download it from [this link](https://github.com/fulfillmenttools/fulfillmenttools-api-reference/blob/master/api.swagger.yaml).

### 2. Generate the client (e.g. node / typescript)
Run the generator with your preferred target language. For example, to generate a TypeScript client using the Fetch API:
```bash
npx @hey-api/openapi-ts -i api.swagger.yaml -o src/client
```


### 3. Use the client in a project (node / typescript)

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
  "include": ["./src/client", "./src"]
}
```
- Create a src folder for your own code.

3. Call an API endpoint
- Create a src/index.ts file and add an API
```typescript
import { type ClientOptions, getAllUsers } from "./client";
import { createConfig } from "./client/client";
import { client } from "./client/client.gen";

client.setConfig(createConfig<ClientOptions>({
    baseUrl: 'https://<ocff-myTenant-tier>.api.fulfillmenttools.com'
}));

async function run() {
    try {
        const result = await getAllUsers();
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