/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    return [
      {
        source: '/rooms/:path*',
        destination: 'http://frontend.local/rooms/:path*',
      },
      {
        source: '/reservations/:path*',
        destination: 'http://frontend.local/reservations/:path*',
      },
      {
        source: '/token',
        destination: 'http://frontend.local/token',
      },
    ];
  },
};

module.exports = nextConfig;
