import React from "react";
import clsx from "clsx";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";
import useBaseUrl from '@docusaurus/useBaseUrl'
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import styles from "./index.module.css";
import { ExampleScroller } from "../components/ExampleScroller";

import { HiLightningBolt } from "react-icons/hi";
import { IoColorPaletteSharp, IoAccessibility, IoInvertModeSharp, IoStatsChart, IoBowlingBallOutline } from "react-icons/io5";

function HomepageHeader() {
  return (
    <header className={clsx("container", styles.banner)}>
      <div className="container">
        <h2 className={styles.title} style={{ color: "var(--ifm-color-primary)" }}>
          Mutation, Validation, Abstraction
        </h2>
        <h2 className={styles.title} style={{ color: "var(--ifm-color-primary)" }}>
          Production-Ready
        </h2>
        <p className={styles.description}>
          KCL is an open-source constraint-based record & functional language mainly used in configuration and policy scenarios.
        </p>
        <Link
          className={clsx(
            "button button--primary button--lg",
            styles.button
          )}
          to="/docs/user_docs/getting-started/intro"
          style={{ marginRight: 10 }}
        >
          Learn More
        </Link>

        <Link
          className={clsx(
            "button button--secondary button--lg",
            styles.button
          )}
          to="/docs/user_docs/getting-started/install"
        >
          Download
        </Link>

        <br />
        <br />
      </div>
    </header>
  );
}

function FeaturesSection() {
  const features = [
    {
      title: "Easy-to-Use",
      description:
        `Originated from languages ​​such as Python and Golang, rich language features, IDEs and tools.`,
      icon: <IoAccessibility fontSize={30} color="var(--ifm-color-primary-dark)" />,
    },
    {
      title: "Quick Modeling",
      description:
        `
      Schema-centric configuration types and modular abstraction with logic and policy based on Config, Schema, Lambda, Rule.
  `,
      icon: <IoInvertModeSharp fontSize={30} color="var(--ifm-color-primary-dark)" />,
    },
    {
      title: "Stability",
      description:
        `
      Configuration stability built on static type system, strong immutablity , and constraints.
  `,
      icon: <IoBowlingBallOutline fontSize={30} color="var(--ifm-color-primary-dark)" />,
    },
    {
      title: "Scalability",
      description:
        `
      High scalability through automatic merge mechanism of isolated config blocks with multiple strategies.
  `,
      icon: <IoStatsChart fontSize={30} color="var(--ifm-color-primary-dark)" />,
    },
    {
      title: "Fast Automation",
      description:
        `
      High performance and
      gradient automation scheme of CRUD APIs, multilingual SDKs, language plugin.
  `,
      icon: <HiLightningBolt fontSize={30} color="var(--ifm-color-primary-dark)" />,
    },
    {
      title: "API Affinity",
      description:
        `
      Native support API ecological specifications such as OpenAPI, Kubernetes CRD, Kubernetes YAML spec.
  `,
      icon: <IoColorPaletteSharp fontSize={30} color="var(--ifm-color-primary-dark)" />,
    },
  ];

  const renderFeatureCards = (features) => {
    return features.map((feature, key) => (
      <div key={key} className="col col--4">
        <div className={clsx("card", styles.featureCard)}>
          <div className={clsx("card__header", styles.featureCardTitle)}>
            <div className={styles.featureCardIcon}>{feature.icon}</div>
            <h3 style={{ color: "var(--ifm-color-primary)" }}>{feature.title}</h3>
          </div>
          <div className={clsx("card__body", styles.featureCardBody)}>
            <p dangerouslySetInnerHTML={{ __html: feature.description }}></p>
          </div>
        </div>
      </div>
    ));
  };

  return (
    <section>
      <div className="container">
        <div className="row">{renderFeatureCards(features)}</div>
      </div>
    </section>
  );
}

function ExampleSection() {
  return <section><div className="container">
    <h2
      className={clsx(
        "text--center",
      )}
      style={{ color: "var(--ifm-color-primary)" }}
    >
      Codify and Manage Your Modern Configuration and Policy
    </h2>
    <p className={clsx(
      "text--center", styles.description
    )}>
      With configs, models, functions and rules
    </p>
    <ExampleScroller />
  </div></section>
}

function PartnerSection() {
  const partners = [
    {
      name: 'Ant Group',
      img: '/img/logos/antgroup.png',
      href: 'https://www.antgroup.com/'
    },
    {
      name: 'Youzan',
      img: '/img/logos/youzan.png',
      href: 'https://www.youzan.com/',
    },
    {
      name: 'Huawei',
      img: '/img/logos/huawei.png',
      href: 'https://www.huawei.com/',
    },
    {
      name: 'TuSimple',
      img: '/img/logos/tusimple.jpg',
      href: 'https://www.tusimple.com/',
    },
    {
      name: 'Kyligence',
      img: '/img/logos/kyligence.png',
      href: 'https://www.kyligence.io/',
    },
  ]

  return <section>
    <div className="container">
      <h2
        className={clsx(
          "text--center",
        )}
        style={{ color: "var(--ifm-color-primary)" }}
      >
        Trusted By
      </h2>
      <div className={styles.whiteboard}>
        <div className="row">
          {partners.map((w) => (
            <div key={w.name} className={clsx('col col--4', styles.whiteboardCol)}>
              <a className={styles.logoWrapper} href={w.href} target="_blank">
                <img src={useBaseUrl(w.img)} alt={w.name} />
              </a>
            </div>
          ))}
        </div>
      </div>
    </div>
  </section>
}

function BreakSection() {
  return <section><br /><br /></section>
}

export default function Home(): JSX.Element {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={`${siteConfig.title} - ${siteConfig.tagline}`}
      description="KCL is an open-source constraint-based record & functional language mainly used in configuration and policy scenarios."
    >
      <HomepageHeader />
      <BreakSection />
      <FeaturesSection />
      <BreakSection />
      <ExampleSection />
      <BreakSection />
      <PartnerSection />
      <BreakSection />
    </Layout>
  );
}
