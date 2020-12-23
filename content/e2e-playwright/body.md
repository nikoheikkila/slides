## Effortless End-to-End Testing with Microsoft Playwright

{{% note %}}

- hello

{{% /note %}}

Niko Heikkilä – 8.1.2020

---

### It Doesn't Have to Hurt

---

![Tests by team](https://f001.backblazeb2.com/file/nikoheikkila-fi/DevQATests.png)

---

## How Playwright Solves The Issues?

---

### Fast execution of browser interactions through _asynchronous_ methods

{{% fragment %}}perform multiple actions concurrently{{% /fragment %}}

{{% fragment %}}

```js
// wait for inputs to be filled with Promise.all() or Promise.allSettled()
await Promise.all([
    page.fill('[data-test-id=username]', username),
    page.fill('[data-test-id=password]', password),
]);

// Executed last
await page.click('[data-test-id=login]');
```

{{% /fragment %}}

---

### Write tests in modern **JavaScript** or **TypeScript**

- {{% fragment %}}use recent enough version of Node.js{{% /fragment %}}
- {{% fragment %}}use any assertion library (eg. `assert`, `chai`, or `expect`){{% /fragment %}}
- {{% fragment %}}use any test runner (for now _Jest_ is recommended){{% /fragment %}}
- {{% fragment %}}support for **Python**, **C#**, and **Go** languages are in preview{{% /fragment %}}

---

{{% section %}}

### Maintain large test suites easily with Page Object Models

---

The earlier login example becomes:

```js
const loginPage = new LoginPage(page);
loginPage.fillCredentials(user)
loginPage.login();
```

---

### Abstraction Layer

```ts
class LoginPage() {
    constructor(page: Page) {
        this.page = page;
    }

    async fillCredentials(user: User) {
        await this.page.fill('[data-test-id=username]', user.name);
        await this.page.fill('[data-test-id=password]', user.password);
    }

    async login() {
        await this.page.click('[data-test-id=login]');
    }
}
```

{{% /section %}}

---

### Record new tests instead of writing from scratch

{{% fragment %}}

```bash
npx playwright-cli codegen $URL
```

`$URL` should be accessible from the network you're running the test.

{{% /fragment %}}

---

### Provides stable results due to the auto-waiting feature

- {{% fragment %}}operations automatically wait until the target element is actionable{{% /fragment %}}
- {{% fragment %}}use the `async/await` pattern in code{{% /fragment %}}

---

### Support for **Continuous Integration (CI)** and **Docker** execution

{{% fragment %}}
Naive example 👇🏼

```dockerfile
FROM mcr.microsoft.com/playwright:bionic

COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile

CMD ['yarn', 'test:e2e']
```

{{% /fragment %}}

---

### Work It Together

---

## DEMO #1

Basic tests for a React SPA.

---

## DEMO #2

Recording new tests.

---

{{< slide content="snippets.thanks" >}}
