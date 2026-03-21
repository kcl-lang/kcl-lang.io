import React from 'react';
import OriginalDocItem from '@theme-original/DocItem';
import { useDoc } from '@docusaurus/theme-common';

export default function DocItem(props) {
  const { metadata } = useDoc();
  const commit = metadata?.lastUpdatedCommit;

  return (
    <>
      <OriginalDocItem {...props} />
      {commit && (
        <div style={{
          marginTop: '2em',
          padding: '0.75em 1em',
          background: '#f6f8fa',
          border: '1px solid #e1e4e8',
          borderRadius: '6px',
          fontSize: '0.95em',
          color: '#555',
        }}>
          <strong>Last updated commit:</strong> <code>{commit}</code>
        </div>
      )}
    </>
  );
}