# `w-esy`

<br>

To depend on Dream using [esy](https://esy.sh/en/), we use a file `esy.json`.
It's a lot like
[`package.json`](https://docs.npmjs.com/cli/v7/configuring-npm/package-json),
and looks like this:

```json
{
  "dependencies": {
    "@opam/dream": "aantron/dream:dream.opam",
    "@opam/dune": "^2.0",
    "ocaml": "4.12.x"
  },
  "scripts": {
    "run": "dune exec --root . ./hello.exe"
  }
}
```

<br>

<pre><code><b>$ npm install esy && npx esy</b>
<b>$ npx esy start</b>
19.04.21 08:57:33.450                       Running on http://localhost:8080
19.04.21 08:57:33.450                       Press ENTER to stop
</code></pre>

The first time you run `npx esy`, it will take a few minutes installing OCaml
and all the native dependencies inside your project.

<br>

We download the `esy` binary from npm and run it using the
[`npx`](https://docs.npmjs.com/cli/v7/commands/npx) command. Another option is
to install esy globally on your system with

```
npx install -g esy
```

You can then use the `esy` command without the `npx` prefix.

<br>

If you need to run multiple build steps before `dune exec`, use
[`esy.build`](https://esy.sh/docs/en/configuration.html#esybuild). Here is an
example from [**`w-fullstack-jsoo`**](../w-fullstack-jsoo#files):

```json
"esy": {
  "buildsInSource": "_build",
  "build": [
    "dune build --root . client/client.bc.js",
    "mkdir -p static",
    "cp _build/default/client/client.bc.js static/client.js",
    "dune build --root . server/server.exe"
  ]
}
```

<br>

Many of the packages you can obtain with esy are hosted in
[opam](https://opam.ocaml.org/), the OCaml package repository. In esy, their
names are prefixed with `@opam`, like `@opam/dream`. You can search the packages
[here](https://opam.ocaml.org/packages/).

<br>

In addition to the files you see in this example, `npx esy` also generates a
directory called `esy.lock`. It's a set of lock files, similar to
`package-lock.json`. You should usually commit `esy.lock`. We left it out of
this example to keep it in sync with the Dream repo and its upstream projects.
But this deliberately gives up reproducible builds &mdash; something you
usually want for your own code.

If you'd like to find out the exact version of Dream esy installed, you can look
in `esy.lock/index.json`, or run `npx esy ls-builds`.

<br>

You can develop a JavaScript client side-by-side with the server as normal,
with npm or Yarn. Just add `package.json` like you normally would. You may want
to include `esy` itself as a *JavaScript* dependency, so that npm will not
uninstall it from your project:

```json
{
  "dependencies": {
    "esy": "*",
    "client": "normal_js_dependencies"
  }
}
```

You can make this even more powerful by writing the client itself in OCaml,
Reason, or ReScript &mdash; all flavors of OCaml that compile to JavaScript.
See the examples linked below.

<br>

**See also:**

- [**`w-fullstack-rescript`**](../w-fullstack-rescript#files) for full-stack
  development with ReScript.
- [**`r-fullstack-melange`**](../r-fullstack-melange#files) for full-stack
  development with Melange and Reason syntax.
- [**`w-fswatch`**](../w-fswatch#files) for a development watcher.
- [**`w-one-binary`**](../w-one-binary#files) for bundling assets into a
  self-contained binary.

<br>

[Up to the example index](../#examples)