# fulfillmenttools-api-reference

Public api assets for the fulfillmenttools platform API

- [Open API Specification](api.swagger.yaml)
- [Technical Documentation](https://docs.fulfillmenttools.com)

## Generate API Client with HeyAPI OpenAPI Generator

### 1. Obtain the OpenAPI specification
Ensure you have the latest version of FFT’s `api.swagger.yaml` in your working directory. You can download it from [this link](https://raw.githubusercontent.com/fulfillmenttools/fulfillmenttools-api-reference/refs/heads/master/api.swagger.yaml).
```bash
wget https://raw.githubusercontent.com/fulfillmenttools/fulfillmenttools-api-reference/refs/heads/master/api.swagger.yaml
```



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
- Copy the `src/client` folder into your project
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

3. Call an API endpoint
- Create a src/index.ts file and replace placeholders with your tenant information
```typescript
import { type ClientOptions, getAllUsers } from "./client";
import { createConfig } from "./client/client";
import { client } from "./client/client.gen";

client.setConfig(createConfig<ClientOptions>({
    baseUrl: 'https://ocff-<tenant>-<tier>.api.fulfillmenttools.com'
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

5. Sample implementation for authentication with Firebase token

In this example, we use axios to obtain a Firebase token using email and password authentication.
```typescript
import axios from "axios";

export interface FirebaseToken {
    idToken: string;
    expiresIn: number;
}

export interface Token {
    token: string;
    expiryDate: Date;
}

export async function getFirebaseToken(options: {
    email: string,
    password: string,
    firebaseWebApiKey: string
}): Promise<Token> {
    try {
        const token = await axios.post<FirebaseToken>(
            `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${options.firebaseWebApiKey}`,
            {
                email: options.email,
                password: options.password,
                returnSecureToken: true,
            },
            {
                headers: {
                    Accept: `application/json`,
                    'Content-Type': `application/json`,
                },
            }
        );

        const expiryDate = new Date(Date.now() + 1000 * (token.data.expiresIn - 300));

        return {
            token: token.data.idToken,
            expiryDate: expiryDate,
        };
    } catch (e) {
        //@ts-ignore
        console.error(e.response.data);
        throw Error(`Error obtaining firebase token, please check credentials.`);
    }
}

let firebaseToken: Token | undefined;
let isTokenFetching = false;

async function checkToken() {
    if (!firebaseToken || firebaseToken.expiryDate < Date.now()) {
        if (!isTokenFetching) {
            isTokenFetching = true;
            const firebaseToken = await getFirebaseToken({
                email: '<myUsername>@ocff-<myTenant>-<tier>.com',
                password: '<myPassword>',
                firebaseWebApiKey: '<myFirebaseWebApiKey>'
            });
            config.headers.set('Authorization', `Bearer ${firebaseToken?.token}`);
            isTokenFetching = false;
        } else {
            // wait for the token to be fetched
            while (isTokenFetching) {
                await new Promise(resolve => setTimeout(resolve, 100));
            }
        }
    }
}
```

Now we can use this function to get a token and set it as header in our API calls if necessary.
```typescript
async function run() {
    try {
        checkToken();
        const result = await getAllUsers();
        console.log(result);
    } catch (error) {
        console.error('Request failed:', error);
    }
}
```