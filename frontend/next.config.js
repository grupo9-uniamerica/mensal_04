/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  async rewrites() {
    return {
      beforeFiles: [
        {
          source: '/api/rooms',
          destination: 'http://backend.backend-dev.svc.cluster.local:8080/rooms/',
        },
        {
          source: '/api/rooms/:path*',
          destination: 'http://backend.backend-dev.svc.cluster.local:8080/rooms/:path*/',
        },
        {
          source: '/api/reservations',
          destination: 'http://backend.backend-dev.svc.cluster.local:8080/reservations/',
        },
        {
          source: '/api/reservations/:path*',
          destination: 'http://backend.backend-dev.svc.cluster.local:8080/reservations/:path*/',
        },
        {
          source: '/api/token',
          destination: 'http://backend.backend-dev.svc.cluster.local:8080/token/',
        },
        {
          source: '/token',
          destination: 'http://backend.backend-dev.svc.cluster.local:8080/token/',
        },
      ],
    };
  },
};

module.exports = nextConfig;
