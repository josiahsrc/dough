import { Config } from '@stencil/core';
import { reactOutputTarget } from '@stencil/react-output-target';

export const config: Config = {
  namespace: 'dough-js',
  extras: {
    enableImportInjection: true,
  },
  outputTargets: [
    {
      type: 'dist',
      esmLoaderPath: '../loader',
    },
    {
      type: 'docs-readme',
    },
    {
      type: 'www',
      serviceWorker: null, // disable service workers
    },
    reactOutputTarget({
      componentCorePackage: 'dough-js',
      proxiesFile: '../dough-react/lib/components/stencil-generated/index.ts',
    }),
  ],
};
