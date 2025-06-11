const withPWA = require('next-pwa')({
  dest: 'public',
  disable: process.env.NODE_ENV === 'development',
  runtimeCaching: [
    {
      urlPattern: /^\/ipfs\/[^/]+$/,
      handler: 'NetworkFirst',
      options: {
        cacheName: 'ipfs-cache',
        expiration: { maxEntries: 20 }
      }
    }
  ]
});

module.exports = withPWA({});
