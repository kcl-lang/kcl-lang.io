/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import React from "react";
import BlogLayout from "@theme/BlogLayout";
import BlogListPaginator from "@theme/BlogListPaginator";
import type { Props } from "@theme/BlogListPage";
import { ThemeClassNames } from "@docusaurus/theme-common";
import Link from "@docusaurus/Link";
import ChangelogItem from "@theme/ChangelogItem";

import styles from "./styles.module.css";

export default function ChangelogList(props: Props): JSX.Element {
  const { metadata, items, sidebar } = props;
  const { blogDescription, blogTitle } = metadata;

  return (
    <BlogLayout
      title={blogTitle}
      description={blogDescription}
      wrapperClassName={ThemeClassNames.wrapper.blogPages}
      pageClassName={ThemeClassNames.page.blogListPage}
      searchMetadata={{
        // assign unique search tag to exclude this page from search results!
        tag: "blog_posts_list",
      }}
      sidebar={sidebar}
    >
      <header className="margin-bottom--lg">
        <h1 style={{ fontSize: "3rem" }}>{blogTitle}</h1>
      </header>
      {items.map(({ content: BlogPostContent }) => (
        <ChangelogItem
          key={BlogPostContent.metadata.permalink}
          frontMatter={BlogPostContent.frontMatter}
          assets={BlogPostContent.assets}
          metadata={BlogPostContent.metadata}
          truncated={BlogPostContent.metadata.truncated}
        >
          <BlogPostContent />
        </ChangelogItem>
      ))}
      <BlogListPaginator metadata={metadata} />
    </BlogLayout>
  );
}
