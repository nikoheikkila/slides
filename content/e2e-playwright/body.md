# Effortless End-to-End Testing with Microsoft Playwright

{{% note %}}
- In this talk, I will explain how browser-based end-to-end testing has advanced a lot lately thanks to tools like **Cypress** and **Playwright**.
- Many of the _veterans_ have probably been using Robot Framework and Selenium a lot
- In many contexts, we can now ditch both for stable, fast, and enjoyable automated testing.
- It's of course up to you and your project, whether you should do this, but there's no excuses to stay in the _Seleniumland_ anymore if you don't want to.
{{% /note %}}

---

{{< slide template="blue" >}}

## We. Make. Tests. 🛠

{{% fragment %}}Unit tests{{% /fragment %}}
{{% fragment %}}Integration tests{{% /fragment %}}
{{% fragment %}}End-to-End tests (E2E){{% /fragment %}}

{{% note %}}
A reminder in case you wonder what the most typical tests are:

- **Unit tests:** low-level, but important building blocks, usually heavily mocked
- **Integration tests:** combining several smaller units together, most of the tests should be integration tests
- **End-to-End tests:** presenting a whole use flow often from the business perspective
{{% /note %}}

---

## What Really Are End-to-End Tests? 🤖

We can test...

{{% fragment %}}**Example 1:** registering for a service{{% /fragment %}}
{{% fragment %}}**Example 2:** sign in or out of a service{{% /fragment %}}
{{% fragment %}}**Example 3:** add products to basket and checkout the purchase{{% /fragment %}}

---

## Behaviour-Driven Development (BDD) 🤝

{{% fragment %}}
```gherkin
Feature: Calculator

  Scenario: “+” should add to current total.
    Given the current total is “5”.
    When I enter “7”.
    Then the current total should be “12”.
```
{{% /fragment %}}

{{% note %}}
- BDD goes hand-in-hand with E2E. The syntax in this slide is called gherkin, and it can be mapped to a real test conveniently.
- I'm a fan of BDD, and think we should be writing these specs a lot in early stages of development.
{{% /note %}}

---

...specs produce tests.

{{% fragment %}}
```js
describe('Calculator', () => {
    it('+ should add to current total', () => {
        initialTotal = 5
        number = 7
        
        click('.plus')
        fill('.input', number)
        click('.run')
        
        newTotal = $('.total').innerText
        expect(newTotal).toBe(initialTotal + number)
    })
})
```
{{% /fragment %}}

{{% note %}}
- The snippet above is pseudo-code for sake of simplicity.
- In short: we have an initial total, to which we add a number, and get a new total.
{{% /note %}}

---

{{< slide template="blue" >}}

If it's so simple, why the lack of tests?

{{% note %}}
- I've seen a lot of projects with zero unit, integration, and E2E tests.
- Budget or time is not a good excuse.
- Due to bad technical decisions, many developers treat especially E2E tests as a lesser priority.
{{% /note %}}

---

## It Doesn't Have to Hurt! 🤕

What happens when tests are…

{{% fragment %}}Unstable?{{% /fragment %}}
{{% fragment %}}Slow to execute?{{% /fragment %}}
{{% fragment %}}Difficult to write?{{% /fragment %}}
{{% fragment %}}Painful to maintain?{{% /fragment %}}

{{% note %}}
- Unstable tests fail most of the time.
- Slow tests running for several hours harm productivity by lengthening the feedback loop.
- Difficult test API equals unreadable tests.
- The above adds up to maintenance burden -> tests are forsaken.
{{% /note %}}

---

{{< slide template="green" >}}

You likely don't run or maintain them. 😭

---

Different teams produce _different_ tests. ⚔️

![Tests by team](https://f001.backblazeb2.com/file/nikoheikkila-fi/DevQATests.png)

{{% note %}}
- In some organizations, developers and QA regularly work in siloes and produce two very different test suites.
- Developers focus on low-hanging fruits testing the code they've written.
- QA is responsible for ensuring the features work from the business perspective.
{{% /note %}}

---

{{< slide template="blue" >}}

## How Playwright Solves the Issues?

{{% note %}}
- I'm going to focus on Playwright by Microsoft. Keep in mind that Cypress is another popular testing tool and most of the good sides apply to it as well.
- I prefer Playwright due to its speed, ease of use, extendability, and maintainability.
- Playwright heals most of the issues we typically face when maintaining E2E test suite.
{{% /note %}}

---

### Speed and Stability Matter

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
- Page actions return Promises which you can await one-by-one or through `Promise.all()`.
- Automatically wait for the target element to become _actionable_.
- For example, buttons are not clicked until they become visible and enabled.
{{% /note %}}

---

### Support for Modern Languages

{{% fragment %}}Benefit from all the features of **TypeScript**{{% /fragment %}}
{{% fragment %}}Set breakpoints and debug in VS Code{{% /fragment %}}
{{% fragment %}}Support for **Python**, **C#**, and **Go** languages are in preview{{% /fragment %}}

{{% note %}}
- Remember to use recent enough version of Node.js and configure `tsconfig.json` correctly.
- There's a package `jest-playwright` which takes most of the boilerplate off from writing Playwright code.
- Languages other than JS/TS are not considered production-ready yet, but fine for experiments and proof-of-concepts.
- Pick your language of choice for writing tests.
{{% /note %}}

---

### Extend How You See Fit

{{% fragment %}}Use any assertion library (eg. `assert`, `chai`, or `expect`){{% /fragment %}}
{{% fragment %}}Use any test runner (for now _Jest_ is recommended){{% /fragment %}}
{{% fragment %}}Import 3rd party NPM modules{{% /fragment %}}

{{% note %}}
- Import 3rd party NPM modules to your tests.
- For example, `faker.js` is nice when having to test form validation.
{{% /note %}}

---

### Easy Maintenance

{{% fragment %}}
The earlier login example becomes...
{{% /fragment %}}

{{% fragment %}}
```js
const loginPage = new LoginPage(page);
loginPage.fillCredentials(user)
loginPage.login();
```
{{% /fragment %}}

{{% note %}}
- Tests contain a lot of repeated actions, which can be abstracted to common methods.
- POM is just an ordinary class wrapping a `Page` object.
{{% /note %}}

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

{{% note %}}
- The end result is more readable and maintainable.
- Note the `Promise.all()` wrap has been removed for the sake of simplicity – can be used here too, though!
{{% /note %}}

---

### Support for Docker Execution

{{% fragment %}}
Simple example 👇🏼

```dockerfile
FROM mcr.microsoft.com/playwright:bionic

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile
COPY . .

CMD ['yarn', 'test:e2e']
```
{{% /fragment %}}

{{% note %}}
- There is also CI support for Travis, Jenkins, Circle CI, GitHub Actions, etc.
- Docker makes your scripts portable in case you don't want or can't install NPM packages.
{{% /note %}}

---

### Generate Code by Recording Browser Actions

{{% fragment %}}
```bash
npx playwright-cli codegen https://futurice.com -o test.js
```

👆🏼 The URL should be accessible from the network you're running the test!
{{% /fragment %}}

{{% note %}}
- We are saving the generated output to file _test.js_ for easier inspection.
- You can also open the recording in other browsers than Chromium using the `-b <BROWSER>` option.
{{% /note %}}

---

{{< slide template="green" >}}

## Demo

Let's record a new test from command-line.

---

{{< slide content="snippets.thanks" >}}
