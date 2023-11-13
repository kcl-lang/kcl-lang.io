import React, { useCallback, useEffect, useState } from "react";
import useWindowWidth from "@theme/useWindowWidth";
import clsx from "clsx";
import Highlight from "../Highlight";
import Chevron from "@theme/Chevron";
import seCss from "../../css/section.module.css";
import shCss from "../../css/index/showcase.module.css";
import Translate from "@docusaurus/Translate";

const S = [3, 5, 19, 31];
const M = [3, 5, 19, 31];
const L = [4, 5, 19, 31];

const getTopByIndex = (m: number[], index: 1 | 2 | 3 | 4): number => {
  const scale = {
    1: 20 * (m[0] ?? 0),
    2: -25 * (m[1] ?? 0),
    3: -25 * (m[2] ?? 0),
    4: -25 * (m[3] ?? 0),
  };

  return scale[index] ?? 0;
};

const configExample = `import base.pkg.kusion_models.kube.frontend

server: frontend.Server {
    image = "nginx"
}`;

const schemaExample = `schema Server:
    """Server is the abstraction of Deployment and StatefulSet.
    image: str, default is Undefined, required.
        Image name. More info: https://kubernetes.io/docs/concepts/containers/images.
    replicas: int, default is 1, required.
        Number of desired pods. This is a pointer to distinguish between explicit zero and not specified. Defaults to 1.
    labels: {str:str}, default is Undefined, optional.
        Labels is a map of string keys and values that can be used to organize and categorize (scope and select) objects.
    """
    image: str
    replicas: int = option("replicas") or 1
    labels?: {str:str}
`;

const LambdaExample = `import base.pkg.kusion_models.kube.frontend

genLocalityLabels = lambda cluster: str, app: str -> {str:str} {
    {
        "cluster.x-k8s.io/cluster-name" = cluster
        "app.kubernetes.io/name" = app
    }
}
server: frontend.Server {
    labels: genLocalityLabels("my-cluster", "nginx")
}
`;

const ruleExample = `import regex

rule ServerRule for Server:
    1 <= replicas < 20, "replica should be in range [1, 20)"
    regex.match(image, r"^([a-z0-9\.\:]+)\.([a-z]+)\:([a-z0-9]+)\/([a-z0-9\.]+)\/([a-z0-9-_.:]+)$"), "image name should satisfy the \`REPOSITORY:TAG\` form"

ServerRule()
`;

type Index = 1 | 2 | 3 | 4;

export const ExampleScroller = () => {
  const [top, setTop] = useState(S);
  const [index, setIndex] = useState<Index>(1);
  const windowWidth = useWindowWidth();
  const handleClick1 = useCallback(() => {
    setIndex(1);
  }, []);
  const handleClick2 = useCallback(() => {
    setIndex(2);
  }, []);
  const handleClick3 = useCallback(() => {
    setIndex(3);
  }, []);
  const handleClick4 = useCallback(() => {
    setIndex(4);
  }, []);
  const handleUpClick = useCallback(() => {
    setIndex(Math.max(index - 1, 1) as Index);
  }, [index]);
  const handleDownClick = useCallback(() => {
    setIndex(Math.min(index + 1, 4) as Index);
  }, [index]);

  useEffect(() => {
    if (windowWidth != null && windowWidth < 622) {
      setTop(S);
      return;
    }

    if (windowWidth != null && windowWidth < 800) {
      setTop(M);
      return;
    }

    setTop(L);
  }, [windowWidth]);

  return (
    <section
      className={clsx(
        seCss.section,
        seCss["section--inner"],
        seCss["section--center"],
        seCss["section--showcase"],
      )}
    >
      <div className={shCss.showcase}>
        <div className={shCss.showcase__inner}>
          <div
            className={clsx(shCss.showcase__chevron)}
            onClick={handleUpClick}
            style={{ visibility: index === 1 ? "hidden" : "visible" }}
          >
            <Chevron />
          </div>
          <div className={clsx(shCss.showcase__left)}>
            <div
              className={clsx(
                shCss.showcase__offset,
                shCss[`showcase__${index}`],
              )}
              style={{ top: getTopByIndex(top, index) }}
            >
              <Highlight code={configExample} />
              <Highlight code={`-- Config\n${configExample}`} />
              <Highlight code={schemaExample} />
              <Highlight code={`-- Schema\n${schemaExample}`} />
              <Highlight code={LambdaExample} />
              <Highlight code={`-- Lambda\n${LambdaExample}`} />
              <Highlight code={ruleExample} />
              <Highlight code={`-- Rule\n${ruleExample}`} />
            </div>
          </div>
          <div
            className={clsx(
              shCss.showcase__chevron,
              shCss["showcase__chevron--bottom"],
            )}
            onClick={handleDownClick}
            style={{ visibility: index === 4 ? "hidden" : "visible" }}
          >
            <Chevron />
          </div>
          <div className={shCss.showcase__right}>
            <div
              className={clsx(shCss.showcase__button, {
                [shCss["showcase__button--active"]]: index === 1,
              })}
              onClick={handleClick1}
            >
              <h3 className={shCss.showcase__header}>Config</h3>
              <p className={shCss.showcase__description}>
                <Translate>
                  Start your cloud-native journey with scalable config
                </Translate>
              </p>
            </div>

            <div
              className={clsx(shCss.showcase__button, {
                [shCss["showcase__button--active"]]: index === 2,
              })}
              onClick={handleClick2}
            >
              <h3 className={shCss.showcase__header}>Schema</h3>
              <p className={shCss.showcase__description}>
                <Translate>
                  Abstract your schema-centric model with static typing
                </Translate>
              </p>
            </div>

            <div
              className={clsx(shCss.showcase__button, {
                [shCss["showcase__button--active"]]: index === 3,
              })}
              onClick={handleClick3}
            >
              <h3 className={shCss.showcase__header}>Lambda</h3>
              <p className={shCss.showcase__description}>
                <Translate>
                  Define and reuse your config and logic through small function
                  fragments
                </Translate>
              </p>
            </div>
            <div
              className={clsx(shCss.showcase__button, {
                [shCss["showcase__button--active"]]: index === 4,
              })}
              onClick={handleClick4}
            >
              <h3 className={shCss.showcase__header}>Rule</h3>
              <p className={shCss.showcase__description}>
                <Translate>
                  Define your environmental rules to ensure consistency and
                  stability
                </Translate>
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};
