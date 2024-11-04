# load-env Github Action

The **load-env** action provides .env key-value pairs as outputs for use in workflows.

## Usage

Place a .env file in your repository (e.g. `/.env`):

```dotenv
TIMEOUT=30
```

Then, use **load-env** in your workflow to access these values:

```yaml
jobs:
  load-env:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Load Configuration
        id: configuration
        uses: codebandits/github-actions/load-env@main
        with:
          path: .env

      - run: echo "TIMEOUT is ${{ steps.configuration.outputs.TIMEOUT }}"
```
