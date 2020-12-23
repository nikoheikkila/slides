# Effortless End-to-End Testing with Microsoft Playwright

{{% note %}}
In this talk, I will explain how browser-based end-to-end testing has advanced a lot lately thanks to tools like **Cypress** and **Playwright**.

In many contexts, we can now ditch the Robot Framework and Selenium entirely for stable, fast, and enjoyable automated testing.

It's of course up to you and your project, whether you should do this, but there's no excuses to stay in the _Seleniumland_ anymore if you don't want to.
{{% /note %}}

---

## We. Make. Tests. 🛠

{{% fragment %}}Unit tests{{% /fragment %}}
{{% fragment %}}Integration tests{{% /fragment %}}
{{% fragment %}}End-to-end tests{{% /fragment %}}

{{% note %}}
A reminder in case you wonder what the most typical tests are:

- **Unit tests:** low-level but important building blocks
- **Integration tests:** combining several smaller features together
- **End-to-end tests:** presenting a whole use flow often from the business perspective
{{% /note %}}

---

## It Doesn't Have to Hurt 🤕

What happens when tests are…

{{% fragment %}}unstable?{{% /fragment %}}
{{% fragment %}}slow to execute?{{% /fragment %}}
{{% fragment %}}difficult to write?{{% /fragment %}}
{{% fragment %}}painful to maintain?{{% /fragment %}}

{{% note %}}
- unstable tests harm by being unreliable
- slow tests harm by lengthening the feedback loop
- difficult test API equals unreadable tests
- the above add up to maintenance -> tests are forsaken
{{% /note %}}

---

You likely don't run or maintain them. 😭

---

Different teams produce _different_ tests. ⚔️

{{% fragment %}}
![Tests by team](https://f001.backblazeb2.com/file/nikoheikkila-fi/DevQATests.png)
{{% /fragment %}}

{{% note %}}
In some organizations, developers and QA regularly work in siloes and produce two very different test suites.

Developers focus on low-hanging fruits testing the code they've written while QA is responsible for ensuring the features work from the business perspective.
{{% /note %}}

---

## How Playwright Solves the Issues?

{{% note %}}
I'm going to focus on Playwright by Microsoft. Keep in mind that Cypress is another popular testing tool and most of the good sides apply to it as well.
{{% /note %}}

---

### Fast Execution of Browser Interactions through Asynchronous Methods

{{% fragment %}}Perform multiple actions concurrently – never `sleep` again.{{% /fragment %}}

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

{{% note %}}
`page` object methods return Promises which you can await one-by-one or through `Promise.all()`.
{{% /note %}}

---

### Write Tests in Modern Language Syntax

{{% fragment %}}benefit from all the features of **TypeScript**{{% /fragment %}}
{{% fragment %}}use any assertion library (eg. `assert`, `chai`, or `expect`){{% /fragment %}}
{{% fragment %}}use any test runner (for now _Jest_ is recommended){{% /fragment %}}
{{% fragment %}}support for **Python**, **C#**, and **Go** languages are in preview{{% /fragment %}}

{{% note %}}
- remember to use recent enough version of Node.js and configure `tsconfig.json` correctly
- AVA test runner's parallel runs might cause issues with shared page objects
- languages other than JS/TS are not considered production-ready yet, but fine for experiments and proof-of-concepts
{{% /note %}}

---

### Maintain Large Test Suites Easily with Page Object Models

{{% fragment %}}
The earlier login example becomes…
{{% /fragment %}}

{{% fragment %}}
```js
const loginPage = new LoginPage(page);
loginPage.fillCredentials(user)
loginPage.login();
```
{{% /fragment %}}

---

### Abstraction Layer (POM)

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

---

### Record New Tests Instead of Writing From Scratch

{{% fragment %}}
```bash
npx playwright-cli codegen https://futurice.com | tee -a test.js
```
{{% /fragment %}}

{{% fragment %}}👆🏼 The URL should be accessible from the network you're running the test!{{% /fragment %}}

{{% note %}}
Here the command `tee -a` outputs to both _STDOUT_ and file `test.js` for easier capture.
{{% /note %}}

---

### Provides Stable Results Due to the Auto-Waiting Mechanism

{{% fragment %}}operations automatically wait until the target element is actionable{{% /fragment %}}
{{% fragment %}}use the `async/await` pattern in code{{% /fragment %}}

---

### Support for Continuous Integration and Docker Execution

Naive example 👇🏼

{{% fragment %}}
```dockerfile
FROM mcr.microsoft.com/playwright:bionic

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile
COPY . .

CMD ['yarn', 'test:e2e']
```
{{% /fragment %}}

---

## Demo #1

Example tests for a React SPA.

{{% note %}}
Redacted due to NDA material.
{{% /note %}}

---

## Demo #2

Recording new tests.

{{% note %}}
We'll use the code generation feature of `playwright-cli` while doing simple operations on a webpage.
{{% /note %}}

---

{{< slide content="snippets.thanks" >}}
