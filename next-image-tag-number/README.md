# next-image-tag-number GitHub Action

The **next-image-tag-number** action calculates the next sequential tag for an image in an OCI repository. This is useful for tracking build numbers or versioning images in continuous integration workflows.

## Usage

Specify the OCI image repository URL in your workflow, along with optional parameters:

```yaml
jobs:
  next-tag:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Get Next Image Tag Number
        id: next-tag
        uses: codebandits/github-actions/next-image-tag-number@v1
        with:
          image_repository_url: registry.example.com/repository/image
          bearer_token: ${{ secrets.REPO_BEARER_TOKEN }}
          initial_number: 100
          tag_prefix: build-

      - run: echo "Next tag is ${{ steps.next-tag.outputs.tag }} with number ${{ steps.next-tag.outputs.number }}"
```

## Inputs

- `image_repository_url:` **Required.** The URL of the OCI-compatible image repository. If the protocol is omitted, https is assumed.
- `bearer_token:` Optional. The bearer token for repository authentication. Defaults to empty (no authentication).
- `initial_number:` Optional. Starting tag number if no tags exist in the repository. Defaults to 1.
- `tag_prefix:` Optional. Prefix for the tags. Defaults to build-.

## Outputs

- `tag:` The next tag, including the prefix and tag number.
- `number:` The next tag number.
