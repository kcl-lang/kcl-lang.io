import React from "react";
import clsx from "clsx";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";
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

export default function Home(): JSX.Element {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={`${siteConfig.title} - ${siteConfig.tagline}`}
      description="KCL is an open-source constraint-based record & functional language mainly used in configuration and policy scenarios."
    >
      {/* <Head>
        <script async src="https://snack.expo.dev/embed.js"></script>
      </Head> */}
      <HomepageHeader />
      <br />
      <FeaturesSection />
      <br />
      <br />
      <div className="container">
        <ExampleScroller />
      </div>
      <br />
      <br />
    </Layout>
  );
}
