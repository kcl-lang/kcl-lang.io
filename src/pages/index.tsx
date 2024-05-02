import React from "react";
import clsx from "clsx";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";
import useBaseUrl from "@docusaurus/useBaseUrl";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import styles from "./index.module.css";
import { ExampleScroller } from "../components/ExampleScroller";
import Translate from "@docusaurus/Translate";

import { HiLightningBolt } from "react-icons/hi";
import {
  IoColorPaletteSharp,
  IoAccessibility,
  IoInvertModeSharp,
  IoStatsChart,
  IoBowlingBallOutline,
} from "react-icons/io5";
import { Form } from "../components/Form";

function HomepageHeader() {
  return (
    <header className={clsx("container", styles.banner)}>
      <div className="container">
        <h2
          className={styles.title}
          style={{ color: "var(--ifm-color-primary)" }}
        >
          <Translate>Mutation</Translate>, &nbsp;
          <Translate>Validation</Translate>, &nbsp;
          <Translate>Abstraction</Translate>
        </h2>
        <h2
          className={styles.title}
          style={{ color: "var(--ifm-color-primary)" }}
        >
          <Translate>Production-Ready</Translate>
        </h2>
        <p className={styles.description}>
          <Translate>
            KCL is an open-source constraint-based record & functional language
            mainly used in configuration and policy scenarios.
          </Translate>
        </p>

        <Link
          className={clsx("button button--primary button--lg", styles.button)}
          to="/docs/user_docs/getting-started/intro"
          style={{ marginRight: 10 }}
        >
          <Translate>Learn More</Translate>
        </Link>

        <Link
          className={clsx("button button--secondary button--lg", styles.button)}
          to="/docs/user_docs/getting-started/install"
        >
          <Translate>Download</Translate>
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
      title: <Translate>Easy-to-Use</Translate>,
      description: (
        <Translate>
          Originated from programming languages ​​such as Python and Golang,
          rich language features, power IDEs and tools.
        </Translate>
      ),
      icon: (
        <IoAccessibility fontSize={30} color="var(--ifm-color-primary-dark)" />
      ),
    },
    {
      title: <Translate>Quick Modeling</Translate>,
      description: (
        <Translate>
          Schema-centric configuration types and modular abstraction with logic
          and policy based on Config, Schema, Lambda, Rule.
        </Translate>
      ),
      icon: (
        <IoInvertModeSharp
          fontSize={30}
          color="var(--ifm-color-primary-dark)"
        />
      ),
    },
    {
      title: <Translate>Stability</Translate>,
      description: (
        <Translate>
          Configuration stability built on static type system, strong
          immutablity , and constraints.
        </Translate>
      ),
      icon: (
        <IoBowlingBallOutline
          fontSize={30}
          color="var(--ifm-color-primary-dark)"
        />
      ),
    },
    {
      title: <Translate>Scalability</Translate>,
      description: (
        <Translate>
          High scalability through automatic merge mechanism of isolated config
          blocks with multiple strategies.
        </Translate>
      ),
      icon: (
        <IoStatsChart fontSize={30} color="var(--ifm-color-primary-dark)" />
      ),
    },
    {
      title: <Translate>Fast Automation</Translate>,
      description: (
        <Translate>
          High performance and gradient automation scheme of CRUD APIs,
          multilingual SDKs, language plugins for GitOps.
        </Translate>
      ),
      icon: (
        <HiLightningBolt fontSize={30} color="var(--ifm-color-primary-dark)" />
      ),
    },
    {
      title: <Translate>API Affinity</Translate>,
      description: (
        <Translate>
          Native support API ecological specifications such as OpenAPI,
          Kubernetes CRD and KRM spec.
        </Translate>
      ),
      icon: (
        <IoColorPaletteSharp
          fontSize={30}
          color="var(--ifm-color-primary-dark)"
        />
      ),
    },
  ];

  const renderFeatureCards = (features) => {
    return features.map((feature, key) => (
      <div key={key} className="col col--4">
        <div className={clsx("card", styles.featureCard)}>
          <div className={clsx("card__header", styles.featureCardTitle)}>
            <div className={styles.featureCardIcon}>{feature.icon}</div>
            <h3 style={{ color: "var(--ifm-color-primary)" }}>
              {feature.title}
            </h3>
          </div>
          <div className={clsx("card__body", styles.featureCardBody)}>
            <p>{feature.description}</p>
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
  return (
    <section>
      <div className="container">
        <h2
          className={clsx("text--center")}
          style={{ color: "var(--ifm-color-primary)" }}
        >
          <Translate>
            Codify and Manage Your Modern Configuration and Policy
          </Translate>
        </h2>
        <p className={clsx("text--center", styles.description)}>
          <Translate>With configs, models, functions and rules</Translate>
        </p>
        <ExampleScroller />
      </div>
    </section>
  );
}

function ToolSection() {
  return (
    <section>
      <div className="container">
        <div className="container text--center">
          <h2
            className={clsx("text--center")}
            style={{ color: "var(--ifm-color-primary)" }}
          >
            <Translate>Tools for Experience</Translate>
          </h2>
          <p className={clsx("text--center", styles.description)}>
            <Translate>
              IDEs, SDKs, Sharing, Formatting, Testing, Documents
            </Translate>
          </p>

          <div className={styles.imageContainer}>
            <img
              className={styles.toolLogo}
              alt="Tool image"
              src="/img/registry-and-ide.png"
            />
          </div>
        </div>
      </div>
    </section>
  );
}

function IntegrationSection() {
  const integrations = [
    {
      name: "Kubernetes",
      img: "/img/logos/k8s.svg",
    },
    {
      name: "Kustomize",
      img: "/img/logos/kustomize.png",
    },
    {
      name: "Helm",
      img: "/img/logos/helm.png",
    },
    {
      name: "Helmfile",
      img: "/img/logos/helmfile.png",
    },
    {
      name: "KPT",
      img: "/img/logos/kpt.png",
    },
    {
      name: "Argo",
      img: "/img/logos/argo.png",
    },
    {
      name: "Flux",
      img: "/img/logos/flux.png",
    },
    {
      name: "Ansible",
      img: "/img/logos/ansible.png",
    },
    {
      name: "KusionStack",
      img: "/img/logos/kusionstack.png",
    },
    {
      name: "KubeVela",
      img: "/img/logos/kubevela.png",
    },
    {
      name: "CrossPlane",
      img: "/img/logos/crossplane.png",
    },
    {
      name: "Terraform",
      img: "/img/logos/terraform.png",
    },
  ];

  return (
    <section>
      <div className="container">
        <h2
          className={clsx("text--center")}
          style={{ color: "var(--ifm-color-primary)" }}
        >
          <Translate>Integrate with Your Favorite Projects</Translate>
        </h2>
        <div className={styles.whiteboard}>
          <div className="row">
            {integrations.map((w) => (
              <div
                key={w.name}
                className={clsx("col col--3", styles.whiteboardCol)}
              >
                <a className={styles.integrationLogoWrapper} target="_blank">
                  <img src={useBaseUrl(w.img)} alt={w.name} />
                </a>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

function PartnerSection() {
  const partners = [
    {
      name: "Ant Group",
      img: "/img/logos/antgroup.png",
      href: "https://www.antgroup.com/",
    },
    {
      name: "Youzan",
      img: "/img/logos/youzan.png",
      href: "https://www.youzan.com/",
    },
    {
      name: "Huawei",
      img: "/img/logos/huawei.png",
      href: "https://www.huawei.com/",
    },
    {
      name: "Kyligence",
      img: "/img/logos/kyligence.png",
      href: "https://www.kyligence.io/",
    },
  ];

  return (
    <section>
      <div className="container">
        <h2
          className={clsx("text--center")}
          style={{ color: "var(--ifm-color-primary)" }}
        >
          <Translate>Trusted By</Translate>
        </h2>
        <div className={styles.whiteboard}>
          <div className="row">
            {partners.map((w) => (
              <div
                key={w.name}
                className={clsx("col col--4", styles.whiteboardCol)}
              >
                <a className={styles.logoWrapper} href={w.href} target="_blank">
                  <img src={useBaseUrl(w.img)} alt={w.name} />
                </a>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

function BreakSection() {
  return (
    <section>
      <br />
      <br />
      <br />
      <br />
    </section>
  );
}

function CNCFSection() {
  return (
    <section>
      <div className="container">
        <div className="container text--center">
          <h2 className={clsx("hero__subtitle", styles.poppinsFont)}>
            <Translate>We are a</Translate>{" "}
            <Link to="https://cncf.io/">
              <Translate>Cloud Native Computing Foundation</Translate>
            </Link>{" "}
            <Translate>sandbox project</Translate>
          </h2>
          <br />
          <div>
            <img
              className={styles.cncfLogo}
              alt="CNCF themed image"
              src="/img/cncf-color.png"
            />
          </div>
        </div>
      </div>
    </section>
  );
}

function SubscribeSection() {
  return (
    <section>
      <div className="container text--center">
        <h2
          className={clsx("text--center")}
          style={{ color: "var(--ifm-color-primary)" }}
        >
          <Translate>Subscribe to Newsletter</Translate>
        </h2>
        <div className="container text--center">
          <Form />
        </div>
      </div>
    </section>
  );
}

export default function Home(): JSX.Element {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={`${siteConfig.title} - ${siteConfig.tagline}`}
      description="KCL is an open-source constraint-based record & functional programming language mainly used in configuration and policy scenarios."
    >
      <BreakSection />
      <HomepageHeader />
      <BreakSection />
      <FeaturesSection />
      <BreakSection />
      <ExampleSection />
      <BreakSection />
      <ToolSection />
      <BreakSection />
      <IntegrationSection />
      <BreakSection />
      <PartnerSection />
      <BreakSection />
      <CNCFSection />
      <BreakSection />
      <SubscribeSection />
      <BreakSection />
    </Layout>
  );
}
