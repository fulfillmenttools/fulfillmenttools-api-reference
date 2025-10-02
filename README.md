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

### 4. Generate the client (node / typescript)
Run the generator with your preferred target language. For example, to generate a TypeScript client using the Fetch API:
```bash
openapi-generator-cli generate -i api.swagger.yaml -g typescript-fetch -o ./out/typescript-fetch
```
