# set-imgpkg-bundle-as-vendir-path GitHub Action

The **set-imgpkg-bundle-as-vendir-path** action sets an [imgpkg](https://carvel.dev/imgpkg/) bundle image as a [vendir](https://carvel.dev/vendir/) path. This is useful for managing environment promotion and release management via GitOps.

## Usage

This action sets a directory under the top-level `channels` directory in `vendir.yml` to a specified imgpkg bundle image. If `vendir.yml` does not exist, it will be created. The action ensures that the `channels` directory is always the first top-level directory in `vendir.yml` so that other configurations can reference it as needed.

Given a vendir.yml structured like this:

```yaml
# vendir.yml
apiVersion: vendir.k14s.io/v1alpha1
kind: Config
directories:
  - path: channels
    contents:
      - path: latest
        imgpkgBundle:
          image: registry.example.com/repository/bundle:build-1
  - path: environments
    contents:
      - path: development
        directory:
          path: channels/latest
```

The following job will update the `imgpkgBundle` for channels/latest to use the `build-2` tag:

```yaml
jobs:
  update-vendir:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Update latest release channel
        uses: codebandits/github-actions/set-imgpkg-bundle-as-vendir-path@v1
        with:
          channel_name: latest
          imgpkg_bundle_image: registry.example.com/repository/bundle:build-2
          bearer_token: ${{ secrets.SOME_BEARER_TOKEN }}
```

## Inputs

- `channel_name`: **Required**. The path under the channels directory in vendir.yml to update.
- `imgpkg_bundle_image`: **Required**. The published imgpkg bundle image.
- `bearer_token`: Optional. The bearer token for authentication with the registry. Defaults to empty (no authentication).
- `path`: Optional. The base directory path where vendir.yml is located. Defaults to `.` (current directory).

## Outputs

This action does not define any outputs.
