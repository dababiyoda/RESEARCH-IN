const withPWA = require('next-pwa')({
  dest: 'public',
  disable: process.env.NODE_ENV === 'development'
})

/** @type {import('next').NextConfig} */
module.exports = withPWA({
  reactStrictMode: true,
  experimental: { appDir: true }
})
