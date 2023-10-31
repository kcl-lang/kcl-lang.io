// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');
const math = require('remark-math');
const katex = require('rehype-katex');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'KCL programming language.',
  tagline: 'Mutation  Validation  Abstraction  Production-Ready',

  url: 'https://kcl-lang.github.io',
  organizationName: 'kcl-lang', // Usually your GitHub org/user name.
  projectName: 'kcl', // Usually your repo name.

  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'favicon.ico',

  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'zh-CN'],
    localeConfigs: {
      en: {
        label: 'English',
      },
      "zh-CN": {
        label: '简体中文',
      },
    },
  },
  scripts: [],

  customFields: {
    tagDescription: 'KCL is an open-source constraint-based record & functional language mainly used in configuration and policy scenarios.',
    hero: {
      description: "KCL is an open-source constraint-based record & functional language mainly used in configuration and policy scenarios.",
      buttons: {
        first: {
          url: "docs/user_docs/intro/kcl-intro",
          text: "Learn More",
        },
        second: {
          url: "docs/user_docs/getting-started/",
          text: "Get Started",
        },
      },
    },
    sections: {
      features: {
        title: "Why KCL?",
        featureList: [
          {
            title: 'Easy-to-Use',
            imageUrl: 'img/microsite/reasons/extensible.svg',
            description: `
                Originated from programming languages ​​such as Python and Golang, rich language features, power IDEs and tools.
            `,
          },
          {
            title: 'Quick Modeling',
            imageUrl: 'img/microsite/reasons/single-entrypoint.svg',
            description: `
                Schema-centric configuration types and modular abstraction.
                Configuration with type, logic and policy based on Config, Schema, Lambda, Rule.
            `,
          },
          {
            title: 'Stability',
            imageUrl: 'img/microsite/reasons/extensible.svg',
            description: `
                Configuration stability built on static type system, constraints, and rules.
            `,
          },
          {
            title: 'Scalability',
            imageUrl: 'img/microsite/reasons/single-entrypoint.svg',
            description: `
                High scalability through automatic merge mechanism of isolated config blocks.
            `,
          },
          {
            title: 'Fast Automation',
            imageUrl: 'img/microsite/reasons/user-experience.svg',
            description: `
                High compile time and runtime performance.
                Gradient automation scheme of CRUD APIs, multilingual SDKs, language plugins for GitOps.
            `,
          },
          {
            title: 'API Affinity',
            imageUrl: 'img/microsite/reasons/file.svg',
            description: `
                Native support API ecological specifications such as OpenAPI, Kubernetes CRD and KRM spec.
            `,
          },
        ],
      },
      consolidation: {
        snippets: [
          `
            Stop putting your team through an endless stream of high-friction tools and user interfaces.
            Clutch allows you to combine many tools into one, in the form that your developers use most.
          `,
          `
            We grow with you. Clutches extensible platform means you can integrate as many tools as
            you need, even if they are specific to you.
          `,
        ]
      }
    },
  },

  presets: [
    [
      '@docusaurus/preset-classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          // default version: Next
          // lastVersion: 'current',

          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/kcl-lang/kcl-lang.io/tree/main',
          showLastUpdateAuthor: true,
          showLastUpdateTime: true,
          remarkPlugins: [math],
          rehypePlugins: [katex],
        },
        blog: {
          blogSidebarCount: "ALL",
          postsPerPage: 2,
          showReadingTime: true,
          editUrl: 'https://github.com/kcl-lang/kcl-lang.io/tree/main',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],
  stylesheets: [
    {
      href: 'https://cdn.jsdelivr.net/npm/katex@0.13.24/dist/katex.min.css',
      type: 'text/css',
      integrity:
        'sha384-odtC+0UGzzFL/6PNoE8rX/SPcQDXBJ+uRepguP4QkPCm2LBxH3FA3y+fKSiJ+AmM',
      crossorigin: 'anonymous',
    },
  ],
  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      // hideableSidebar: true,
      announcementBar: {
        id: 'announcementBar-1', // Increment on change
        content: `Give us a star ⭐️ - If you are using KCL or think it is an interesting project, we would love a star and record on <a target="_blank" rel="noopener noreferrer" href="https://github.com/kcl-lang/kcl">Github</a> and <a target="_blank" rel="noopener noreferrer" href="https://github.com/kcl-lang/kcl/issues/578">Record Issue</a>`,
      },

      algolia: {
        appId: 'I3BKOKGSD5',
        apiKey: '20af56a3665effe7fa744b4b6cf78d60',
        indexName: 'kcl-lang',
        contextualSearch: true,
      },
      navbar: {
        title: 'KCL',
        logo: {
          alt: 'KCL Logo',
          src: 'img/kcl-logo.png',
        },
        items: [
          {
            type: 'docSidebar',
            docId: 'intro/kcl-intro',
            position: 'left',
            sidebarId: 'user_docs',
            label: 'UserDoc',
          },
          {
            type: 'docSidebar',
            position: 'left',
            sidebarId: 'reference',
            label: 'Reference',
          },
          {
            type: 'docSidebar',
            position: 'left',
            sidebarId: 'tools',
            label: 'Tools',
          },
          {
            href: 'https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1',
            position: 'left',
            sidebarId: 'packages',
            label: 'Packages',
          },
          {
            href: 'http://play.kcl-lang.io/',
            position: 'left',
            sidebarId: 'playground',
            label: 'Playground',
          },
          {
            href: 'https://github.com/kcl-lang/examples',
            position: 'left',
            sidebarId: 'examples',
            label: 'Examples',
          },
          {
            type: 'docSidebar',
            position: 'left',
            sidebarId: 'community',
            label: 'Community',
          },

          { to: '/blog', label: 'Blog', position: 'left' },
          {
            type: 'docsVersionDropdown',
            position: 'right',
            dropdownActiveClassDisabled: true
          },
          {
            type: 'localeDropdown',
            position: 'right',
            dropdownItemsAfter: [
              {
                href: 'https://github.com/kcl-lang/kcl-lang.io/issues/',
                label: 'Help Us Translate',
              },
            ],
          },
          {
            href: 'https://github.com/kcl-lang/kcl',
            className: 'header-github-link',
            'aria-label': 'GitHub repository',
            position: 'right',
          },
        ].filter(item => true),
      },
      footer: {
        links: [
          {
            title: 'Document',
            items: [
              {
                label: 'Introduction',
                to: '/docs/user_docs/getting-started/intro',
              },
              {
                label: 'User Guide',
                to: '/docs/user_docs/guides',
              },
              {
                label: 'Tutorial',
                to: '/docs/reference/lang/tour',
              },
              {
                label: 'FAQ',
                to: '/docs/user_docs/support',
              },
            ],
          },
          {
            title: 'Resource',
            items: [
              {
                label: 'Github',
                href: 'https://github.com/kcl-lang/kcl',
              },
              {
                label: 'Gitee',
                href: 'https://gitee.com/kusionstack/kcl',
              },
              {
                label: 'Blog',
                to: '/blog',
              },
              {
                label: 'Community',
                href: '/docs/community/intro',
              },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'KusionStack',
                href: 'https://kusionstack.io',
              },
            ],
          },
        ],
        copyright: `
          <br />
          <br />
          <strong>© KCL Authors ${new Date().getFullYear()} | Documentation Distributed under <a href="https://creativecommons.org/licenses/by/4.0">CC-BY-4.0</a> </strong> 
          <br />
          <br />
          © ${new Date().getFullYear()} The Linux Foundation. All rights reserved. The Linux Foundation has registered trademarks and uses trademarks. For a list of trademarks of The Linux Foundation, please see our <a href="https://www.linuxfoundation.org/trademark-usage/"> Trademark Usage</a> page.
        `,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
      docs: {
        sidebar: {
          autoCollapseCategories: true
        }
      }
    }),
  plugins: [
    [
      '@docusaurus/plugin-google-gtag',
      {
        trackingID: 'G-MZD1X1PB2Q',
        anonymizeIP: true,
      },
    ],
    async function myPlugin(context, options) {
      return {
        name: "docusaurus-tailwindcss",
        configurePostCss(postcssOptions) {
          // Appends TailwindCSS and AutoPrefixer.
          postcssOptions.plugins.push(require("tailwindcss"));
          postcssOptions.plugins.push(require("autoprefixer"));
          return postcssOptions;
        },
      };
    },
  ],
};

module.exports = config;
