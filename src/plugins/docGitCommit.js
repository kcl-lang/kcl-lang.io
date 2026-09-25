// Wraps @docusaurus/plugin-content-docs and attaches the last git commit of
// each doc source file to its metadata as `metadata.gitCommit`. The swizzled
// DocItem/Footer theme component renders it as a link next to the
// "Last updated on ... by ..." footnote. When git info is unavailable (e.g.
// Vercel shallow clones), the doc is silently left without `gitCommit`.

const { execFile } = require("child_process");
const { promisify } = require("util");

const execFileAsync = promisify(execFile);

const docsPluginModule = require("@docusaurus/plugin-content-docs");
const docsPlugin = docsPluginModule.default || docsPluginModule;

const commitUrlBase = "https://github.com/kcl-lang/kcl-lang.io/commit";
const gitConcurrency = 16;

async function getLastCommitHash(siteDir, source) {
  // doc.source is an aliased site path, e.g. "@site/docs/intro.md"
  const filePath = source.replace(/^@site\//, "");
  try {
    const { stdout } = await execFileAsync(
      "git",
      ["log", "-1", "--format=%H", "--", filePath],
      { cwd: siteDir },
    );
    const hash = stdout.trim();
    return hash || null;
  } catch (err) {
    return null;
  }
}

async function mapWithConcurrency(items, limit, fn) {
  let nextIndex = 0;
  const workers = Array.from({ length: limit }, async () => {
    while (nextIndex < items.length) {
      const item = items[nextIndex];
      nextIndex += 1;
      await fn(item);
    }
  });
  await Promise.all(workers);
}

async function docGitCommitPlugin(context, options) {
  const plugin = await docsPlugin(context, options);

  return {
    ...plugin,
    async loadContent() {
      const content = await plugin.loadContent();
      const allDocs = content.loadedVersions.flatMap((version) => version.docs);
      await mapWithConcurrency(allDocs, gitConcurrency, async (doc) => {
        const fullHash = await getLastCommitHash(context.siteDir, doc.source);
        if (fullHash) {
          doc.gitCommit = {
            short: fullHash.slice(0, 7),
            url: `${commitUrlBase}/${fullHash}`,
          };
        }
      });
      return content;
    },
  };
}

// Re-exported so plugin options are normalized with the same defaults as the
// original docs plugin.
docGitCommitPlugin.validateOptions = docsPluginModule.validateOptions;

module.exports = docGitCommitPlugin;
